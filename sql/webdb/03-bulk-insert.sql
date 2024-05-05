-- always use right database
USE bbpet;
GO

-- bulk insert Employee
BULK INSERT Employee
FROM '/docker-entrypoint-initdb.d/data/csv/Employee.tsv'
WITH
(
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
)

-- bulk insert ShopItem
BULK INSERT ShopItem
    FROM '/docker-entrypoint-initdb.d/data/csv/ShopItem.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

-- bulk insert service
BULK INSERT Service
    FROM '/docker-entrypoint-initdb.d/data/csv/Service.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

-- bulk insert Product
BULK INSERT Product
    FROM '/docker-entrypoint-initdb.d/data/csv/Product.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

-- bulk insert Product Inventory
BULK INSERT ProductInventory
    FROM '/docker-entrypoint-initdb.d/data/csv/ProductInventory.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

-- bulk insert customer

BULK INSERT Customer
    FROM '/docker-entrypoint-initdb.d/data/csv/Customer.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

-- bulk insert Order
BULK INSERT [Order]
    FROM '/docker-entrypoint-initdb.d/data/csv/Order.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )


-- bulk insert Sourcing
BULK INSERT Sourcing
    FROM '/docker-entrypoint-initdb.d/data/csv/Sourcing.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )


-- bulk insert InventorySourcing
BULK INSERT InventorySourcing
    FROM '/docker-entrypoint-initdb.d/data/csv/InventorySourcing.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )


-- bulk insert delivery
BULK INSERT Delivery
    FROM '/docker-entrypoint-initdb.d/data/csv/Delivery.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

-- bulk insert Shipping
BULK INSERT Shipping
    FROM '/docker-entrypoint-initdb.d/data/csv/Shipping.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )


-- bulk insert PetServicing
BULK INSERT PetServicing
    FROM '/docker-entrypoint-initdb.d/data/csv/PetServicing.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )

-- bulk insert OrderItem
BULK INSERT OrderItem
    FROM '/docker-entrypoint-initdb.d/data/csv/OrderItem.tsv'
    WITH
    (
    FIELDTERMINATOR = '\t',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    )























