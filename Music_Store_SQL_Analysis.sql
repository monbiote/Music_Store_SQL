USE musicstore3;
-- Please add the proper SQL query to follow the instructions below  

-- 1.Show the Number of tracks whose composer is F. Baltes
-- (Note: there can be more than one composers for each track)

SELECT COUNT(DISTINCT TrackId)
FROM track
WHERE Composer LIKE '%F. Baltes%';

-- 2.Show the Number of invoices, and the number of invoices with a total amount =0.99 in the same query
-- (Hint: you can use CASE WHEN)

SELECT 
	COUNT(InvoiceId) AS TotalInvoices,
    COUNT(CASE WHEN total = 0.99 THEN 1 END) AS InvoicesWithAmount0_99
FROM invoice;

-- 3.Show the album title and artist name of the first five albums sorted alphabetically
SELECT al.Title AS AlbumTitle, ar.Name AS ArtistName 
FROM album al
INNER JOIN artist ar ON ar.ArtistId = al.ArtistId
ORDER BY al.Title ASC
LIMIT 5;

-- 4.Show the Id, first name, and last name of the 10 first customers 
-- alphabetically ordered. Include the id, first name and last name 
-- of their support representative (employee)
 SELECT c.CustomerId AS CustomerId, c.FirstName AS CustomerFirstName, c.LastName AS CustomerLastName,
		e.EmployeeId AS EmployeeId, e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName
 FROM customer c
 INNER JOIN employee e ON e.EmployeeId = c.SupportRepId
 ORDER BY c.LastName, c.FirstName -- ordered alphabetically by customer surname
 LIMIT 10;
 
-- 5.Show the Track name, duration, album title, artist name,
--  media name, and genre name for the five longest tracks

SELECT t.name AS TrackName, t.Milliseconds AS TrackDuration, al.Title as AlbumTitle, ar.Name as ArtistName, m.Name as MediaName, g.name as GenreName
FROM track t
INNER JOIN genre g ON g.GenreId = t.GenreId
INNER JOIN mediatype m ON m.MediaTypeId = t.MediatypeId
INNER JOIN album al ON al.AlbumID = t.AlbumID
INNER JOIN artist ar ON ar.ArtistId = al.ArtistId
ORDER by t.Milliseconds DESC
LIMIT 5;

-- 6.Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
--  together with the average price per track
SELECT 
	SUM(t.UnitPrice) AS TotalUnitPrice,
    AVG(t.UnitPrice) AS AveragePricePerTrack,
    al.Title AS AlbumTitle
FROM track t
INNER JOIN album al ON al.AlbumId = t.AlbumId
GROUP BY al.Title
ORDER BY SUM(t.UnitPrice) DESC
LIMIT 5; 

-- 7. Show the Five most expensive albums
--  (Those with the highest cumulated unit price)
-- but only if the average price per track is above 1

SELECT 
	SUM(t.UnitPrice) AS TotalUnitPrice,
    AVG(t.UnitPrice) AS AveragePricePerTrack,
    al.Title AS AlbumTitle
FROM track t
INNER JOIN album al ON al.AlbumId = t.AlbumId
GROUP BY al.Title
HAVING AVG(t.UnitPrice) > 1
ORDER BY SUM(t.UnitPrice) DESC
LIMIT 5; 


-- 8.Show the album Id and number of different genres
-- for those albums with more than one genre
-- (tracks contained in an album must be from at least two different genres)
-- Show the result sorted by the number of different genres from the most to the least eclectic 
SELECT 
    al.AlbumId AS AlbumId,
    COUNT(DISTINCT g.Name) as NumberOfGenres
FROM track T
INNER JOIN  Genre g ON g.GenreId = t.GenreID
INNER JOIN  Album al ON al.AlbumId = t.AlbumID
GROUP BY al.albumId
HAVING COUNT(DISTINCT g.Name) > 1
ORDER BY NumberOfGenres DESC;

-- 9.Show the total number of albums that you get from the previous result (hint: use a nested query)

SELECT COUNT(*) 
FROM (
    SELECT 
        a.AlbumId AS AlbumId,
        COUNT(DISTINCT g.Name) as NumberOfGenres
    FROM Album a
    JOIN Track t ON a.AlbumId = t.AlbumId
    JOIN Genre g ON g.GenreId = t.GenreId
    GROUP BY a.AlbumId
    HAVING COUNT(DISTINCT g.Name) > 1
    ) t1;


-- 10.Check that the total amount of money in each invoice
-- is equal to the sum of unit price x quantity
-- of its invoice lines.
SELECT
    InvoiceId,
    total,
    SUM(s1) AS total_sum,
    CASE WHEN total = SUM(s1) THEN 1 ELSE 0 END AS is_total_equal_sum
FROM
    (
        SELECT
            i.InvoiceId,
            i.Total,
            (il.UnitPrice * il.Quantity) AS s1
        FROM
            Invoice i
            JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
    ) t1
GROUP BY
    InvoiceId, total;

-- 11.We are interested in those employees whose customers have generated 
-- the highest amount of invoices 
-- Show first_name, last_name, and total amount generated 

SELECT e.FirstName, e.LastName,
    SUM(i.total) AS TotalAmountGenerated,
    COUNT(i.invoiceId) AS AmountOfInvoices
FROM employee e
INNER JOIN customer c ON e.EmployeeId = c.SupportRepId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.FirstName, e.LastName
ORDER BY TotalAmountGenerated DESC;


-- 12.Show the following values: Average expense per customer, average expense per invoice, 
-- and average invoices per customer.
-- Consider just active customers (customers that generated at least one invoice)

SELECT
    AVG(InvoiceTotalPerCustomer) AS AverageExpensePerCustomer,
    AVG(InvoiceTotal) AS AverageExpensePerInvoice,
    AVG(NumberOfInvoices) AS AverageInvoicesPerCustomer
FROM (
    SELECT
        c.CustomerId,
        COUNT(DISTINCT i.InvoiceId) AS NumberOfInvoices,
        SUM(i.Total) AS InvoiceTotal,
        SUM(i.Total) / COUNT(DISTINCT i.InvoiceId) AS InvoiceTotalPerInvoice,
        SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS InvoiceTotalPerCustomer
    FROM customer c
    INNER JOIN invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
    HAVING COUNT(DISTINCT i.InvoiceId) > 0 -- Active customers, need at least one invoice
) AS ActiveCustomer;


-- 13.We want to know the number of customers that are above the average expense level per customer. (how many?)

SELECT
    COUNT(*) AS NumberCustomersAboveAverageExpense
FROM (
    SELECT c.CustomerId, SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS InvoiceTotalPerCustomer
    FROM customer c
    INNER JOIN invoice i ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
    HAVING COUNT(DISTINCT i.InvoiceId) > 0 -- Active customers, need at least one invoice
) AS ActiveCustomer
WHERE InvoiceTotalPerCustomer > (
        SELECT AVG(InvoiceTotalPerCustomer)
        FROM (
            SELECT c.CustomerId,
                SUM(i.Total) / COUNT(DISTINCT c.CustomerId) AS InvoiceTotalPerCustomer
            FROM customer c
            INNER JOIN invoice i ON c.CustomerId = i.CustomerId
            GROUP BY c.CustomerId
            HAVING COUNT(DISTINCT i.InvoiceId) > 0 -- Active customers, need at least one invoice
        ) AS AvgCustomer
    );

-- 14.We want to know who is the most purchased artist (considering the number of purchased tracks), 
-- who is the most profitable artist (considering the total amount of money generated).
-- and who is the most listened artist (considering purchased song minutes).
-- Show the results in 3 rows in the following format: 
-- ArtistName, Concept('Total Quantity','Total Amount','Total Time (in seconds)'), Value
-- (hint:use the UNION statement)

(SELECT t1.Artist, "Total Quantity" AS Concept, sum(t1.Num_sold_tracks) as Value
FROM artists_profit t1
GROUP BY t1.Artist
ORDER BY sum(t1.Num_sold_tracks) desc
LIMIT 1)
UNION
(SELECT t1.Artist, "Total Amount" AS Concept, sum(t1.Revenue) AS VALUE
FROM artists_profit t1
GROUP BY t1.Artist
ORDER BY sum(t1.Revenue) DESC
LIMIT 1)
UNION
(SELECT t1.Artist, "Total time (in seconds)" AS Concept, sum(t1.Purchased_seconds) AS VALUE
FROM artists_profit t1
GROUP BY t1.Artist
ORDER BY sum(t1.Purchased_seconds) DESC
LIMIT 1);