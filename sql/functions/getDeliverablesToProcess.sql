USE bbpet;
GO;

CREATE PROCEDURE getDeliverablesToProcess @fromTime DATETIME, @toTime DATETIME,
                                          @fromPrice DECIMAL(10, 2), @toPrice DECIMAL(10, 2)
AS
BEGIN
    SET @fromTime = ISNULL(@fromTime, '1970-01-01T00:00:00');
    SET @toTime = ISNULL(@toTime, '2050-01-01T00:00:00');
    SET @fromPrice = ISNULL(@fromPrice, 0.00);
    SET @toPrice = ISNULL(@toPrice, 999999.00);

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
    ORDER BY createdTime , orderId
END