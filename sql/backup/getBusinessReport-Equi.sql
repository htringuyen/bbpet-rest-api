DECLARE @fromTime DATETIME = '1970-01-01T00:00:00';
DECLARE @toTime DATETIME = '2050-01-01T00:00:00';
DECLARE @hourInterval INT = 24;

SELECT
    FLOOR(DATEDIFF_BIG(SECOND, @fromTime, OD.createdTime) / 3600.0 / @hourInterval) as intervalNumber,
    COUNT(DISTINCT OD.id)                          as orderCount,
    SUM(IIF(OI.type = 'PRODUCT', OI.quantity, 0))       as productsOrdered,
    SUM(IIF(OI.type = 'SERVICE', OI.quantity, 0))       as servicesOrdered,
    SUM(OI.quantity * OI.priceEach * (1 - OI.discount)) as totalRevenue,
    SUM(IIF(OI.type = 'PRODUCT', OI.quantity * OI.priceEach * (1 - OI.discount), 0)) as productRevenue,
    SUM(IIF(OI.type = 'SERVICE', OI.quantity * OI.priceEach * (1 - OI.discount), 0)) as serviceRevenue,
    SUM(OI.quantity * OI.priceEach * OI.discount)       as discountAmount,
    SUM(IIF(DL.status = 'SUCCESS', 1, 0))                  as deliveriesSuccess,
    SUM(IIF(DL.status = 'FAILED', 1, 0))                   as deliveriesFailed,
    AVG(DATEDIFF_BIG(SECOND, DL.startTime, DL.endTime) / 3600.0)    as meanDelieryHours,
    AVG(DATEDIFF_BIG(SECOND, OD.createdTime, DL.startTime) / 3600.0)   as meanPendingHours
FROM
    Customer CT
        LEFT JOIN [Order] OD ON OD.customerId = CT.id
        LEFT JOIN [OrderItem] OI ON OD.id = OI.orderId
        LEFT JOIN Delivery DL ON DL.id = OI.deliveryId
WHERE
    OD.status NOT IN ('INITIALIZING')
    AND OD.createdTime BETWEEN @fromTime AND @toTime
GROUP BY FLOOR(DATEDIFF_BIG(SECOND, @fromTime, OD.createdTime) / 3600.0 / @hourInterval)
ORDER BY intervalNumber;