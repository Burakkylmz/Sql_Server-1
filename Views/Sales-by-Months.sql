

CREATE VIEW VW_SALES_MOUNTH
AS
SELECT DATEPART(YEAR,O.OrderDate) YEAR_,
CASE
	WHEN DATEPART(MONTH,O.OrderDate)=1 THEN 'JANUARY'
	WHEN DATEPART(MONTH,O.OrderDate)=2 THEN 'FEPRUARY'
	WHEN DATEPART(MONTH,O.OrderDate)=3 THEN 'MARCH'
	WHEN DATEPART(MONTH,O.OrderDate)=4 THEN 'APR�L'
	WHEN DATEPART(MONTH,O.OrderDate)=5 THEN 'MAY'
	WHEN DATEPART(MONTH,O.OrderDate)=6 THEN 'JUNE'
	WHEN DATEPART(MONTH,O.OrderDate)=7 THEN 'JULY'
	WHEN DATEPART(MONTH,O.OrderDate)=8 THEN 'AUGUST'
	WHEN DATEPART(MONTH,O.OrderDate)=9 THEN 'SEPTEMBER'
	WHEN DATEPART(MONTH,O.OrderDate)=10 THEN 'OCTOBER'
	WHEN DATEPART(MONTH,O.OrderDate)=11 THEN 'NOVAMBER'
	WHEN DATEPART(MONTH,O.OrderDate)=12 THEN 'DECEMBER'
END AS MOUNTH,

SUM(od.Quantity) QUANTITY,
SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) TOTAL,
CTG.CategoryName,
COUNT(OD.OrderID) PRODUCTAMOUNT,
COUNT(DISTINCT O.CustomerID) CUSTOMERAMOUNT
FROM
[Order Details] OD
JOIN Orders O ON OD.OrderID=O.OrderID
JOIN Products P ON P.ProductID=OD.ProductID
JOIN Customers C ON C.CustomerID=O.CustomerID
JOIN Categories CTG ON CTG.CategoryID=P.CategoryID

GROUP BY DATEPART(YEAR,O.OrderDate),DATEPART(MONTH,O.OrderDate),CTG.CategoryName

--Use created view--
SELECT * FROM VW_SALES_MOUNTH

--Creating a simplified view basen on first view--
CREATE VIEW VW_TOP_10
AS
SELECT TOP 10
CATEGORYNAME,TOTAL FROM VW_SALES_MOUNTH


