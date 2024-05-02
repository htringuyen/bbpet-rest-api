/*CREATE DATABASE bbpet;
GO;*/

CREATE SCHEMA empman;
GO;

CREATE SCHEMA customerman;
GO;

CREATE SCHEMA shipman;
GO;

CREATE SCHEMA svactman;
GO;

CREATE SCHEMA serviceman;
GO;

CREATE SCHEMA prodman;
GO;

CREATE SCHEMA invman;
GO;

CREATE SCHEMA orderman;
GO;
-- Tables lacking columns, create additional columns later

-- employee management schema
CREATE TABLE empman.Employee (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- customer management schema
CREATE TABLE customerman.Customer (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- shipping management schema
CREATE TABLE shipman.Shipping (-- Store all distant delivery info in the shipping table, no table like Delivery needed
    id INT PRIMARY KEY,
    status VARCHAR(50)
);

-- service activity management schema
CREATE TABLE svactman.ServiceActivity (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- service management schema
CREATE TABLE serviceman.Service (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- product management schema
CREATE TABLE prodman.Product (
    id INT PRIMARY KEY,
    name VARCHAR(255),
);


-- Completed tables, will correct later if there are errors

-- inventory management schema
CREATE TABLE invman.ProductBatch (
    id INT PRIMARY KEY,
    productId INT,
    importDate DATETIME,
    quantity INT,
    priceEach DECIMAL(10,2),
    expiryDate DATE,
    manufacturingDate DATE,
    remaining INT
    FOREIGN KEY (productId) REFERENCES prodman.Product(id)
);

-- order management schema
CREATE TABLE orderman.[Order] (
    id INT PRIMARY KEY,
    createdTime DATETIME,
    deliveryAddress VARCHAR(255),
    status VARCHAR(50),
    customerId INT,
    confirmedByEmployeeId INT,
    FOREIGN KEY (customerId) REFERENCES customerman.Customer(id),
    FOREIGN KEY (confirmedByEmployeeId) REFERENCES empman.Employee(id)
);

CREATE TABLE orderman.OrderItem (
    id INT PRIMARY KEY,
    orderId INT,
    quantity INT,
    priceEach DECIMAL(10,2),
    discountPercent DECIMAL(3,2),
    FOREIGN KEY (orderId) REFERENCES orderman.[Order](id)
);

CREATE TABLE orderman.ProductOrderItem (
    id INT PRIMARY KEY,
    productId INT,
    shippingId INT,
    FOREIGN KEY (productId) REFERENCES prodman.Product(id),
    FOREIGN KEY (shippingId) REFERENCES shipman.Shipping(id)
);

CREATE TABLE orderman.ServiceOrderItem (
    id INT PRIMARY KEY,
    serviceId INT,
    serviceActivityId INT,
    FOREIGN KEY (serviceId) REFERENCES serviceman.Service(id),
    FOREIGN KEY (serviceActivityId) REFERENCES svactman.ServiceActivity(id)
);


-- inventory schema table that export items for use in processing order
CREATE TABLE invman.ProductExport (
    productOrderItemId INT,
    productBatchId INT,
    quantity INT,
    FOREIGN KEY (productOrderItemId) REFERENCES orderman.ProductOrderItem(id),
    FOREIGN KEY (productBatchId) REFERENCES invman.ProductBatch(id)
);


