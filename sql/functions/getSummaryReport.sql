/**
  orderCount, productsOrdered, servicesOrdered, totalRevenue, productRevenue, serviceRevenue,
  discountAmount, deliveriesSuccess, deliveriesFailed, meanDeliveryHours, meanPendingHours
 */


DECLARE @fromTime DATETIME, @toTime DATETIME, @hourInterval INT;

SET @fromTime = '1970-01-01T00:00:00';
SET @toTime = '2050-01-01T00:00:00';
SET @hourInterval = 24;

-- output
DECLARE @Summary TABLE (
    intervalNumber INT,
    orderCount INT,
    productsOrdered INT,
    servicesOrdered INT,
    totalRevenue DECIMAL(20, 2),
    productRevenue DECIMAL(20, 2),
    serviceRevenue DECIMAL(20, 2),
    discountAmount DECIMAL(20, 2),
    deliveriesSuccess INT,
    deliveryFailed INT,
    meanDeliveryHours DECIMAL(20, 2),
    meanPendingHours DECIMAL(20, 2)
)

DECLARE @batchSize INT = 50 * 24 / @hourInterval

DECLARE @orderId INT, @orderTime DATETIME, @orderStatus VARCHAR;

DECLARE OrderCursor CURSOR FOR
    SELECT
        O.id as orderId,
        O.createdTime as orderTime,
        O.status as orderStatus
    FROM
        Customer C
        LEFT JOIN [Order] O ON O.customerId = C.id
    WHERE
        O.status NOT IN ('INITIALIZING')
        AND O.createdTime >= @fromTime
        AND O.createdTime <= @toTime
    ORDER BY O.createdTime

/*DECLARE OrderCursor CURSOR FOR
SELECT
    O.id as orderId,
    O.createdTime as orderTime,
    O.status as orderStatus
FROM
    [Order] O
ORDER BY createdTime*/


OPEN OrderCursor;

DECLARE @BatchData TABLE (
    intervalNumber INT,
    orderId INT,
    orderTime DATETIME,
    orderStatus VARCHAR(255)
)



FETCH NEXT FROM OrderCursor
    INTO @orderId, @orderTime, @orderStatus;


DECLARE @chunkNumber INT = 1;
DECLARE @intervalNumber INT = FLOOR(DATEDIFF_BIG(SECOND, @fromTime, @orderTime) / 3600.0 / @hourInterval);

INSERT INTO @BatchData (intervalNumber, orderId, orderTime, orderStatus)
VALUES (@intervalNumber, @orderId, @orderTime, @orderStatus)

WHILE @@FETCH_STATUS = 0
BEGIN

    FETCH NEXT FROM OrderCursor
        INTO @orderId, @orderTime, @orderStatus;

    DECLARE @nextIntervalNumber INT = FLOOR(DATEDIFF_BIG(SECOND, @fromTime, @orderTime) / 3600.0 / @hourInterval);

    IF (@nextIntervalNumber > @intervalNumber)
    BEGIN
        SET @intervalNumber = @nextIntervalNumber;
        SET @chunkNumber = @chunkNumber + 1
    END

    IF (@chunkNumber > @batchSize OR @@FETCH_STATUS <> 0)
    BEGIN

        -- print process batch with chunk number
        PRINT 'Processing batch of ' + CAST(@chunkNumber - 1 AS VARCHAR) + ' chunks';

        INSERT INTO @Summary(intervalNumber, orderCount, productsOrdered, servicesOrdered, totalRevenue, productRevenue,
                             serviceRevenue, discountAmount, deliveriesSuccess, deliveryFailed, meanDeliveryHours, meanPendingHours)
        SELECT
            BD.intervalNumber as intervalNumber,
            COUNT(DISTINCT BD.orderId)                          as orderCount,
            SUM(IIF(OI.type = 'PRODUCT', OI.quantity, 0))       as productsOrdered,
            SUM(IIF(OI.type = 'SERVICE', OI.quantity, 0))       as servicesOrdered,
            SUM(OI.quantity * OI.priceEach * (1 - OI.discount)) as totalRevenue,
            SUM(IIF(OI.type = 'PRODUCT', OI.quantity * OI.priceEach * (1 - OI.discount), 0)) as productRevenue,
            SUM(IIF(OI.type = 'SERVICE', OI.quantity * OI.priceEach * (1 - OI.discount), 0)) as serviceRevenue,
            SUM(OI.quantity * OI.priceEach * OI.discount)       as discountAmount,
            SUM(IIF(DL.status = 'SUCCESS', 1, 0))                  as deliveriesSuccess,
            SUM(IIF(DL.status = 'FAILED', 1, 0))                   as deliveriesFailed,
            AVG(DATEDIFF_BIG(SECOND, DL.startTime, DL.endTime) / 3600.0)    as meanDelieryHours,
            AVG(DATEDIFF_BIG(SECOND, BD.orderTime, DL.startTime) / 3600.0)   as meanPendingHours
        FROM
            @BatchData BD
            LEFT JOIN  OrderItem OI on OI.orderId = BD.orderId
            LEFT JOIN Delivery DL on DL.id = OI.deliveryId
        GROUP BY BD.intervalNumber

        -- delete the batch data
        DELETE FROM @BatchData;
        SET @chunkNumber = 1;
    END

    INSERT INTO @BatchData (intervalNumber, orderId, orderTime, orderStatus)
    VALUES (@intervalNumber, @orderId, @orderTime, @orderStatus);
END

SELECT * FROM @Summary;

CLOSE OrderCursor;
DEALLOCATE OrderCursor;