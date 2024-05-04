-- Insert sample data into Employee table with explicit IDs
-- set identity_insert Employee on;
SET IDENTITY_INSERT Employee ON;
INSERT INTO Employee (id, name) VALUES (1, 'John Doe');
INSERT INTO Employee (id, name) VALUES (2, 'Jane Doe');
INSERT INTO Employee (id, name) VALUES (3, 'Jim Smith');
INSERT INTO Employee (id, name) VALUES (4, 'Jessica Smith');
INSERT INTO Employee (id, name) VALUES (5, 'Jack Johnson');
SET IDENTITY_INSERT Employee OFF;

-- Insert sample data into Product table with explicit IDs
-- set identity_insert Product on;
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (id, name) VALUES (1, 'Dog Food');
INSERT INTO Product (id, name) VALUES (2, 'Cat Food');
INSERT INTO Product (id, name) VALUES (3, 'Bird Food');
INSERT INTO Product (id, name) VALUES (4, 'Fish Food');
INSERT INTO Product (id, name) VALUES (5, 'Pet Toys');
INSERT INTO Product (id, name) VALUES (6, 'Pet Beds');
INSERT INTO Product (id, name) VALUES (7, 'Pet Collars');
INSERT INTO Product (id, name) VALUES (8, 'Pet Leashes');
INSERT INTO Product (id, name) VALUES (9, 'Pet Shampoo');
INSERT INTO Product (id, name) VALUES (10, 'Pet Brushes');
SET IDENTITY_INSERT Product OFF;

-- Insert sample data into Service table with explicit IDs
SET IDENTITY_INSERT Service ON;
INSERT INTO Service (id, name) VALUES (1, 'Pet Spa');
INSERT INTO Service (id, name) VALUES (2, 'Veterinary Check-up');
INSERT INTO Service (id, name) VALUES (3, 'Pet Overseeing');
INSERT INTO Service (id, name) VALUES (4, 'Pet Grooming');
INSERT INTO Service (id, name) VALUES (5, 'Pet Training');
INSERT INTO Service (id, name) VALUES (6, 'Pet Boarding');
INSERT INTO Service (id, name) VALUES (7, 'Pet Sitting');
INSERT INTO Service (id, name) VALUES (8, 'Pet Walking');
INSERT INTO Service (id, name) VALUES (9, 'Pet Feeding');
INSERT INTO Service (id, name) VALUES (10, 'Pet Health Care');
SET IDENTITY_INSERT Service OFF;


-- data of one customer
-- Insert sample data into Customer table with explicit ID
SET IDENTITY_INSERT Customer ON;
INSERT INTO Customer (id, name) VALUES (1, 'Customer 1');
SET IDENTITY_INSERT Customer OFF;

-- Insert sample data into Order table with explicit IDs
SET IDENTITY_INSERT [Order] ON;
INSERT INTO [Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId) VALUES (1, '2022-01-01', 'Address 1', 'CREATING', 1, 1);
INSERT INTO [Order] (id, createdTime, deliveryAddress, status, customerId, confirmedByEmployeeId) VALUES (2, '2022-01-02', 'Address 2', 'PENDING', 1, 2);
SET IDENTITY_INSERT [Order] OFF;

-- Insert sample data into OrderItem table with explicit IDs
SET IDENTITY_INSERT OrderItem ON;
INSERT INTO OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (1, 1, 2, 20.00, 0.00);
INSERT INTO OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (2, 1, 1, 50.00, 0.10);
INSERT INTO OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (3, 2, 3, 30.00, 0.05);
INSERT INTO OrderItem (id, orderId, quantity, priceEach, discountPercent) VALUES (4, 2, 1, 100.00, 0.00);
SET IDENTITY_INSERT OrderItem OFF;

-- Insert sample data into Shipping table with explicit IDs
SET IDENTITY_INSERT Shipping ON;
INSERT INTO Shipping (id, status) VALUES (1, 'PENDING');
INSERT INTO Shipping (id, status) VALUES (2, 'SHIPPED');
SET IDENTITY_INSERT Shipping OFF;

-- Insert sample data into ProductOrderItem table with explicit
INSERT INTO ProductOrderItem (id, productId, shippingId) VALUES (1, 1, 1);
INSERT INTO ProductOrderItem (id, productId, shippingId) VALUES (3, 3, 2);

-- Insert sample data into ServiceActivity table with explicit IDs
SET IDENTITY_INSERT ServiceActivity ON;
INSERT INTO ServiceActivity (id, name, status) VALUES (1, 'Pet Spa Activity', 'PENDING');
INSERT INTO ServiceActivity (id, name, status) VALUES (2, 'Veterinary Check-up Activity', 'IN_PROGRESS');
SET IDENTITY_INSERT ServiceActivity OFF;

-- Insert sample data into ServiceOrderItem table with explicit IDs
INSERT INTO ServiceOrderItem (id, serviceId, serviceActivityId) VALUES (2, 1, 1);
INSERT INTO ServiceOrderItem (id, serviceId, serviceActivityId) VALUES (4, 2, 2);




