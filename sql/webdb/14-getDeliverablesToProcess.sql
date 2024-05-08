USE bbpet;
GO;

CREATE PROCEDURE getDeliverablesToProcess
    @fromTime DATETIME = '2020-01-01T00:00:00',
    @toTime DATETIME = '2050-01-01T00:00:00',
    @fromPrice DECIMAL(20, 2) = 0.00,
    @toPrice DECIMAL(20, 2) = 999999.00,
    @searchColumn VARCHAR(255) = 'N/A',
    @searchValue VARCHAR(255) = 'N/A',
    @sortColumn VARCHAR(255) = 'createdTime',
    @sortOrder VARCHAR(255) = 'DESC'
AS
BEGIN

    WITH OrderItemInfo AS (
        SELECT
            OD.id as orderId,
            OD.createdTime as createdTime,
            CM.name as customerName,
            OD.deliveryAddress as address,
            OD.phoneNumber as phoneNumber,
            OI.id  as orderItemId,
            OI.type as itemType,
            OI.shopItemId as shopItemId,
            OI.priceEach as priceEach,
            OI.quantity as quantity,
            OI.discount as discount,
            OI.sourcingId as sourcingId,
            ISNULL(DL.status, 'NOT_EXISTED') as deliveryStatus
        FROM
            [Order] OD
                LEFT JOIN Customer CM on CM.id = OD.customerId
                LEFT JOIN OrderItem OI on OI.orderId = OD.id
                LEFT JOIN Delivery DL on DL.id = OI.deliveryId
        WHERE
            OD.status IN ('CONFIRMED', 'DELIVERING')
          AND (DL.status IS NULL OR DL.status IN ('PENDING', 'IN_PROGRESS'))
          AND OD.createdTime BETWEEN @fromTime AND @toTime
    )

    SELECT *
    FROM (
             SELECT
                 orderId,
                 'PRODUCT' as itemType,
                 STRING_AGG(orderItemId, ', ') AS orderItemIds,
                 SUM(OII.quantity * OII.priceEach * (1 - OII.discount)) as totalPrice,
                 createdTime,
                 customerName,
                 address,
                 phoneNumber,
                 deliveryStatus,
                 IV.storeLocation as sourceLocation
             FROM
                 OrderItemInfo OII
                     LEFT JOIN Sourcing SR on SR.id = OII.sourcingId
                     LEFT JOIN InventorySourcing IR on IR.sourcingId = SR.id
                     LEFT JOIN ProductInventory IV on IV.id = IR.productInventoryId
             WHERE itemType = 'PRODUCT'
             GROUP BY
                 OII.orderId, OII.createdTime, OII.customerName, OII.address, OII.phoneNumber, OII.deliveryStatus,
                 IV.storeLocation
             HAVING
                 SUM(OII.quantity * OII.priceEach * (1 - OII.discount)) BETWEEN @fromPrice AND @toPrice

             UNION

             SELECT
                 orderId,
                 'SERVICE' as itemType,
                 STRING_AGG(orderItemId, ', '),
                 SUM(OII.quantity * OII.priceEach * (1 - OII.discount)) as totalPrice,
                 createdTime,
                 customerName,
                 address,
                 phoneNumber,
                 deliveryStatus,
                 'N/A' as sourceLocation
             FROM OrderItemInfo OII
             WHERE itemType = 'SERVICE'
             GROUP BY
                 OII.orderId, OII.createdTime, OII.customerName, OII.address, OII.phoneNumber, OII.deliveryStatus,
                 OII.shopItemId
             HAVING
                 SUM(OII.quantity * OII.priceEach * (1 - OII.discount)) BETWEEN @fromPrice AND @toPrice
         ) AS Result

    WHERE
        CASE @searchColumn
            WHEN 'orderId' THEN CAST(orderId AS VARCHAR(255))
            WHEN 'itemType' THEN itemType
            WHEN 'totalPrice' THEN CAST(totalPrice AS VARCHAR(255))
            WHEN 'createdTime' THEN CAST(createdTime AS VARCHAR(255))
            WHEN 'customerName' THEN customerName
            WHEN 'address' THEN address
            WHEN 'phoneNumber' THEN phoneNumber
            WHEN 'deliveryStatus' THEN deliveryStatus
            WHEN 'sourceLocation' THEN sourceLocation
            ELSE 'N/A'
            END LIKE '%' + @searchValue + '%'

    ORDER BY
        CASE WHEN @sortColumn = 'orderId' AND @sortOrder = 'ASC' THEN orderId END ASC,
        CASE WHEN @sortColumn = 'orderId' AND @sortOrder = 'DESC' THEN orderId END DESC,

        CASE WHEN @sortColumn = 'itemType' AND @sortOrder = 'ASC' THEN itemType END ASC,
        CASE WHEN @sortColumn = 'itemType' AND @sortOrder = 'DESC' THEN itemType END DESC,

        CASE WHEN @sortColumn = 'totalPrice' AND @sortOrder = 'ASC' THEN totalPrice END ASC,
        CASE WHEN @sortColumn = 'totalPrice' AND @sortOrder = 'DESC' THEN totalPrice END DESC,

        CASE WHEN @sortColumn = 'createdTime' AND @sortOrder = 'ASC' THEN createdTime END ASC,
        CASE WHEN @sortColumn = 'createdTime' AND @sortOrder = 'DESC' THEN createdTime END DESC,

        CASE WHEN @sortColumn = 'customerName' AND @sortOrder = 'ASC' THEN customerName END ASC,
        CASE WHEN @sortColumn = 'customerName' AND @sortOrder = 'DESC' THEN customerName END DESC,

        CASE WHEN @sortColumn = 'address' AND @sortOrder = 'ASC' THEN address END ASC,
        CASE WHEN @sortColumn = 'address' AND @sortOrder = 'DESC' THEN address END DESC,

        CASE WHEN @sortColumn = 'phoneNumber' AND @sortOrder = 'ASC' THEN phoneNumber END ASC,
        CASE WHEN @sortColumn = 'phoneNumber' AND @sortOrder = 'DESC' THEN phoneNumber END DESC,

        CASE WHEN @sortColumn = 'deliveryStatus' AND @sortOrder = 'ASC' THEN deliveryStatus END ASC,
        CASE WHEN @sortColumn = 'deliveryStatus' AND @sortOrder = 'DESC' THEN deliveryStatus END DESC,

        CASE WHEN @sortColumn = 'sourceLocation' AND @sortOrder = 'ASC' THEN sourceLocation END ASC,
        CASE WHEN @sortColumn = 'sourceLocation' AND @sortOrder = 'DESC' THEN sourceLocation END DESC
END
go












