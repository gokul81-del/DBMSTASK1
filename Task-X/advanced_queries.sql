USE ecommerce_db;

SELECT Product_Name, Price
FROM Sales
WHERE Price > (
    SELECT AVG(Price)
    FROM Sales
);

SELECT Product_Name, Price
FROM Sales
WHERE Price = (
    SELECT MAX(Price)
    FROM Sales
);

SELECT Customer_Name, Total_Purchase
FROM (
    SELECT Customer_Name,
           SUM(Quantity * Price) AS Total_Purchase
    FROM Sales
    GROUP BY Customer_Name
) AS Customer_Sales
WHERE Total_Purchase > 50000;

SELECT Customer_Name,
       SUM(Quantity * Price) AS Total_Purchase
FROM Sales
GROUP BY Customer_Name
ORDER BY Total_Purchase DESC
LIMIT 1;

SELECT Customer_Name,
       SUM(Quantity * Price) AS Total_Purchase
FROM Sales
GROUP BY Customer_Name
HAVING SUM(Quantity * Price) > 50000;

SELECT Product_Name,
       SUM(Quantity) AS Total_Quantity_Sold
FROM Sales
GROUP BY Product_Name
ORDER BY Total_Quantity_Sold DESC
LIMIT 1;


SELECT Category,
       SUM(Quantity * Price) AS Total_Sales
FROM Sales
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 1;

SELECT DISTINCT Customer_Name
FROM Sales
WHERE Product_Name = 'Laptop';

SELECT
    Customer_Name,
    COUNT(*) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity,
    SUM(Quantity * Price) AS Total_Purchase,
    AVG(Quantity * Price) AS Average_Purchase,
    MIN(Quantity * Price) AS Minimum_Purchase,
    MAX(Quantity * Price) AS Maximum_Purchase
FROM Sales
GROUP BY Customer_Name
ORDER BY Total_Purchase DESC;
