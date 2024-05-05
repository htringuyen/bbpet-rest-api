-- always use right database
USE bbpet;
GO

-- create function that return a table
CREATE FUNCTION GetAvailableProductInventory(@productId INT, @requiredQuantity INT, @atTime DATETIME)
RETURNS TABLE
AS RETURN
(
    SELECT
        pi.id AS inventoryId
        , pi.storeLocation as location
        , pi.quantity - ISNULL(SUM(sr.quantity), 0) AS remaining
        , DATEDIFF(day, @atTime, pi.expDate) AS expiredIn
    FROM ProductInventory AS pi
        LEFT JOIN InventorySourcing AS sr
            ON pi.id = sr.productInventoryId
    WHERE
        pi.productId = @productId
        AND pi.storeDate <= @atTime
        AND pi.expDate >= @atTime
        AND (sr.canceled IS NULL OR  sr.canceled = 0)

    GROUP BY pi.id, pi.storeLocation, pi.quantity, pi.expDate
    HAVING pi.quantity - ISNULL(SUM(sr.quantity), 0) >= @requiredQuantity
)