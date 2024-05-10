-- set accumulated points to 0
UPDATE C
SET C.accumulatedPoints = 0
FROM Customer C;

-- the temporary table to store the succeeded order id
DECLARE @SucceededOrder TABLE (
    orderId INT
)

-- store the succeeded order id for restoring
INSERT INTO @SucceededOrder(orderId)
SELECT O.id AS orderId
FROM [Order] O
WHERE status = 'SUCCESS';

-- update the status of all orders to a status other than SUCCESS
UPDATE O
SET O.status = 'PENDING'
FROM [Order] O
WHERE O.status = 'SUCCESS';

-- restore to SUCCESS to fire the trigger
UPDATE O
SET O.status = 'SUCCESS'
FROM
    @SucceededOrder S
    LEFT JOIN [Order] O ON O.id = S.orderId;


DECLARE @failedCount INT;

-- check the calculated accumulated points
WITH CustomerWithOrders AS (
    SELECT
        CT.id AS customerId,
        CT.accumulatedPoints AS accumulatedPoints,
        SUM(OI.quantity * OI.priceEach * (1 - OI.discount)) AS orderPrice
    FROM
        Customer CT
        LEFT JOIN [Order] OD ON OD.customerId = CT.id
        LEFT JOIN [OrderItem] OI ON OI.orderId = OD.id
    WHERE OD.status = 'SUCCESS'
    GROUP BY CT.id, CT.accumulatedPoints, OD.id
)

, CustomerWithPoints AS (
    SELECT
        CWO.customerId,
        CWO.accumulatedPoints,
        SUM(
                CASE
                    WHEN CWO.orderPrice < 100 THEN 100
                    WHEN CWO.orderPrice < 300 THEN 150
                    WHEN CWO.orderPrice < 500 THEN 250
                    WHEN CWO.orderPrice < 1000 THEN 400
                    ELSE 600
                    END)
            AS checkCalculatedPoints
    FROM CustomerWithOrders CWO
    GROUP BY CWO.customerId, CWO.accumulatedPoints
)

SELECT @failedCount = COUNT(*)
FROM CustomerWithPoints CWP
WHERE CWP.accumulatedPoints <> CWP.checkCalculatedPoints;

IF @failedCount > 0
    RAISERROR ('The accumulated points are not calculated correctly.', 16, 1);
ELSE
    PRINT 'PASSED TEST TRIGGER: add accumulated points when order status changes to SUCCESS';