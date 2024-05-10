DECLARE @totalRows INT;
EXEC dbo.getCustomerShoppingReports
     default, default, 'totalPayment', 'DESC',
     default, default, @totalRows OUTPUT;

SELECT @totalRows as totalRows;