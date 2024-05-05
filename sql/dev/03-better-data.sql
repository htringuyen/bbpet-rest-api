-- always use right database
USE bbpet;
GO

-- set identity insert on and off for all table have column id

SET IDENTITY_INSERT Employee ON;

INSERT INTO Employee (id, name, address, phoneNumber)
VALUES
    (1, 'John Doe', '123 Main St, Irvine, CA 92602', '555-1234'),
    (2, 'Jane Smith', '456 Oak St, Anaheim, CA 92801', '555-5678'),
    (3, 'Bob Johnson', '789 Pine St, Santa Ana, CA 92703', '555-9012'),
    (4, 'Alice Williams', '321 Elm St, Huntington Beach, CA 92647', '555-3456'),
    (5, 'Charlie Brown', '654 Maple St, Fullerton, CA 92831', '555-7890'),
    (6, 'Emma Davis', '987 Birch St, Costa Mesa, CA 92626', '555-2345'),
    (7, 'Michael Wilson', '135 Cedar St, Newport Beach, CA 92660', '555-6789'),
    (8, 'Olivia Taylor', '246 Cherry St, Garden Grove, CA 92840', '555-0123'),
    (9, 'William Moore', '864 Walnut St, Orange, CA 92866', '555-4567'),
    (10, 'Sophia Martin', '579 Hickory St, Tustin, CA 92780', '555-8901');

SET IDENTITY_INSERT Employee OFF;



-- ShopItem
SET IDENTITY_INSERT ShopItem ON;
INSERT INTO ShopItem (id, name, type, price)
VALUES
    (1, 'Dog Grooming', 'SERVICE', 30.00),
    (2, 'Cat Grooming', 'SERVICE', 25.00),
    (3, 'Dog Training', 'SERVICE', 50.00),
    (4, 'Cat Training', 'SERVICE', 40.00),
    (5, 'Dog Boarding', 'SERVICE', 30.00),
    (6, 'Cat Boarding', 'SERVICE', 25.00),
    (7, 'Dog Walking', 'SERVICE', 15.00),
    (8, 'Pet Sitting', 'SERVICE', 20.00),
    (9, 'Pet Taxi', 'SERVICE', 25.00),
    (10, 'Veterinary Consultation', 'SERVICE', 50.00);
SET IDENTITY_INSERT ShopItem OFF;


-- Service
SET IDENTITY_INSERT Service ON;
INSERT INTO Service (id, shopItemId, name, description)
VALUES
    (1, 1, 'Dog Grooming', 'Professional grooming service for dogs.'),
    (2, 2, 'Cat Grooming', 'Professional grooming service for cats.'),
    (3, 3, 'Dog Training', 'Professional training service for dogs.'),
    (4, 4, 'Cat Training', 'Professional training service for cats.'),
    (5, 5, 'Dog Boarding', 'Boarding service for dogs.'),
    (6, 6, 'Cat Boarding', 'Boarding service for cats.'),
    (7, 7, 'Dog Walking', 'Dog walking service.'),
    (8, 8, 'Pet Sitting', 'Pet sitting service.'),
    (9, 9, 'Pet Taxi', 'Pet transportation service.'),
    (10, 10, 'Veterinary Consultation', 'Consultation with a licensed veterinarian.');
SET IDENTITY_INSERT Service OFF;


-- ShopItem
SET IDENTITY_INSERT ShopItem ON;
INSERT INTO ShopItem (id, name, type, price)
VALUES
    (11, 'Dog Food', 'PRODUCT', 20.00),
    (12, 'Cat Food', 'PRODUCT', 15.00),
    (13, 'Bird Food', 'PRODUCT', 10.00),
    (14, 'Fish Food', 'PRODUCT', 5.00),
    (15, 'Dog Toy', 'PRODUCT', 10.00),
    (16, 'Cat Toy', 'PRODUCT', 8.00),
    (17, 'Bird Cage', 'PRODUCT', 50.00),
    (18, 'Fish Tank', 'PRODUCT', 100.00),
    (19, 'Dog Bed', 'PRODUCT', 30.00),
    (20, 'Cat Bed', 'PRODUCT', 25.00),
    (21, 'Dog Leash', 'PRODUCT', 15.00),
    (22, 'Cat Collar', 'PRODUCT', 10.00),
    (23, 'Bird Swing', 'PRODUCT', 12.00),
    (24, 'Fish Filter', 'PRODUCT', 20.00),
    (25, 'Dog Shampoo', 'PRODUCT', 10.00),
    (26, 'Cat Litter', 'PRODUCT', 8.00),
    (27, 'Bird Treat', 'PRODUCT', 5.00),
    (28, 'Fish Food Flakes', 'PRODUCT', 3.00),
    (29, 'Dog Brush', 'PRODUCT', 12.00),
    (30, 'Cat Brush', 'PRODUCT', 10.00);
SET IDENTITY_INSERT ShopItem OFF;

-- Product
SET IDENTITY_INSERT Product ON;
INSERT INTO Product (id, shopItemId, name, description)
VALUES
    (1, 11, 'Dog Food', 'High-quality dog food for all breeds.'),
    (2, 12, 'Cat Food', 'High-quality cat food for all breeds.'),
    (3, 13, 'Bird Food', 'High-quality bird food for all species.'),
    (4, 14, 'Fish Food', 'High-quality fish food for all species.'),
    (5, 15, 'Dog Toy', 'Durable dog toy for play and exercise.'),
    (6, 16, 'Cat Toy', 'Durable cat toy for play and exercise.'),
    (7, 17, 'Bird Cage', 'Spacious bird cage for all bird species.'),
    (8, 18, 'Fish Tank', 'Spacious fish tank for all fish species.'),
    (9, 19, 'Dog Bed', 'Comfortable dog bed for all breeds.'),
    (10, 20, 'Cat Bed', 'Comfortable cat bed for all breeds.'),
    (11, 21, 'Dog Leash', 'Durable dog leash for all breeds.'),
    (12, 22, 'Cat Collar', 'Durable cat collar with ID tag.'),
    (13, 23, 'Bird Swing', 'Fun bird swing for all bird species.'),
    (14, 24, 'Fish Filter', 'Efficient fish tank filter for clear water.'),
    (15, 25, 'Dog Shampoo', 'Gentle dog shampoo for all breeds.'),
    (16, 26, 'Cat Litter', 'Natural cat litter for odor control.'),
    (17, 27, 'Bird Treat', 'Healthy bird treat for all species.'),
    (18, 28, 'Fish Food Flakes', 'Nutritious fish food flakes for all species.'),
    (19, 29, 'Dog Brush', 'Durable dog brush for all breeds.'),
    (20, 30, 'Cat Brush', 'Durable cat brush for all breeds.');
SET IDENTITY_INSERT Product OFF;

-- ProductInventory
SET IDENTITY_INSERT ProductInventory ON;
INSERT INTO ProductInventory (id, productId, storeDate, storeLocation, priceEach, quantity, mgfDate, expDate)
VALUES
-- Product 1: Dog Food
(1, 1, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 17.00, 100000, '2022-01-01', '2023-01-01'),
(2, 1, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 17.50, 100000, '2023-01-01', '2024-01-01'),
(3, 1, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 18.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 2: Cat Food
(4, 2, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 13.00, 100000, '2022-01-01', '2023-01-01'),
(5, 2, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 13.50, 100000, '2023-01-01', '2024-01-01'),
(6, 2, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 14.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 3: Bird Food
(7, 3, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 8.00, 100000, '2022-01-01', '2023-01-01'),
(8, 3, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 8.50, 100000, '2023-01-01', '2024-01-01'),
(9, 3, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 9.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 4: Fish Food
(10, 4, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 3.00, 100000, '2022-01-01', '2023-01-01'),
(11, 4, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 3.50, 100000, '2023-01-01', '2024-01-01'),
(12, 4, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 4.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 5: Dog Toy
(13, 5, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 8.00, 100000, '2022-01-01', '2023-01-01'),
(14, 5, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 8.50, 100000, '2023-01-01', '2024-01-01'),
(15, 5, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 9.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 6: Cat Toy
(16, 6, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 6.00, 100000, '2022-01-01', '2023-01-01'),
(17, 6, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 6.50, 100000, '2023-01-01', '2024-01-01'),
(18, 6, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 7.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 7: Bird Cage
(19, 7, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 40.00, 100000, '2022-01-01', '2023-01-01'),
(20, 7, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 42.00, 100000, '2023-01-01', '2024-01-01'),
(21, 7, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 44.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 8: Fish Tank
(22, 8, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 80.00, 100000, '2022-01-01', '2023-01-01'),
(23, 8, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 85.00, 100000, '2023-01-01', '2024-01-01'),
(24, 8, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 90.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 9: Dog Bed
(25, 9, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 24.00, 100000, '2022-01-01', '2023-01-01'),
(26, 9, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 25.00, 100000, '2023-01-01', '2024-01-01'),
(27, 9, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 26.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 10: Cat Bed
(28, 10, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 20.00, 100000, '2022-01-01', '2023-01-01'),
(29, 10, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 21.00, 100000, '2023-01-01', '2024-01-01'),
(30, 10, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 22.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 11: Dog Leash
(31, 11, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 12.00, 100000, '2022-01-01', '2023-01-01'),
(32, 11, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 13.00, 100000, '2023-01-01', '2024-01-01'),
(33, 11, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 14.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 12: Cat Collar
(34, 12, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 8.00, 100000, '2022-01-01', '2023-01-01'),
(35, 12, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 9.00, 100000, '2023-01-01', '2024-01-01'),
(36, 12, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 10.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 13: Bird Swing
(37, 13, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 9.00, 100000, '2022-01-01', '2023-01-01'),
(38, 13, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 10.00, 100000, '2023-01-01', '2024-01-01'),
(39, 13, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 11.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 14: Fish Filter
(40, 14, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 16.00, 100000, '2022-01-01', '2023-01-01'),
(41, 14, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 17.00, 100000, '2023-01-01', '2024-01-01'),
(42, 14, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 18.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 15: Dog Shampoo
(43, 15, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 8.00, 100000, '2022-01-01', '2023-01-01'),
(44, 15, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 9.00, 100000, '2023-01-01', '2024-01-01'),
(45, 15, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 10.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 16: Cat Litter
(46, 16, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 6.00, 100000, '2022-01-01', '2023-01-01'),
(47, 16, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 7.00, 100000, '2023-01-01', '2024-01-01'),
(48, 16, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 8.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 17: Bird Treat
(49, 17, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 4.00, 100000, '2022-01-01', '2023-01-01'),
(50, 17, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 4.50, 100000, '2023-01-01', '2024-01-01'),
(51, 17, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 5.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 18: Fish Food Flakes
(52, 18, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 2.00, 100000, '2022-01-01', '2023-01-01'),
(53, 18, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 2.50, 100000, '2023-01-01', '2024-01-01'),
(54, 18, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 3.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 19: Dog Brush
(55, 19, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 10.00, 100000, '2022-01-01', '2023-01-01'),
(56, 19, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 11.00, 100000, '2023-01-01', '2024-01-01'),
(57, 19, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 12.00, 100000, '2024-01-01', '2025-01-01'),

-- Product 20: Cat Brush
(58, 20, '2022-01-01', 'Warehouse 1 - Westminster, CA 92683', 8.00, 100000, '2022-01-01', '2023-01-01'),
(59, 20, '2023-01-01', 'Warehouse 2 - Westminster, CA 92683', 9.00, 100000, '2023-01-01', '2024-01-01'),
(60, 20, '2024-01-01', 'Warehouse 3 - Westminster, CA 92683', 10.00, 100000, '2024-01-01', '2025-01-01');
SET IDENTITY_INSERT ProductInventory OFF;


-- customer
SET IDENTITY_INSERT Customer ON;
INSERT INTO Customer (id, name, address, phoneNumber, accumulatedPoints)
VALUES
    (1, 'John Doe', '123 Main St, Los Angeles, CA 90001', '424-123-0001', 0),
    (2, 'Jane Smith', '456 Oak St, Portland, OR 97201', '503-555-0002', 0),
    (3, 'Bob Johnson', '789 Pine St, Phoenix, AZ 85001', '602-555-0003', 0),
    (4, 'Sally Lee', '321 Elm St, Las Vegas, NV 89101', '702-555-0004', 0),
    (5, 'Tom Brown', '654 Maple St, San Diego, CA 92101', '619-555-0005', 0),
    (6, 'Karen Davis', '987 Birch St, Seattle, WA 98101', '206-555-0006', 0),
    (7, 'Mike Miller', '135 Cedar St, San Francisco, CA 94102', '415-555-0007', 0),
    (8, 'Amy Taylor', '246 Cherry St, Eugene, OR 97401', '541-555-0008', 0),
    (9, 'David Clark', '864 Walnut St, Tucson, AZ 85701', '520-555-0009', 0),
    (10, 'Linda White', '579 Hickory St, Reno, NV 89501', '775-555-0010', 0),
    (11, 'Emily Davis', '123 Main St, Sacramento, CA 94203', '916-555-0011', 0),
    (12, 'Mark Johnson', '456 Oak St, Vancouver, WA 98660', '360-555-0012', 0),
    (13, 'Sarah Smith', '789 Pine St, Flagstaff, AZ 86001', '928-555-0013', 0),
    (14, 'William Lee', '321 Elm St, Henderson, NV 89002', '702-555-0014', 0),
    (15, 'Kevin Brown', '654 Maple St, Santa Ana, CA 92701', '714-555-0015', 0),
    (16, 'Jessica Davis', '987 Birch St, Salem, OR 97301', '503-555-0016', 0),
    (17, 'Robert Miller', '135 Cedar St, Mesa, AZ 85201', '480-555-0017', 0),
    (18, 'Michael Taylor', '246 Cherry St, Sparks, NV 89431', '775-555-0018', 0),
    (19, 'Steve Clark', '864 Walnut St, Long Beach, CA 90802', '562-555-0019', 0),
    (20, 'Katherine White', '579 Hickory St, Bend, OR 97701', '541-555-0020', 0)
;
SET IDENTITY_INSERT Customer OFF;