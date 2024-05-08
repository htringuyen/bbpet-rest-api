CREATE FUNCTION getOrderPrice(@orderId INT)
    RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @price DECIMAL(10, 2);

    SELECT @price = SUM(i.priceEach * i.quantity * (1 - i.discount))
    FROM dbo.[Order] o
        LEFT JOIN dbo.OrderItem i
            ON o.id = i.orderId
    WHERE o.id = @orderId;

    RETURN @price;
END