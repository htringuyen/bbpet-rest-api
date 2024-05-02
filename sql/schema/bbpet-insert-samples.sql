USE bbpet;

-- Insert sample data into employee management schema
INSERT INTO empman.Employee (id, name) VALUES (1, 'John Doe');
INSERT INTO empman.Employee (id, name) VALUES (2, 'Jane Smith');
INSERT INTO empman.Employee (id, name) VALUES (3, 'Mike Johnson');
INSERT INTO empman.Employee (id, name) VALUES (4, 'Emma Brown');

-- Insert sample data into customer management schema
INSERT INTO customerman.Customer (id, name) VALUES (1, 'Alice Johnson');
INSERT INTO customerman.Customer (id, name) VALUES (2, 'Bob Brown');
INSERT INTO customerman.Customer (id, name) VALUES (3, 'Charlie Davis');
INSERT INTO customerman.Customer (id, name) VALUES (4, 'Eva Green');
INSERT INTO customerman.Customer (id, name) VALUES (5, 'Fred White');

-- Insert sample data into shipping management schema
INSERT INTO shipman.Shipping (id, status) VALUES (1, 'In Transit');
INSERT INTO shipman.Shipping (id, status) VALUES (2, 'Delivered');
INSERT INTO shipman.Shipping (id, status) VALUES (3, 'Pending');
INSERT INTO shipman.Shipping (id, status) VALUES (4, 'Cancelled');

-- Insert sample data into product management schema
INSERT INTO prodman.Product (id, name) VALUES (1, 'Dog Food');
INSERT INTO prodman.Product (id, name) VALUES (2, 'Cat Food');
INSERT INTO prodman.Product (id, name) VALUES (3, 'Bird Food');
INSERT INTO prodman.Product (id, name) VALUES (4, 'Fish Food');

-- Insert sample data into inventory management schema
INSERT INTO invman.ProductBatch (id, productId, importDate, quantity, priceEach, expiryDate, manufacturingDate, remaining)
VALUES (1, 1, '2023-03-01 10:00:00', 100, 25.00, '2024-02-28', '2023-02-28', 90);
INSERT INTO invman.ProductBatch (id, productId, importDate, quantity, priceEach, expiryDate, manufacturingDate, remaining)
VALUES (2, 2, '2023-03-05 14:30:00', 200, 20.00, '2024-04-30', '2023-04-01', 180);
INSERT INTO invman.ProductBatch (id, productId, importDate, quantity, priceEach, expiryDate, manufacturingDate, remaining)
VALUES (3, 3, '2023-03-10 09:00:00', 300, 15.00, '2024-05-31', '2023-05-01', 270);
INSERT INTO invman.ProductBatch (id, productId, importDate, quantity, priceEach, expiryDate, manufacturingDate, remaining)
VALUES (4, 4, '2023-03-15 11:30:00', 400, 10.00, '2024-06-30', '2023-06-01', 360);

-- Insert sample data into order management schema
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (1, '2023-03-10 09:00:00', '123 Main St, Anytown, USA', 'Completed', 1, 1);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (2, '2023-03-11 14:30:00', '456 Elm St, Anytown, USA', 'In Progress', 2, 2);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (3, '2023-03-12 10:00:00', '789 Oak St, Anytown, USA', 'Completed', 3, 3);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (4, '2023-03-13 15:30:00', '321 Pine St, Anytown, USA', 'In Progress', 4, 4);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (5, '2023-03-14 11:00:00', '654 Maple St, Anytown, USA', 'Completed', 5, 1);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (6, '2023-03-15 16:30:00', '987 Birch St, Anytown, USA', 'In Progress', 1, 2);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (7, '2023-03-16 10:00:00', '246 Cedar St, Anytown, USA', 'Completed', 2, 3);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (8, '2023-03-17 15:30:00', '852 Willow St, Anytown, USA', 'In Progress', 3, 4);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (9, '2023-03-18 11:00:00', '513 Cherry St, Anytown, USA', 'Completed', 4, 1);
INSERT INTO orderman.[Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId)
VALUES (10, '2023-03-19 16:30:00', '369 Magnolia St, Anytown, USA', 'In Progress', 5, 2);

-- Insert sample data into order items
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (1, 1, 5, 25.00, 0.00);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (2, 1, 3, 20.00, 0.10);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (3, 2, 2, 15.00, 0.05);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (4, 3, 4, 10.00, 0.00);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (5, 4, 1, 25.00, 0.00);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (6, 5, 3, 20.00, 0.10);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (7, 5, 2, 15.00, 0.05);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (8, 6, 1, 10.00, 0.00);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (9, 7, 5, 25.00, 0.00);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (10, 7, 3, 20.00, 0.10);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (11, 8, 2, 15.00, 0.05);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (12, 9, 4, 10.00, 0.00);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (13, 10, 1, 25.00, 0.00);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (14, 10, 3, 20.00, 0.10);
INSERT INTO orderman.OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (15, 10, 2, 15.00, 0.05);

-- Insert sample data into product order items
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (1, 1, 1);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (2, 2, 2);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (3, 3, 3);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (4, 4, 4);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (5, 1, 1);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (6, 2, 2);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (7, 3, 3);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (8, 4, 4);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (9, 1, 1);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (10, 2, 2);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (11, 3, 3);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (12, 4, 4);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (13, 1, 1);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (14, 2, 2);
INSERT INTO orderman.ProductOrderItem (id, productId, shippingId) VALUES (15, 3, 3);

-- Insert sample data into inventory schema table that export items for use in processing order
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (1, 1, 5);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (2, 2, 3);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (3, 3, 2);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (4, 4, 4);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (5, 1, 1);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (6, 2, 3);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (7, 3, 2);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (8, 4, 1);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (9, 1, 5);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (10, 2, 3);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (11, 3, 2);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (12, 4, 4);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (13, 1, 1);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (14, 2, 3);
INSERT INTO invman.ProductExport (productOrderItemId, productBatchId, quantity) VALUES (15, 3, 2);
