DECLARE
    @intervalHours INT = 24,
    @fromTime DATETIME = '1970-01-01T00:00:00',
    @toTime DATETIME = '2050-01-01T00:30:00'

DECLARE @Report TABLE (
                        intervalNumber INT,
                        orderCount INT,
                        productsOrdered INT,
                        servicesOrdered INT,
                        totalRevenue DECIMAL(20, 2),
                        productRevenue DECIMAL(20, 2),
                        serviceRevenue DECIMAL(20, 2),
                        discountAmount DECIMAL(20, 2),
                        deliveriesSuccess INT,
                        deliveriesFailed INT,
                        meanDeliveryHours DECIMAL(20, 2),
                        meanPendingHours DECIMAL(20, 2)
                    );


DECLARE
    @orderId INT,
    @orderTime DATETIME,
    @orderStatus VARCHAR(50),
    @itemQuantity INT,
    @priceEach DECIMAL(20, 2),
    @discount DECIMAL(20, 2),
    @itemType VARCHAR(50),
    @deliveryStart DATETIME,
    @deliveryEnd DATETIME,
    @deliveryStatus VARCHAR(50);


DECLARE OrderItemCursor CURSOR FOR
    SELECT
        OD.id as orderId,
        OD.createdTime as orderTime,
        OD.status as orderStatus,
        OI.quantity as itemQuantity,
        OI.priceEach as priceEach,
        OI.discount as discount,
        OI.type as itemType,
        DL.startTime as deliveryStart,
        DL.endTime as deliveryEnd,
        DL.status as deliveryStatus
    FROM
        [Order] OD
            LEFT JOIN OrderItem OI ON OI.orderId = OD.id
            LEFT JOIN Delivery DL ON DL.id = OI.deliveryId
    WHERE
        OD.status NOT IN ('INITIALIZING')
      AND OD.createdTime >= @fromTime
      AND OD.createdTime <= @toTime
    ORDER BY OD.createdTime, OD.id;

OPEN OrderItemCursor;

FETCH NEXT FROM OrderItemCursor
    INTO @orderId, @orderTime, @orderStatus,
        @itemQuantity, @priceEach, @discount, @itemType,
        @deliveryStart, @deliveryEnd, @deliveryStatus;


DECLARE @intervalNumber INT = FLOOR(DATEDIFF_BIG(SECOND, @fromTime, @orderTime) / 3600.0 / @intervalHours);
DECLARE @orderCount INT = 0;
DECLARE @productsOrdered INT = 0;
DECLARE @servicesOrdered INT = 0;
DECLARE @totalRevenue DECIMAL(20, 2) = 0;
DECLARE @productRevenue DECIMAL(20, 2) = 0;
DECLARE @serviceRevenue DECIMAL(20, 2) = 0;
DECLARE @discountAmount DECIMAL(20, 2) = 0;
DECLARE @deliveriesSuccess INT = 0;
DECLARE @deliveriesFailed INT = 0;

DECLARE @totalDeliveryHours DECIMAL(20, 2) = 0;
DECLARE @totalPendingHours DECIMAL(20, 2) = 0;

DECLARE @intervalElementCount INT = 0;

DECLARE @currentOrderId INT = -1;

WHILE @@FETCH_STATUS = 0
    BEGIN
        -- aggregate order count
        IF @orderId > @currentOrderId
            BEGIN
                SET @currentOrderId = @orderId;
                SET @orderCount = @orderCount + 1;
            END

        -- aggregate other metrics
        SET @productsOrdered = @productsOrdered + IIF(@itemType = 'PRODUCT', 1, 0);
        SET @servicesOrdered = @servicesOrdered + IIF(@itemType = 'SERVICE', 1, 0);
        SET @totalRevenue = @totalRevenue + @priceEach * @itemQuantity * (1 - @discount);
        SET @productRevenue = @productRevenue + IIF(@itemType = 'PRODUCT', @priceEach * @itemQuantity * (1 - @discount), 0);
        SET @serviceRevenue = @serviceRevenue + IIF(@itemType = 'SERVICE', @priceEach * @itemQuantity * (1 - @discount), 0);
        SET @discountAmount = @discountAmount + @priceEach * @itemQuantity * @discount;
        SET @deliveriesSuccess = @deliveriesSuccess + IIF(@deliveryStatus = 'SUCCESS', 1, 0);
        SET @deliveriesFailed = @deliveriesFailed + IIF(@deliveryStatus = 'FAILED', 1, 0);
        SET @totalDeliveryHours = @totalDeliveryHours + DATEDIFF_BIG(SECOND, @deliveryStart, @deliveryEnd) / 3600.0;
        SET @totalPendingHours = @totalPendingHours + DATEDIFF_BIG(SECOND, @orderTime, @deliveryStart) / 3600.0;
        SET @intervalElementCount = @intervalElementCount + 1;

        -- fetch next
        FETCH NEXT FROM OrderItemCursor
            INTO @orderId, @orderTime, @orderStatus,
                @itemQuantity, @priceEach, @discount, @itemType,
                @deliveryStart, @deliveryEnd, @deliveryStatus;

        DECLARE @nextIntervalNumber INT = FLOOR(DATEDIFF_BIG(SECOND, @fromTime, @orderTime) / 3600.0 / @intervalHours);
        IF @nextIntervalNumber > @intervalNumber OR @@FETCH_STATUS <> 0
            BEGIN
                INSERT INTO @Report
                VALUES (
                           @intervalNumber,
                           @orderCount,
                           @productsOrdered,
                           @servicesOrdered,
                           @totalRevenue,
                           @productRevenue,
                           @serviceRevenue,
                           @discountAmount,
                           @deliveriesSuccess,
                           @deliveriesFailed,
                           IIF(@intervalElementCount > 0, @totalDeliveryHours / @intervalElementCount, 0),
                           IIF(@intervalElementCount > 0, @totalPendingHours / @intervalElementCount, 0)
                       );
                SET @intervalNumber = @nextIntervalNumber;
            END
    END

CLOSE OrderItemCursor;
DEALLOCATE OrderItemCursor;

SELECT * FROM @Report;