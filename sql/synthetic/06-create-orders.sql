-- ############################################################################################################
-- # A script to random generate orders for customers
-- ############################################################################################################

-- always use the right database
USE bbpet;
GO

-- random seed
DECLARE @seed INT;
SET @seed = 42;

-- properties
DECLARE @discountMax DECIMAL(10, 2) = 0.2;

DECLARE @orderPerCustomerMax INT = 15;

DECLARE @inStoreAddress VARCHAR(255) = 'In-store, 123 Goldenwest St, CA 92683';


-- synthetic start time
DECLARE @syntheticStart DATETIME, @syntheticEnd DATETIME;
SELECT @syntheticStart = MIN(storeDate), @syntheticEnd = MAX(storeDate) FROM ProductInventory

-- get number of employees
DECLARE @employeeCount INT;
SELECT @employeeCount = COUNT(*) FROM Employee;

-- get number of customers
DECLARE @customerCount INT;
SELECT @customerCount = COUNT(*) FROM Customer;

-- get number of products
DECLARE @productCount INT;
SELECT @productCount = COUNT(*) FROM Product;

-- get number of services
DECLARE @serviceCount INT;
SELECT @serviceCount = COUNT(*) FROM Service;

DECLARE @customerId INT;
SET @customerId = 0;
WHILE @customerId < @customerCount
BEGIN
    -- increase index
    SET @customerId = @customerId + 1;

    -- get info from customer for order
    DECLARE @customerAddress VARCHAR(255), @phoneNumber VARCHAR(15);
    SELECT @customerAddress = address, @phoneNumber = phoneNumber FROM Customer WHERE id = @customerId;


    DECLARE @orderAddress VARCHAR(255), @orderPhoneNumber VARCHAR(15);
    DECLARE @orderAddressRandom INT;

    EXEC dbo.GenerateRandomInt 1, 3, @seed, @orderAddressRandom OUTPUT;

    SET @orderAddress =
        CASE @orderAddressRandom
            WHEN 1 THEN @inStoreAddress
            ELSE @customerAddress
        END;

    -- get number of orders for this customer

    DECLARE @orderCount INT;
    EXEC dbo.GenerateRandomInt 1, @orderPerCustomerMax, @seed, @orderCount OUTPUT;

    -- loop through each order
    DECLARE @orderIndex INT;
    SET @orderIndex = 0;

    WHILE @orderIndex < @orderCount
    BEGIN
        -- increase index
        SET @orderIndex = @orderIndex + 1;

        -- get random confirmed by employee
        DECLARE @employeeId INT;
        EXEC dbo.GenerateRandomInt 1, @employeeCount, @seed, @employeeId OUTPUT;

        -- get random order time
        DECLARE @orderTime DATETIME;
        EXEC dbo.GenerateRandomDateTime @syntheticStart, @syntheticEnd, @seed, @orderTime OUTPUT;

        -- get status (varchar) for order, with one of the following values: 'INITIALIZING', 'PENDING', 'NOT_ACCEPTED', 'CONFIRMED', 'CANCELED', 'SUCCESS'
        DECLARE @orderStatus VARCHAR(255);
        DECLARE @random INT;
        EXEC dbo.GenerateRandomInt 1, 50, @seed, @random OUTPUT;
        SET @orderStatus =
            CASE @random
                WHEN 1 THEN 'INITIALIZING'
                WHEN 2 THEN 'PENDING'
                WHEN 3 THEN 'NOT_ACCEPTED'
                WHEN 4 THEN 'CONFIRMED'
                -- from 5 to 10, the order is DELIVERING
                WHEN 5 THEN 'DELIVERING'
                WHEN 6 THEN 'DELIVERING'
                WHEN 7 THEN 'DELIVERING'
                WHEN 8 THEN 'DELIVERING'
                WHEN 9 THEN 'DELIVERING'
                WHEN 10 THEN 'DELIVERING'
                -- from 11 to 15, the order is CANCELED
                WHEN 11 THEN 'CANCELED'
                WHEN 12 THEN 'CANCELED'
                WHEN 13 THEN 'CANCELED'
                WHEN 14 THEN 'CANCELED'
                WHEN 15 THEN 'CANCELED'
                -- from 16 to 50, the order is SUCCESS
                ELSE 'SUCCESS'
            END;

        -- create order with columns: createdTime, deliveryAddress, phoneNumber, status, customerId, employeeId
        INSERT INTO [Order] (createdTime, deliveryAddress, phoneNumber, status, customerId, employeeId)
        VALUES (@orderTime, @orderAddress, @phoneNumber, @orderStatus, @customerId, @employeeId);

        -- if insert failed, throw an error
        IF @@ERROR <> 0
        BEGIN
            THROW 50000, 'Failed to insert order', 1;
        END

        -- get the id of the order
        DECLARE @orderId INT;
        SELECT @orderId = SCOPE_IDENTITY();

        --print order id
        -- PRINT 'Order ' + CAST(@orderId AS VARCHAR(255)) + ' created';


        -- ********************************************************************
        -- create order items of type product
        -- ******************************************************************

        -- we need a shared delivery record for the ordered products
        -- let prepare it
        DECLARE @deliveryId INT = NULL; -- use it for creating of order items later

        -- only orders with status DELIVERING, CANCELED, SUCCESS have delivery
        IF @orderStatus IN ('DELIVERING', 'CANCELED', 'SUCCESS')
        BEGIN
            -- for the order status DELIVERING, the delivery status is either PENDING or IN_PROGRESS
            -- so generate the random delivery status in case of DELIVERING
            DECLARE @deliveringDeliveryStatus VARCHAR(255);
            DECLARE @deliveringDeliveryStatusRandom INT;
            EXEC dbo.GenerateRandomInt 1, 2, @seed, @deliveringDeliveryStatusRandom OUTPUT;
            SET @deliveringDeliveryStatus =
                CASE @deliveringDeliveryStatusRandom
                    WHEN 1 THEN 'PENDING'
                    ELSE 'IN_PROGRESS'
                END;

            -- get delivery status based on order status
            DECLARE @deliveryStatus VARCHAR(255);
            SET @deliveryStatus =
                    CASE @orderStatus
                        WHEN 'DELIVERING' THEN @deliveringDeliveryStatus
                        WHEN 'CANCELED' THEN 'FAILED'
                        WHEN 'SUCCESS' THEN 'SUCCESS'
                    END;

            -- get random delivery start time
            DECLARE @deliveryStartTime DATETIME;
            DECLARE @deliveryStartLimit DATETIME = DATEADD(dd, 1, @orderTime);

            EXEC dbo.GenerateRandomDateTime
                 @orderTime, @deliveryStartLimit, @seed, @deliveryStartTime OUTPUT;

            -- get random delivery end time
            DECLARE @deliveryEndTime DATETIME;
            DECLARE @deliveryEndLimit DATETIME = DATEADD(dd, 3, @deliveryStartTime);
            EXEC dbo.GenerateRandomDateTime
                 @deliveryStartTime, @deliveryEndLimit, @seed, @deliveryEndTime OUTPUT;

            -- print prodcut delivery insert for orderId
            -- PRINT 'Order ' + CAST(@orderId AS VARCHAR(255)) + ' product delivery created';

            -- create delivery record with: status, startTime, endTime, reason
            INSERT INTO Delivery (status, startTime, endTime, reason)
            VALUES (@deliveryStatus, @deliveryStartTime, @deliveryEndTime, 'Order ' + CAST(@orderId AS VARCHAR(255)) + ' delivery');

            -- get the id of the delivery
            SELECT @deliveryId = SCOPE_IDENTITY();

            -- the delivery of products is by mean of a shipping service
            -- let create a shipping record

            -- get the shipping status first, based on delivery status
            DECLARE @shippingStatus VARCHAR(255);
            SET @shippingStatus =
                    CASE @deliveryStatus
                        WHEN 'PENDING' THEN 'PENDING'
                        WHEN 'IN_PROGRESS' THEN 'SHIPPED'
                        WHEN 'FAILED' THEN 'CANCELED'
                        WHEN 'SUCCESS' THEN 'DELIVERED'
                    END;

            -- get info about the shipping service, the provider is only USPS
            DECLARE @shippingProvider VARCHAR(255);
            SET @shippingProvider = 'USPS';

            -- get tracking code, use USPS- as prefix and format order id with 10 digits as suffix
            DECLARE @trackingCode VARCHAR(255);
            SET @trackingCode = 'USPS-' + RIGHT('0000000000' + CAST(@orderId AS VARCHAR(255)), 10);

            -- get delivery from address, use the store address
            DECLARE @fromAddress VARCHAR(255);
            SET @fromAddress = '123 Goldenwest St, Westminster, CA 92683';

            -- get delivery to address, use the order address
            DECLARE @toAddress VARCHAR(255);
            SET @toAddress = @orderAddress;

            -- create shipping record with: deliveryId, status, startTime, endTime, fromAddress, toAddress, provider, trackingCode
            INSERT INTO Shipping (deliveryId, status, startTime, endTime, fromAddress, toAddress, provider, trackingCode)
            VALUES (@deliveryId, @shippingStatus, @deliveryStartTime, @deliveryEndTime, @fromAddress, @toAddress, @shippingProvider, @trackingCode);
        END


        -- now we has the delivery record, we can create order items
        -- loop through each ordered products to generate order items
        -- get number of products for this order
        DECLARE @productOrderCount INT;
        EXEC dbo.GenerateRandomInt 1, 4, @seed, @productOrderCount OUTPUT;

        DECLARE @productOrderIndex INT;
        SET @productOrderIndex = 0;
        WHILE @productOrderIndex < @productOrderCount
        BEGIN
            -- update index
            SET @productOrderIndex = @productOrderIndex + 1;

            -- get random product id
            DECLARE @productId INT;
            EXEC dbo.GenerateRandomInt 1, @productCount, @seed, @productId OUTPUT;

            -- and then get associated shop item
            DECLARE @shopItemId INT;
            SELECT @shopItemId = shopItemId FROM Product WHERE id = @productId;

            -- get random quantity
            DECLARE @quantity INT;
            EXEC dbo.GenerateRandomInt 1, 10, @seed, @quantity OUTPUT;

            -- get shop item price
            DECLARE @priceEach DECIMAL(10, 2);
            SELECT @priceEach = price FROM ShopItem WHERE id = @shopItemId;

            -- get random discount
            DECLARE @discount DECIMAL(10, 2);
            EXEC dbo.GenerateRandomDecimal 0, @discountMax, @seed, @discount OUTPUT;

            -- create an available sourcing if the order status is PENDING, NOT_ACCEPT, CONFIRMED, or CANCELED, SUCCESS
            -- as these status indicate that the order is initiated and the sourcing is available
            DECLARE @sourcingId INT;
            IF @orderStatus IN ('PENDING', 'NOT_ACCEPTED', 'CONFIRMED', 'CANCELED', 'SUCCESS')
            BEGIN
                -- get random sourcing i
                INSERT INTO Sourcing (available, reason)
                VALUES (1, 'Order ' + CAST(@orderId AS VARCHAR(255)) + ' sourcing');

                -- get the id of the sourcing
                SELECT @sourcingId = SCOPE_IDENTITY();

                -- as the product is sourced, update the inventory
                -- get available inventory first
                DECLARE @inventoryId INT;
                SELECT TOP 1 @inventoryId = inventoryId
                FROM GetAvailableProductInventory (@productId, @quantity, @orderTime);

                -- then source it
                INSERT INTO InventorySourcing(productInventoryId, sourcingId, quantity)
                VALUES (@inventoryId, @sourcingId, @quantity);
            END

            -- create order item with columns: orderId, shopItemId, type, priceEach, quantity, discount, sourcingId
            INSERT INTO OrderItem (orderId, shopItemId, type, priceEach, quantity, discount, sourcingId, deliveryId)
            VALUES (@orderId, @shopItemId, 'PRODUCT', @priceEach, @quantity, @discount, @sourcingId, @deliveryId);
        END


        -- ********************************************************************
        -- create order items of type service
        -- *******************************************************************

        -- unliked products items shared the same delivery record, service items have their own delivery record
        -- so jump right into creating service items

        -- get number of services for this order
        DECLARE @serviceOrderCount INT;
        EXEC dbo.GenerateRandomInt 0, 3, @seed, @serviceOrderCount OUTPUT;

        DECLARE @serviceOrderIndex INT;
        SET @serviceOrderIndex = 0;
        WHILE @serviceOrderIndex < @serviceOrderCount
        BEGIN
            -- update index
            SET @serviceOrderIndex = @serviceOrderIndex + 1;

            -- first, get random service id
            DECLARE @serviceId INT;
            EXEC dbo.GenerateRandomInt 1, @serviceCount, @seed, @serviceId OUTPUT;

            -- and then get associated shop item
            DECLARE @serviceShopItemId INT;
            SELECT @serviceShopItemId = shopItemId FROM Service WHERE id = @serviceId;

            -- get random quantity
            DECLARE @serviceQuantity INT;
            EXEC dbo.GenerateRandomInt 1, 5, @seed, @serviceQuantity OUTPUT;

            -- get shop item price
            DECLARE @servicePriceEach DECIMAL(10, 2);
            SELECT @servicePriceEach = price FROM ShopItem WHERE id = @serviceShopItemId;

            -- get random discount
            DECLARE @serviceDiscount DECIMAL(10, 2);
            EXEC dbo.GenerateRandomDecimal 0, @discountMax, @seed, @serviceDiscount OUTPUT;

            -- create delivery record for service item

            -- we need a delivery record for each service item
            DECLARE @serviceDeliveryId INT = NULL; -- use it for creating of the order item later

            -- only orders with status DELIVERING, CANCELED, SUCCESS have delivery
            IF @orderStatus IN ('DELIVERING', 'CANCELED', 'SUCCESS')
            BEGIN
                -- for the order status DELIVERING, the delivery status is either PENDING or IN_PROGRESS
                -- so generate the random delivery status in case of DELIVERING
                DECLARE @serviceDeliveringDeliveryStatus VARCHAR(255);
                DECLARE @serviceDeliveringDeliveryStatusRandom INT;
                EXEC dbo.GenerateRandomInt 1, 2, @seed, @serviceDeliveringDeliveryStatusRandom OUTPUT;
                SET @serviceDeliveringDeliveryStatus =
                        CASE @serviceDeliveringDeliveryStatusRandom
                            WHEN 1 THEN 'PENDING'
                            ELSE 'IN_PROGRESS'
                            END;

                -- get delivery status based on order status
                DECLARE @serviceDeliveryStatus VARCHAR(255);
                SET @serviceDeliveryStatus =
                        CASE @orderStatus
                            WHEN 'DELIVERING' THEN @serviceDeliveringDeliveryStatus
                            WHEN 'CANCELED' THEN 'FAILED'
                            WHEN 'SUCCESS' THEN 'SUCCESS'
                            END;

                -- get random delivery start time
                DECLARE @serviceDeliveryStartTime DATETIME;
                DECLARE @serviceDeliveryStartLimit DATETIME = DATEADD(dd, 1, @orderTime);

                EXEC dbo.GenerateRandomDateTime
                     @orderTime, @serviceDeliveryStartLimit, @seed, @serviceDeliveryStartTime OUTPUT;

                -- get random delivery end time
                DECLARE @serviceDeliveryEndTime DATETIME;
                DECLARE @serviceDeliveryEndLimit DATETIME = DATEADD(dd, 3, @serviceDeliveryStartTime);
                EXEC dbo.GenerateRandomDateTime
                     @serviceDeliveryStartTime, @serviceDeliveryEndLimit, @seed, @serviceDeliveryEndTime OUTPUT;

                -- create delivery record with: status, startTime, endTime, reason
                INSERT INTO Delivery (status, startTime, endTime, reason)
                VALUES (@serviceDeliveryStatus, @serviceDeliveryStartTime, @serviceDeliveryEndTime, 'Order ' + CAST(@orderId AS VARCHAR(255)) + ' delivery');

                -- get the id of the delivery
                SELECT @serviceDeliveryId = SCOPE_IDENTITY();

                -- the delivery of service is by mean of a PetServicing
                -- let create a PetServicing record

                -- get the PetServicing status first, based on delivery status
                DECLARE @petServicingStatus VARCHAR(255);
                SET @petServicingStatus =
                        CASE @serviceDeliveryStatus
                            WHEN 'PENDING' THEN 'PENDING'
                            WHEN 'IN_PROGRESS' THEN 'IN_PROGRESS'
                            WHEN 'FAILED' THEN 'CANCELED'
                            WHEN 'SUCCESS' THEN 'COMPLETED'
                            END;

                -- get name of the pet servicing base on service name
                DECLARE @petServicingName VARCHAR(255);
                SELECT @petServicingName = name FROM Service WHERE id = @serviceId;
                SET @petServicingName = 'PetServicing for ' + @petServicingName;

                -- get employee id for the pet servicing
                DECLARE @serviceEmployeeId INT;
                EXEC dbo.GenerateRandomInt 1, @employeeCount, @seed, @serviceEmployeeId OUTPUT;

                -- create PetServicing record with: deliveryId, name, status, startTime, endTime, employeeId
                INSERT INTO PetServicing (deliveryId, name, status, startTime, endTime, employeeId)
                VALUES (@serviceDeliveryId, @petServicingName, @petServicingStatus, @serviceDeliveryStartTime, @serviceDeliveryEndTime, @serviceEmployeeId);
            END

            -- the sourcing for service is always available
            -- create an available sourcing
            DECLARE @serviceSourcingId INT;
            INSERT INTO Sourcing (available, reason)
            VALUES (1, 'Order ' + CAST(@orderId AS VARCHAR(255)) + ' sourcing');

            -- get the id of the sourcing
            SELECT @serviceSourcingId = SCOPE_IDENTITY();

            -- create order item with columns: orderId, shopItemId, type, priceEach, quantity, discount, sourcingId
            INSERT INTO OrderItem (orderId, shopItemId, type, priceEach, quantity, discount, sourcingId, deliveryId)
            VALUES (@orderId, @serviceShopItemId, 'SERVICE', @servicePriceEach, @serviceQuantity, @serviceDiscount, @serviceSourcingId, @serviceDeliveryId);
        END
    END
END

































