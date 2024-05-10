DECLARE @loopIndex INT = 1;
DECLARE @loopCount INT = 4;

WHILE @loopIndex <= @loopCount
BEGIN
    DECLARE @testDeliveryStatus VARCHAR(255);
    DECLARE @expectedOrderStatus VARCHAR(255);

    -- get the test delivery status
    SET @testDeliveryStatus =
        CASE
            WHEN @loopIndex = 1 THEN 'PENDING'
            WHEN @loopIndex = 2 THEN 'IN_PROGRESS'
            WHEN @loopIndex = 3 THEN 'FAILED'
            WHEN @loopIndex = 4 THEN 'SUCCESS'
        END;

    -- corresponding to the test delivery status, get the expected order status
    SET @expectedOrderStatus =
        CASE
            WHEN @testDeliveryStatus = 'PENDING' THEN 'DELIVERING'
            WHEN @testDeliveryStatus = 'IN_PROGRESS' THEN 'DELIVERING'
            WHEN @testDeliveryStatus = 'FAILED' THEN 'CANCELED'
            WHEN @testDeliveryStatus = 'SUCCESS' THEN 'SUCCESS'
        END;

    -- temporary table to store state
    DECLARE @Origin TABLE
    (
        orderId INT,
        deliveryId INT,
        orderStatus VARCHAR(255),
        deliveryStatus VARCHAR(255),
        deliveryCount INT,
        deliveryNumber INT
    );

    -- get delivery cohort
    INSERT INTO @Origin
    SELECT
        DISTINCT
            OD.id,
            DL.id,
            OD.status,
            DL.status,
            COUNT(DL.id) OVER(PARTITION BY OD.id) as deliveryCount,
            ROW_NUMBER() OVER(PARTITION BY OD.id ORDER BY DL.id) AS deliveryNumber
    FROM
        [Order] OD
        INNER JOIN OrderItem OI ON OI.orderId = OD.id
        INNER JOIN Delivery DL ON DL.id = OI.deliveryId
    WHERE
        DL.status <> @testDeliveryStatus

    DECLARE @rowsCount INT = (SELECT COUNT(*) FROM @Origin);

    -- if rows count = 0, no data to process, throw exception
    IF @rowsCount = 0
    BEGIN
        THROW 50000, 'Not enough data to process', 1;
    END


    -- if the test delivery status is 'SUCCESS', then we need to check a special case
    IF @testDeliveryStatus = 'SUCCESS'
    BEGIN
        UPDATE DL
        SET DL.status = 'SUCCESS'
        FROM
            Delivery DL
            INNER JOIN @Origin OG ON OG.deliveryId = DL.id
        WHERE
            OG.deliveryCount > 1 AND OG.deliveryNumber = 1;

        -- check if the order status still not equals to expected status
        DECLARE @specialCaseFailedCount INT;
        SELECT @specialCaseFailedCount = COUNT(*)
        FROM
            [Order] OD
            INNER JOIN @Origin OG ON OG.orderId = OD.id
            INNER JOIN Delivery DL ON DL.id = OG.deliveryId
        WHERE
            OD.status = 'SUCCESS' AND DL.status <> 'SUCCESS'; --AND OG.deliveryStatus <> 'SUCCESS';

        IF @specialCaseFailedCount > 0
        BEGIN
            PRINT 'Try do set one of the not succeeded deliveries of order to SUCCESS status'
            PRINT 'Expected order still not succeeded as there are other deliveries not succeeded'
            PRINT 'Actually found ' + CAST(@specialCaseFailedCount AS VARCHAR(255)) + ' orders updated to SUCCESS status'
            PRINT 'Test for special case of delivery status changed to success failed'
            PRINT '-----------------------------------'
        END
    END

    -- update delivery status to test status
    UPDATE DL
    SET DL.status = @testDeliveryStatus
    FROM
        Delivery DL
        INNER JOIN @Origin OG ON OG.deliveryId = DL.id;

    -- verify order status all equals to expected order status
    DECLARE @failedCount INT;

    SELECT @failedCount = COUNT(*)
    FROM
        [Order] OD
        INNER JOIN @Origin OG ON OG.orderId = OD.id
    WHERE
        OD.status <> @expectedOrderStatus;

    PRINT 'Test change delivery status to: ' + @testDeliveryStatus
    PRINT 'Expected order status: ' + @expectedOrderStatus

    IF @failedCount > 0
    BEGIN
        PRINT 'Actual order status: ' + @failedCount + ' orders failed to update to expected status'
    END

    IF @failedCount = 0
    BEGIN
        PRINT 'Test passed on dataset of ' + CAST(@rowsCount AS VARCHAR(255)) + ' rows'
        PRINT '-----------------------------------'
    END


    -- restore original delivery status and order status
    UPDATE DL
    SET DL.status = OG.deliveryStatus
    FROM
        Delivery DL
        INNER JOIN @Origin OG ON OG.deliveryId = DL.id;

    UPDATE OD
    SET OD.status = OG.orderStatus
    FROM
        [Order] OD
        INNER JOIN @Origin OG ON OG.orderId = OD.id;

    SET @loopIndex = @loopIndex + 1;
END
















