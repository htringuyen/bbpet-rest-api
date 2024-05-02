CREATE FUNCTION orderman.getTotalOrderPrice(@orderId int)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total DECIMAL(10, 2);
    SELECT @total = SUM((i.priceEach * i.quantity) * (100 - i.discountPercent) / 100)
    FROM [Order] o
    LEFT JOIN orderman.OrderItem i on o.id = i.orderId
    WHERE o.id = @orderId;
    RETURN @total;
END;