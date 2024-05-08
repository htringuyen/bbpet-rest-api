USE bbpet;
GO

CREATE TRIGGER UpdateOrderStatusByDeliveryStatus
    ON Delivery
    AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    WITH Info AS (
        SELECT
            OI.orderId AS orderId,
            CASE DL.status
                WHEN 'PENDING' THEN 'DELIVERING'
                WHEN 'IN_PROGRESS' THEN 'DELIVERING'
                WHEN 'FAILED' THEN 'CANCELED'
                WHEN 'SUCCESS' THEN (
                    SELECT CASE WHEN MIN(CASE WHEN DL2.status = 'SUCCESS' THEN  1 ELSE 0 END) = 1
                                    THEN 'SUCCESS' ELSE 'DELIVERING' END
                    FROM
                        OrderItem OI2
                            INNER JOIN Delivery DL2 ON Dl2.id = OI2.deliveryId
                    WHERE OI2.orderId = OI.orderId
                )
                END AS orderStatus
        FROM
            Inserted DL
                INNER JOIN OrderItem OI ON OI.deliveryId = DL.id
        GROUP BY OI.orderId, DL.status
    )

    UPDATE O
    SET O.status = I.orderStatus
    FROM
        Info I
            INNER JOIN [Order] O ON O.id = I.orderId
END