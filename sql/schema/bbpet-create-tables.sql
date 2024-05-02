use bbpet;

-- Tables lacking columns, create additional columns later

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Customer (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Shipping (-- Store all distant delivery info in the shipping table, no table like Delivery needed
    id INT PRIMARY KEY,
    status VARCHAR(50)
);

CREATE TABLE ServiceActivity (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Service (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE Product (
    id INT PRIMARY KEY,
    name VARCHAR(255),
);


-- Completed tables, will correct later if there are errors

CREATE TABLE ProductBatch (
    id INT PRIMARY KEY,
    importDate DATETIME,
    quantity INT,
    priceEach DECIMAL(10,2),
    expiryDate DATE,
    manufacturingDate DATE,
    remaining INT
);

CREATE TABLE [Order] (
    id INT PRIMARY KEY,
    createdTime DATETIME,
    deliveryAddress VARCHAR(255),
    status VARCHAR(50),
    customerId INT,
    confirmedByEmployeeId INT,
    FOREIGN KEY (customerId) REFERENCES Customer(id),
    FOREIGN KEY (confirmedByEmployeeId) REFERENCES Employee(id)
);

CREATE TABLE OrderItem (
    id INT PRIMARY KEY,
    orderId INT,
    quantity INT,
    priceEach DECIMAL(10,2),
    discountPercent DECIMAL(3,2),
    FOREIGN KEY (orderId) REFERENCES [Order](id)
);

CREATE TABLE ProductOrderItem (
    id INT PRIMARY KEY,
    productId INT,
    shippingId INT,
    FOREIGN KEY (id) REFERENCES OrderItem(id),
    FOREIGN KEY (productId) REFERENCES Product(id),
    FOREIGN KEY (shippingId) REFERENCES Shipping(id)
);

CREATE TABLE ProductExport (
    productOrderItemId INT,
    productBatchId INT,
    quantity INT,
    FOREIGN KEY (productOrderItemId) REFERENCES ProductOrderItem(id),
    FOREIGN KEY (productBatchId) REFERENCES ProductBatch(id)
);

CREATE TABLE ServiceOrderItem (
    id INT PRIMARY KEY,
    serviceId INT,
    serviceActivityId INT,
    FOREIGN KEY (id) REFERENCES OrderItem(id),
    FOREIGN KEY (serviceId) REFERENCES Service(id),
    FOREIGN KEY (serviceActivityId) REFERENCES ServiceActivity(id)
);
