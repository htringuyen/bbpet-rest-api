USE bbpet;
GO

CREATE PROCEDURE getCustomerShoppingReports
    @searchColumn VARCHAR(255) = 'N/A',
    @searchValue VARCHAR(255) = 'N/A',
    @sortColumn VARCHAR(255) = 'customerId',
    @sortOrder VARCHAR(255) = 'ASC',
    @rowsOffset INT = 0,
    @rowsFetch INT = 2147483647,
    @totalRows INT OUTPUT
AS
BEGIN

    SET NOCOUNT ON;

    -- create a temporary table to store the result named Report, use variables to store the total rows
    DECLARE @Report TABLE (
        customerId INT,
        customerName NVARCHAR(255),
        phoneNumber NVARCHAR(255),
        favoriteItem NVARCHAR(255),
        totalPayment DECIMAL(18, 2),
        bestOrderValue DECIMAL(18, 2),
        ordersSuccess INT,
        ordersFailed INT,
        lastActiveTime DATETIME
    );


    WITH CustomerWithItem AS (
        SELECT
            OD.customerId as customerId
             , SI.name as itemName
             , SUM(OI.quantity) as boughtQuantity
        FROM
            [Order] OD
                LEFT JOIN OrderItem OI ON OI.orderId = OD.id
                LEFT JOIN ShopItem SI ON SI.id = OI.shopItemId
        GROUP BY OD.customerId, SI.id, SI.name
    )

   , CustomerWithOrder AS (
        SELECT
            OD.customerId as customerId
             , SUM(OI.quantity * OI.priceEach * (1 - OI.discount)) as totalOrderValue
             , MAX(OI.quantity * OI.priceEach * (1 - OI.discount)) as maxOrderValue
             , MAX(OD.createdTime) as lastActiveTime
             , SUM(IIF(OD.status = 'SUCCESS', 1, 0)) ordersSuccess
             , SUM(IIF(OD.status = 'CANCELED', 1, 0)) ordersFailed
        FROM
            [Order] OD
                LEFT JOIN OrderItem OI ON OI.orderId = OD.id
        GROUP BY OD.customerId
    )

    INSERT INTO @Report
    SELECT
        DISTINCT
        CT.id as customerId
               , CT.name as customerName
               , CT.phoneNumber as phoneNumber
               , FIRST_VALUE(CWI.itemName) over (PARTITION BY CT.id ORDER BY boughtQuantity) AS favoriteItem
               , CWO.totalOrderValue AS totalPayment
               , CWO.maxOrderValue AS bestOrderValue
               , CWO.ordersSuccess AS ordersSuccess
               , CWO.ordersFailed AS ordersFailed
               , CWO.lastActiveTime AS lastActiveTime
    FROM
        Customer CT
            LEFT JOIN CustomerWithOrder CWO ON CWO.customerId = CT.id
            LEFT JOIN CustomerWithItem CWI ON CWI.customerId = CT.id
    WHERE
        CASE @searchColumn
            WHEN 'customerId' THEN CAST(CT.id AS VARCHAR(255))
            WHEN 'customerName' THEN CT.name
            WHEN 'phoneNumber' THEN CT.phoneNumber
            ELSE 'N/A'
        END = @searchValue


    SET @totalRows = @@ROWCOUNT;

    SELECT * FROM @Report
    ORDER BY
        CASE WHEN @sortColumn = 'customerId' AND @sortOrder = 'ASC' THEN customerId END ASC,
        CASE WHEN @sortColumn = 'customerId' AND @sortOrder = 'DESC' THEN customerId END DESC,

        CASE WHEN @sortColumn = 'customerName' AND @sortOrder = 'ASC' THEN customerName END ASC,
        CASE WHEN @sortColumn = 'customerName' AND @sortOrder = 'DESC' THEN customerName END DESC,

        CASE WHEN @sortColumn = 'phoneNumber' AND @sortOrder = 'ASC' THEN phoneNumber END ASC,
        CASE WHEN @sortColumn = 'phoneNumber' AND @sortOrder = 'DESC' THEN phoneNumber END DESC,

        CASE WHEN @sortColumn = 'favoriteItem' AND @sortOrder = 'ASC' THEN favoriteItem END ASC,
        CASE WHEN @sortColumn = 'favoriteItem' AND @sortOrder = 'DESC' THEN favoriteItem END DESC,

        CASE WHEN @sortColumn = 'totalPayment' AND @sortOrder = 'ASC' THEN totalPayment END ASC,
        CASE WHEN @sortColumn = 'totalPayment' AND @sortOrder = 'DESC' THEN totalPayment END DESC,

        CASE WHEN @sortColumn = 'bestOrderValue' AND @sortOrder = 'ASC' THEN bestOrderValue END ASC,
        CASE WHEN @sortColumn = 'bestOrderValue' AND @sortOrder = 'DESC' THEN bestOrderValue END DESC,

        CASE WHEN @sortColumn = 'ordersSuccess' AND @sortOrder = 'ASC' THEN ordersSuccess END ASC,
        CASE WHEN @sortColumn = 'ordersSuccess' AND @sortOrder = 'DESC' THEN ordersSuccess END DESC,

        CASE WHEN @sortColumn = 'ordersFailed' AND @sortOrder = 'ASC' THEN ordersFailed END ASC,
        CASE WHEN @sortColumn = 'ordersFailed' AND @sortOrder = 'DESC' THEN ordersFailed END DESC,

        CASE WHEN @sortColumn = 'lastActiveTime' AND @sortOrder = 'ASC' THEN lastActiveTime END ASC,
        CASE WHEN @sortColumn = 'lastActiveTime' AND @sortOrder = 'DESC' THEN lastActiveTime END DESC

    OFFSET @rowsOffset ROWS
    FETCH NEXT @rowsFetch ROWS ONLY;
END
