USE bbpet;
GO

CREATE TRIGGER AddPointsOnOrderSucceeded
    ON [Order]
    AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    WITH Info AS (
        SELECT
            OD.customerId AS customerId,
            SUM(OI.quantity * OI.priceEach * (1 - OI.discount)) AS orderPrice
        FROM
            Inserted OD
                INNER JOIN OrderItem OI ON OI.orderId = OD.id
        WHERE OD.status = 'SUCCESS'
        GROUP BY OD.id, OD.customerId
    )

    , Info2 AS (
        SELECT
            I.customerId AS customerId,
            SUM(
                CASE
                    WHEN I.orderPrice < 100 THEN 100
                    WHEN I.orderPrice < 300 THEN 150
                    WHEN I.orderPrice < 500 THEN 250
                    WHEN I.orderPrice < 1000 THEN 400
                    ELSE 600
                    END)
                AS totalPoints
        FROM Info I
        GROUP BY I.customerId
    )

    UPDATE C
    SET C.accumulatedPoints = C.accumulatedPoints + I.totalPoints
    FROM
        Info2 I
            INNER JOIN Customer C ON C.id = I.customerId
END


