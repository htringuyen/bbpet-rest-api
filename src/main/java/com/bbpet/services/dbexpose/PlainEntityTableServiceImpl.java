package com.bbpet.services.dbexpose;

import jakarta.persistence.*;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Selection;
import jakarta.persistence.metamodel.Attribute;
import jakarta.persistence.metamodel.EntityType;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service("plainEntityTableService")
@Transactional
public class PlainEntityTableServiceImpl implements PlainEntityTableService {
    private static final Logger LOGGER = LoggerFactory.getLogger(PlainEntityTableServiceImpl.class);

    private final HashMap<Class<?>, PlainEntityTable> plainTables = new HashMap<>();

    private final EntityManager em;

    public PlainEntityTableServiceImpl(EntityManager em) {
        this.em = em;
        initialize();
    }

    private void initialize() {
        for (var entityType: em.getMetamodel().getEntities()) {
            var entityClass = entityType.getJavaType();

            String tableName;
            String schema;
            if (entityClass.isAnnotationPresent(Table.class)) {
                var tableAnnotation = entityClass.getAnnotation(Table.class);
                tableName = tableAnnotation.name();
                schema = tableAnnotation.schema();
            } else {
                tableName = entityType.getName();
                schema = "";
            }

            var idAttr = getSingleIdAttributeFrom(entityType);

            var columns = getColumns(entityType, em);

            var table = new PlainEntityTableImpl(tableName, schema, entityClass, idAttr.getName(), columns);

            plainTables.put(entityClass, table);
        }
    }


    private List<PlainEntityColumn> getColumns(EntityType<?> entityType, EntityManager em) {
        var columnList = new ArrayList<PlainEntityColumn>();

        var entityClass = entityType.getJavaType();

        LOGGER.debug("Get plain entity columns for entity class {}", entityClass);

        for (var field: entityClass.getDeclaredFields()) {
            LOGGER.debug("Get column from field: {}", field);
            if (field.isAnnotationPresent(Column.class)) {
                var columnName = field.getAnnotation(Column.class).name();
                var attrName = field.getName();
                var attribute = entityType.getAttribute(attrName);
                var column = new PlainEntityColumnImpl(
                        false, attribute.getJavaType(), columnName, attrName, null);
                columnList.add(column);

            } else if (field.isAnnotationPresent(JoinColumn.class)) {

                var columnName = field.getAnnotation(JoinColumn.class).name();
                var attrName = field.getName();
                var attribute = entityType.getAttribute(attrName);

                if (!attribute.isAssociation()) {
                    throw new IllegalStateException("The attribute of join column but be an association");
                }

                var refEntityType = em.getMetamodel().entity(attribute.getJavaType());
                var refIdAttr = getSingleIdAttributeFrom(refEntityType);

                var column = new PlainEntityColumnImpl(
                        true, refIdAttr.getJavaType(), columnName, attrName, refIdAttr.getName());

                columnList.add(column);
            }
        }

        return columnList;
    }


    private <X> Attribute<? super X, ?> getSingleIdAttributeFrom(EntityType<X> entityType) {
        if (!entityType.hasSingleIdAttribute()) {
            throw new IllegalStateException("Unsupported multiple id attributes entity");
        }

        return entityType.getId(entityType.getIdType().getJavaType());
    }


    @Override
    public List<Map<String, String>> findAllByParams(Map<String, String> params, Class<?> entityClass) {

        var plainTable = plainTables.get(entityClass);

        if (plainTable == null) {
            throw new IllegalArgumentException("Not supported entity class: " + entityClass);
        }

        var builder = em.getCriteriaBuilder();
        var criteriaQuery = builder.createQuery(Object[].class);

        var root = criteriaQuery.from(plainTable.getEntityClass());
        var criteria = builder.conjunction();

        for (var param: params.entrySet()) {
            var name = param.getKey();

            var column = plainTable.getPlainColumn(name).orElse(null);
            if (column != null) {
                var value = param.getValue();

                if (column.isBasicColumn()) {
                    var expression = root.get(column.getAttributeName()).as(String.class);
                    var predicate = builder.like(expression, decorateWildcard(value));
                    criteria = builder.and(criteria, predicate);
                } else if (column.isJoinColumn()) {
                    var expression = root.get(column.getAttributeName())
                            .get(column.getReferenceIdAttributeName()).as(String.class);
                    var predicate = builder.like(expression, decorateWildcard(value));
                    criteria = builder.and(criteria, predicate);
                } else {
                    throw new IllegalStateException("Column must be of either basic or join type");
                }
            }
        }

        var selections = getAllColumnSelections(root, plainTable.getPlainColumns());

        criteriaQuery.select(builder.array(selections)).where(criteria);

        return em.createQuery(criteriaQuery)
                .getResultStream()
                .map(plainTable::createStringRowMap)
                .toList();
    }


    private String decorateWildcard(String s) {
        return "%" + s + "%";
    }


    @Override
    public int updateRow(Object id, Map<String, String> params, Class<?> entityClass) {

        var plainTable = plainTables.get(entityClass);
        if (plainTable == null) {
            throw new IllegalArgumentException("Not supported entity class: " + entityClass);
        }

        var builder = em.getCriteriaBuilder();
        var criteriaUpdate = builder.createCriteriaUpdate(plainTable.getEntityClass());

        var root = criteriaUpdate.getRoot();

        for (var param: params.entrySet()) {
            var name = param.getKey();
            var column = plainTable.getPlainColumn(name).orElse(null);
            if (column != null) {
                var value = param.getValue();
                if (column.isBasicColumn()) {
                    criteriaUpdate.set(column.getAttributeName(), value);
                } else if (column.isJoinColumn()) {
                    var path = root.get(column.getAttributeName()).get(column.getReferenceIdAttributeName());
                    criteriaUpdate.set(path, value);
                } else {
                    throw new IllegalStateException("Column must be of either basic or join type");
                }
            }
        }

        var idMatch = builder.equal(root.get(plainTable.getIdAttributeName()), id);
        criteriaUpdate.where(idMatch);
        return em.createQuery(criteriaUpdate).executeUpdate();
    }


    private Map<String, String> findByIdFrom(PlainEntityTable table, Object id) {
        var builder = em.getCriteriaBuilder();
        var query = builder.createQuery();
        var root = query.from(table.getEntityClass());
        var entityId = root.get(table.getIdAttributeName());

        var columnSelections = getAllColumnSelections(root, table.getPlainColumns());
        query.select(builder.array(columnSelections)).where(builder.equal(entityId, id));

        return table.createStringRowMap((Object[]) em.createQuery(query).getSingleResult());
    }

    private Selection<?>[] getAllColumnSelections(Root<?> root, List<PlainEntityColumn> columns) {
        var selections = new Selection<?>[columns.size()];
        var index = 0;
        for (PlainEntityColumn column : columns) {
            if (column.isBasicColumn()) {
                var selection = root.get(column.getAttributeName());
                selections[index++] = selection;
            } else if (column.isJoinColumn()) {
                var selection = root.get(column.getAttributeName()).get(column.getReferenceIdAttributeName());
                selections[index++] = selection;
            } else {
                throw new IllegalStateException("Column must be of either basic or join type");
            }
        }
        return selections;
    }


    @Override
    public int createRow(Map<String, String> params, Class<?> entityClass) {
        var table = plainTables.get(entityClass);
        if (table == null) {
            throw new IllegalArgumentException("Not supported entity class: " + entityClass);
        }

        var columnNameList = new ArrayList<String>();
        var valueList = new ArrayList<String>();

        for (var param: params.entrySet()) {
            var column = table.getPlainColumn(param.getKey()).orElse(null);
            if (column != null) {
                String value;
                if (Number.class.isAssignableFrom(column.getValueType())) {
                    value = param.getValue();
                } else {
                    value = "'" + param.getValue() + "'";
                }

                columnNameList.add(column.getColumnName());
                valueList.add(value);
            }
        }

        var tableFullName = table.getSchema().isBlank()
                ? table.getTableName()
                : table.getSchema() + "." + table.getTableName();

        var columnStrTuple = String.join(", ", columnNameList);
        var valueStrTuple = String.join(", ", valueList);

        var queryString = String.format("""
                INSERT INTO %s (%s)
                VALUES (%s)
                """, tableFullName, columnStrTuple, valueStrTuple);

        LOGGER.debug("AutoGen InsertQuery: {}", queryString);

        var query = em.createNativeQuery(queryString);
        return query.executeUpdate();
    }


    @Override
    public int deleteRow(Object id, Class<?> entityClass) {
        var found = em.find(entityClass, id);
        if (found == null) {
            return 0;
        }

        em.remove(found);
        return 1;
    }


}

























