/*var fromTime = LocalDateTime.of(2022, 1, 1, 0, 0, 0);
var toTime = LocalDateTime.of(2023, 1, 1, 0, 0, 0);
var fromPrice = 0.0;
var toPrice = 500.0;
var searchColumn = "customerName";
var searchValue = "John";
var orderColumn = "address";
var order = "ASC";
var page = 0;
var size = Integer.MAX_VALUE;*/

-- set test param as above
DECLARE
    @fromTime DATETIME = '2022-01-01T00:00:00',
    @toTime DATETIME = '2023-01-01T00:00:00',
    @fromPrice DECIMAL(18, 2) = 0.00,
    @toPrice DECIMAL(18, 2) = 500.00,
    @searchColumn NVARCHAR(255) = 'customerName',
    @searchValue NVARCHAR(255) = 'John',
    @orderColumn NVARCHAR(255) = 'address',
    @order NVARCHAR(255) = 'ASC',
    @page INT = 0,
    @size INT = 2147483647

DECLARE @totalRows INT;

exec getDeliverablesToProcess
     @fromTime, @toTime, @fromPrice, @toPrice,
     @searchColumn, @searchValue, @orderColumn, @order,
     @page, @size,
     @totalRows OUTPUT

SELECT @totalRows AS totalRows