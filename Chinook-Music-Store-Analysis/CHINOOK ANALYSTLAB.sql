
--1. TOTAL NUMBER OF ALBUMS PER ARTIST--
 

SELECT
    ar.Name AS Artist,
    COUNT(al.AlbumId) AS AlbumCount
FROM Artist AS ar

LEFT JOIN Album AS al
    ON al.ArtistId = ar.ArtistId

GROUP BY
    ar.ArtistId,
    ar.Name

ORDER BY
    AlbumCount DESC;


--2. TOP 10 ALBUMS WITH THE HIGHEST SALES VOLUME--
  

SELECT TOP 10
    al.Title AS Album,
    ar.Name AS Artist,
    SUM(il.Quantity) AS UnitsSold
FROM InvoiceLine AS il

INNER JOIN Track AS t
    ON t.TrackId = il.TrackId

INNER JOIN Album AS al
    ON al.AlbumId = t.AlbumId

INNER JOIN Artist AS ar
    ON ar.ArtistId = al.ArtistId

GROUP BY
    al.AlbumId,
    al.Title,
    ar.Name

ORDER BY
    UnitsSold DESC;


--3. TOP 10 MOST FREQUENTLY PURCHASED TRACKS--
 

SELECT TOP 10
    t.Name AS Track,
    ar.Name AS Artist,
    SUM(il.Quantity) AS TotalUnitsSold
FROM InvoiceLine AS il

INNER JOIN Track AS t
    ON t.TrackId = il.TrackId

INNER JOIN Album AS al
    ON al.AlbumId = t.AlbumId

INNER JOIN Artist AS ar
    ON ar.ArtistId = al.ArtistId

GROUP BY
    t.TrackId,
    t.Name,
    ar.Name

ORDER BY
    TotalUnitsSold DESC;


--4. TOP 10 GENRES BY REVENUE--
  
SELECT TOP 10
    g.Name AS Genre,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine AS il

INNER JOIN Track AS t
    ON t.TrackId = il.TrackId

INNER JOIN Genre AS g
    ON g.GenreId = t.GenreId

GROUP BY
    g.GenreId,
    g.Name

ORDER BY
    TotalRevenue DESC;


--5. TOP 3 EMPLOYEES BY SALES PERFORMANCE--
  

SELECT TOP 3
    CONCAT(e.FirstName, ' ', e.LastName) AS Employee,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM Employee AS e

INNER JOIN Customer AS c
    ON c.SupportRepId = e.EmployeeId

INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId

INNER JOIN InvoiceLine AS il
    ON il.InvoiceId = i.InvoiceId

GROUP BY
    e.EmployeeId,
    e.FirstName,
    e.LastName

ORDER BY
    TotalRevenue DESC;


--6. TOP 10 CUSTOMERS BY TOTAL PURCHASE-
  

SELECT TOP 10
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer,
    c.Country,
    SUM(i.Total) AS TotalSpent
FROM Customer AS c

INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId

GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Country

ORDER BY
    TotalSpent DESC;


--7. SALES GENERATED FROM EACH MEDIA TYPE--

SELECT TOP 10
    m.Name AS MediaType,
    SUM(il.Quantity) AS TotalUnitsSold
FROM InvoiceLine AS il

INNER JOIN Track AS t
    ON t.TrackId = il.TrackId

INNER JOIN MediaType AS m
    ON m.MediaTypeId = t.MediaTypeId

GROUP BY
    m.MediaTypeId,
    m.Name

ORDER BY
    TotalUnitsSold DESC;


--8. TOP 10 COUNTRIES BY CUSTOMER COUNT--
 
SELECT TOP 10
    c.Country,
    COUNT(c.CustomerId) AS CustomerCount
FROM Customer AS c

GROUP BY
    c.Country

ORDER BY
    CustomerCount DESC;


   
--9. TOP 10 STATES/PROVINCES BY CUSTOMER COUNT--
 

SELECT TOP 10
    c.State,
    COUNT(c.CustomerId) AS CustomerCount
FROM Customer AS c

WHERE c.State IS NOT NULL

GROUP BY
    c.State

ORDER BY
    CustomerCount DESC;


--10. TOP 10 TRACKS BY REVENUE--
  

SELECT TOP 10
    t.Name AS Track,
    ar.Name AS Artist,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine AS il

INNER JOIN Track AS t
    ON t.TrackId = il.TrackId

INNER JOIN Album AS al
    ON al.AlbumId = t.AlbumId

INNER JOIN Artist AS ar
    ON ar.ArtistId = al.ArtistId

GROUP BY
    t.TrackId,
    t.Name,
    ar.Name

ORDER BY
    TotalRevenue DESC;


--11. TOP  10 CITIES/STATE BY REVENUE--

SELECT TOP 10
    c.City,
    c.State,
    c.Country,
    SUM(i.Total) AS TotalRevenue
FROM Customer AS c

INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId

WHERE c.State IS NOT NULL

GROUP BY
    c.City,
    c.State,
    c.Country

ORDER BY
    TotalRevenue DESC;

 
--12. CUSTOMERS WITH THEIR INVOICE TOTALS--

SELECT
    c.FirstName,
    c.LastName,
    i.InvoiceId,
    i.Total
FROM Customer AS c
INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId;


--13. CUSTOMERS WITH THEIR SUPPORT REPRESENTATIVES--


SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    CONCAT(e.FirstName, ' ', e.LastName) AS SupportRepresentative
FROM Customer AS c
LEFT JOIN Employee AS e
    ON e.EmployeeId = c.SupportRepId;



--14. INVOICE RECORDS WITH CUSTOMER NAMES--


SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    i.InvoiceDate,
    i.Total
FROM Invoice AS i
INNER JOIN Customer AS c
    ON c.CustomerId = i.CustomerId;


   
--15. ARTISTS AND THEIR ALBUMS INCLUDING ARTISTS WITHOUT ALBUMS--


SELECT
    ar.Name AS ArtistName,
    al.Title AS AlbumTitle
FROM Artist AS ar
LEFT JOIN Album AS al
    ON al.ArtistId = ar.ArtistId
ORDER BY ar.Name;


--16. EMPLOYEES WITHOUT ASSIGNED CUSTOMERS--


SELECT
    e.EmployeeId,
    e.FirstName,
    e.LastName
FROM Employee AS e
LEFT JOIN Customer AS c
    ON c.SupportRepId = e.EmployeeId
WHERE c.CustomerId IS NULL;



--17. TOTAL SALES PER COUNTRY--


SELECT
    c.Country,
    SUM(i.Total) AS TotalSales
FROM Invoice AS i
INNER JOIN Customer AS c
    ON c.CustomerId = i.CustomerId
GROUP BY c.Country
ORDER BY TotalSales DESC;



--18. INVOICES WITH CUSTOMER DETAILS--


SELECT
    c.FirstName,
    c.LastName,
    i.InvoiceId,
    i.Total
FROM Invoice AS i
LEFT JOIN Customer AS c
    ON c.CustomerId = i.CustomerId;



--19. AVERAGE TRACK PRICE--


SELECT
    AVG(t.UnitPrice) AS AverageTrackPrice
FROM Track AS t;



--20. TRACKS ABOVE AVERAGE PRICE--

SELECT
    t.Name,
    t.UnitPrice
FROM Track AS t
WHERE t.UnitPrice >
(
    SELECT AVG(UnitPrice)
    FROM Track
);



--21. CUSTOMERS WHO SPENT ABOVE AVERAGE--


WITH CustomerSpending AS
(
    SELECT
        c.CustomerId,
        c.FirstName,
        c.LastName,
        SUM(i.Total) AS TotalSpent
    FROM Customer AS c
    INNER JOIN Invoice AS i
        ON i.CustomerId = c.CustomerId
    GROUP BY
        c.CustomerId,
        c.FirstName,
        c.LastName
)

SELECT
    cs.FirstName,
    cs.LastName,
    cs.TotalSpent
FROM CustomerSpending AS cs
WHERE cs.TotalSpent >
(
    SELECT AVG(TotalSpent)
    FROM CustomerSpending
);



--22. TRACKS LONGER THAN AVERAGE LENGTH--


SELECT
    t.Name,
    t.Milliseconds
FROM Track AS t
WHERE t.Milliseconds >
(
    SELECT AVG(Milliseconds)
    FROM Track
);




--23. EMPLOYEES WHO ARE ALSO CUSTOMERS--


SELECT
    e.FirstName,
    e.LastName,
    e.Email
FROM Employee AS e
WHERE EXISTS
(
    SELECT 1
    FROM Customer AS c
    WHERE c.Email = e.Email
);



--24. CUSTOMER SPENDING RANK--


SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(i.Total) AS TotalSpent,
    ROW_NUMBER() OVER
    (
        ORDER BY SUM(i.Total) DESC
    ) AS CustomerRank
FROM Customer AS c
INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName;



--25. EMPLOYEE BY TOTAL SALES RANK--


SELECT
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue,
    RANK() OVER
    (
        ORDER BY SUM(il.UnitPrice * il.Quantity) DESC
    ) AS SalesRank
FROM Employee AS e
INNER JOIN Customer AS c
    ON c.SupportRepId = e.EmployeeId
INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId
INNER JOIN InvoiceLine AS il
    ON il.InvoiceId = i.InvoiceId
GROUP BY
    e.EmployeeId,
    e.FirstName,
    e.LastName;



--26. CUSTOMER INVOICES RANKED BY TOTAL--


SELECT
    i.CustomerId,
    i.InvoiceId,
    i.Total,
    RANK() OVER
    (
        PARTITION BY i.CustomerId
        ORDER BY i.Total DESC
    ) AS InvoiceRank
FROM Invoice AS i;



--27. TOP CUSTOMERS BY COUNTRY--


WITH CustomerCountrySales AS
(
    SELECT
        c.Country,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        SUM(i.Total) AS TotalSpent,

        ROW_NUMBER() OVER
        (
            PARTITION BY c.Country
            ORDER BY SUM(i.Total) DESC
        ) AS Ranking
    FROM Customer AS c
    INNER JOIN Invoice AS i
        ON i.CustomerId = c.CustomerId
    GROUP BY
        c.Country,
        c.CustomerId,
        c.FirstName,
        c.LastName
)

SELECT
    Country,
    CustomerName,
    TotalSpent
FROM CustomerCountrySales
WHERE Ranking <= 2;



--28. TOP 10 CUSTOMERS BY TOTAL SPENDING--


SELECT TOP 10
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    c.Country,
    SUM(i.Total) AS TotalSpent
FROM Customer AS c
INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Country
ORDER BY TotalSpent DESC;



--29. TOP 10 GENRES BY REVENUE--


SELECT TOP 10
    g.Name AS GenreName,
    SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM Genre AS g
INNER JOIN Track AS t
    ON t.GenreId = g.GenreId
INNER JOIN InvoiceLine AS il
    ON il.TrackId = t.TrackId
GROUP BY
    g.GenreId,
    g.Name
ORDER BY Revenue DESC;


--30. TOP 10 TRACKS BY REVENUE--


SELECT TOP 10
    t.Name AS TrackName,
    ar.Name AS ArtistName,
    SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM InvoiceLine AS il
INNER JOIN Track AS t
    ON t.TrackId = il.TrackId
INNER JOIN Album AS al
    ON al.AlbumId = t.AlbumId
INNER JOIN Artist AS ar
    ON ar.ArtistId = al.ArtistId
GROUP BY
    t.TrackId,
    t.Name,
    ar.Name
ORDER BY Revenue DESC;



--31.MONTHLY REVENUE TREND--


SELECT
    YEAR(i.InvoiceDate) AS SalesYear,
    MONTH(i.InvoiceDate) AS SalesMonth,
    SUM(i.Total) AS MonthlyRevenue
FROM Invoice AS i
GROUP BY
    YEAR(i.InvoiceDate),
    MONTH(i.InvoiceDate)
ORDER BY
    SalesYear,
    SalesMonth;



--32. YEARLY REVENUE TREND--


SELECT
    YEAR(i.InvoiceDate) AS SalesYear,
    SUM(i.Total) AS TotalRevenue
FROM Invoice AS i
GROUP BY YEAR(i.InvoiceDate)
ORDER BY SalesYear;



--33. MONTH-OVER-MONTH REVENUE GROWTH--


WITH MonthlyRevenue AS
(
    SELECT
        YEAR(i.InvoiceDate) AS SalesYear,
        MONTH(i.InvoiceDate) AS SalesMonth,
        SUM(i.Total) AS Revenue
    FROM Invoice AS i
    GROUP BY
        YEAR(i.InvoiceDate),
        MONTH(i.InvoiceDate)
)

SELECT
    SalesYear,
    SalesMonth,
    Revenue,

    LAG(Revenue) OVER
    (
        ORDER BY SalesYear, SalesMonth
    ) AS PreviousMonthRevenue,

    ROUND
    (
        100.0 *
        (
            Revenue -
            LAG(Revenue) OVER
            (
                ORDER BY SalesYear, SalesMonth
            )
        )
        /
        NULLIF
        (
            LAG(Revenue) OVER
            (
                ORDER BY SalesYear, SalesMonth
            ),
            0
        ),
        2
    ) AS MonthlyGrowthPercentage
FROM MonthlyRevenue;




--34. CUSTOMER PURCHASE FREQUENCY--


SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(i.InvoiceId) AS PurchaseCount
FROM Customer AS c
INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName
ORDER BY PurchaseCount DESC;



--35. TOTAL CUSTOMER SPENDING BY COUNTRY--


SELECT
    c.Country,
    SUM(i.Total) AS CountryRevenue
FROM Customer AS c
INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY CountryRevenue DESC;



--36. TOP ARTISTS BY REVENUE--


SELECT
    ar.Name AS ArtistName,
    SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM InvoiceLine AS il
INNER JOIN Track AS t
    ON t.TrackId = il.TrackId
INNER JOIN Album AS al
    ON al.AlbumId = t.AlbumId
INNER JOIN Artist AS ar
    ON ar.ArtistId = al.ArtistId
GROUP BY ar.Name
ORDER BY Revenue DESC;



--37. CUSTOMERS WITH MORE THAN ONE PURCHASE--


SELECT
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    COUNT(i.InvoiceId) AS PurchaseCount
FROM Customer AS c
INNER JOIN Invoice AS i
    ON i.CustomerId = c.CustomerId
GROUP BY
    c.CustomerId,
    c.FirstName,
    c.LastName
HAVING COUNT(i.InvoiceId) > 1
ORDER BY PurchaseCount DESC;

