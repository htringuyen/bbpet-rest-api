-- always use right db
USE bbpet;
GO

-- create tables of customer management
CREATE TABLE Customer (
                          id INT PRIMARY KEY IDENTITY (1, 1),
                          name VARCHAR(255) NOT NULL,
                          address VARCHAR(255) NOT NULL,
                          phoneNumber VARCHAR(255) NOT NULL,
                          accumulatedPoints INTEGER NOT NULL,
)

-- create tables for employee management
CREATE TABLE Employee (
                          id INT PRIMARY KEY IDENTITY (1, 1),
                          name VARCHAR(255) NOT NULL,
                          address VARCHAR(255) NOT NULL,
                          phoneNumber VARCHAR(255) NOT NULL,
)

-- create tables of sale items
CREATE TABLE ShopItem (
                          id INT PRIMARY KEY IDENTITY (1, 1),
                          name VARCHAR(255) NOT NULL,
                          type VARCHAR(63) NOT NULL CHECK (type IN ('PRODUCT', 'SERVICE')),
                          price DECIMAL(10, 2) NOT NULL,
)

CREATE TABLE Product (
                         id INT PRIMARY KEY IDENTITY (1, 1),
                         shopItemId INT NOT NULL,
                         name VARCHAR(255) NOT NULL,
                         description VARCHAR(1023) NOT NULL,
                         FOREIGN KEY (shopItemId) REFERENCES ShopItem(id)
)

CREATE TABLE Service (
                         id INT PRIMARY KEY IDENTITY (1, 1),
                         shopItemId INT NOT NULL,
                         name VARCHAR(255) NOT NULL,
                         description VARCHAR(1023) NOT NULL,
                         FOREIGN KEY (shopItemId) REFERENCES ShopItem(id)
)

-- create tables of product inventory management
CREATE TABLE ProductInventory (
                                  id INT PRIMARY KEY IDENTITY (1, 1),
                                  productId INT NOT NULL,
                                  storeDate DATE NOT NULL,
                                  storeLocation VARCHAR(255) NOT NULL,
                                  priceEach DECIMAL(10, 2) NOT NULL,
                                  quantity INT NOT NULL,
                                  mgfDate DATE NOT NULL,
                                  expDate DATE NOT NULL,
                                  FOREIGN KEY (productId) REFERENCES Product(id)
)

-- create tables of sale item sourcing
CREATE TABLE Sourcing (
                          id INT PRIMARY KEY IDENTITY (1, 1),
                          available BIT NOT NULL,
                          reason VARCHAR (255)
)

CREATE TABLE InventorySourcing (
                                                productInventoryId INT NOT NULL,
                                                sourcingId INT NOT NULL,
                                                quantity INT NOT NULL,
                                                canceled BIT,
                                                PRIMARY KEY (productInventoryId, sourcingId),
                                                FOREIGN KEY (productInventoryId) REFERENCES ProductInventory(id),
                                                FOREIGN KEY (sourcingId) REFERENCES Sourcing(id)
)

-- create tables for delivery management of sold items
CREATE TABLE Delivery (
                          id INT PRIMARY KEY IDENTITY (1, 1),
                          status VARCHAR(63) NOT NULL CHECK (status IN ('PENDING', 'IN_PROGRESS', 'FAILED', 'SUCCESS')),
                          startTime DATETIME NOT NULL,
                          endTime DATETIME,
                          reason VARCHAR(255)
)

-- create tables for management of product delivery
CREATE TABLE Shipping (
                          id INT PRIMARY KEY IDENTITY (1, 1),
                          deliveryId INT NOT NULL,
                          status VARCHAR(63) NOT NULL CHECK (status IN ('PENDING', 'SHIPPED', 'CANCELED', 'DELIVERED')),
                          startTime DATETIME NOT NULL,
                          endTime DATETIME,
                          fromAddress VARCHAR(255) NOT NULL,
                          toAddress VARCHAR(255) NOT NULL,
                          provider VARCHAR(255) NOT NULL,
                          trackingCode VARCHAR(255),
                          FOREIGN KEY (deliveryId) REFERENCES Delivery(id)
)

-- create tables for management of service delivery
CREATE TABLE PetServicing (
                              id INT PRIMARY KEY IDENTITY (1, 1),
                              deliveryId INT NOT NULL,
                              name VARCHAR(255) NOT NULL,
                              status VARCHAR(63) NOT NULL CHECK (status IN ('PENDING', 'IN_PROGRESS', 'CANCELED', 'COMPLETED')),
                              startTime DATETIME NOT NULL,
                              endTime DATETIME,
                              employeeId INT NOT NULL,
                              FOREIGN KEY (deliveryId) REFERENCES Delivery(id),
                              FOREIGN KEY (employeeId) REFERENCES Employee(id)
)

-- create tables for order management
CREATE TABLE [Order] (
                         id INT PRIMARY KEY IDENTITY (1, 1),
                         createdTime DATETIME NOT NULL,
                         deliveryAddress VARCHAR(255) NOT NULL,
                         phoneNumber VARCHAR(255) NOT NULL,
                         status VARCHAR(63) NOT NULL CHECK
                             (status IN ('INITIALIZING', 'PENDING', 'NOT_ACCEPTED', 'CONFIRMED', 'DELIVERING',  'CANCELED', 'SUCCESS')),
                         customerId INT NOT NULL,
                         employeeId INT NOT NULL,
                         FOREIGN KEY (customerId) REFERENCES Customer(id),
                         FOREIGN KEY (employeeId) REFERENCES Employee(id)
)

CREATE TABLE OrderItem (
                           id INT PRIMARY KEY IDENTITY (1, 1),
                           orderId INT NOT NULL,
                           shopItemId INT NOT NULL,
                           type VARCHAR(63) NOT NULL CHECK (type IN ('PRODUCT', 'SERVICE')),
                           priceEach DECIMAL(10, 2) NOT NULL,
                           quantity INT NOT NULL,
                           discount DECIMAL(5, 2) NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount <= 1),
                           sourcingId INT,
                           deliveryId INT,
                           FOREIGN KEY (orderId) REFERENCES [Order](id),
                           FOREIGN KEY (shopItemId) REFERENCES ShopItem(id),
                           FOREIGN KEY (sourcingId) REFERENCES Sourcing(id),
                           FOREIGN KEY (deliveryId) REFERENCES Delivery(id)
)































