USE ecommerce_db;

SELECT COUNT(*) AS Total_Sales
FROM Sales;

SELECT SUM(Quantity * Price) AS Total_Sales_Amount
FROM Sales;

SELECT AVG(Quantity * Price) AS Average_Sales
FROM Sales;

SELECT MIN(Quantity * Price) AS Minimum_Sale
FROM Sales;

SELECT MAX(Quantity * Price) AS Maximum_Sale
FROM Sales;

SELECT 
    COUNT(*) AS Total_Orders,
    SUM(Quantity * Price) AS Total_Sales,
    AVG(Quantity * Price) AS Average_Sale,
    MIN(Quantity * Price) AS Minimum_Sale,
    MAX(Quantity * Price) AS Maximum_Sale
FROM Sales;

SELECT 
    Customer_Name,
    SUM(Quantity * Price) AS Total_Purchase
FROM Sales
GROUP BY Customer_Name
ORDER BY Total_Purchase DESC
LIMIT 1;

SELECT 
    Product_Name,
    SUM(Quantity * Price) AS Total_Revenue
FROM Sales
GROUP BY Product_Name
ORDER BY Total_Revenue DESC;

SELECT 
    Category,
    COUNT(*) AS Number_of_Sales,
    SUM(Quantity) AS Total_Quantity,
    SUM(Quantity * Price) AS Total_Sales,
    AVG(Quantity * Price) AS Average_Sale
FROM Sales
GROUP BY Category
ORDER BY Total_Sales DESC;
