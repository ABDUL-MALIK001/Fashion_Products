-- The aim of this analysis is to provide understanding about the brand, product name, category, size, and color of a fashion item. 
-- This information will help facilitate informed decision-making in the future.


-- 1. Brand and Product Name with the most expense Price
WITH Highest_Name_Brand AS 
(SELECT
	Brand, Product_Name, Category, Price, 
	DENSE_RANK() OVER(PARTITION BY Product_Name ORDER BY Price DESC) AS Rank_Number
FROM 
	fashion_products)
SELECT 
	Brand, Product_Name, Category, Price
FROM
	Highest_Name_Brand
WHERE
	Rank_Number = 1
ORDER BY 4 DESC;

--2. Brand and Product Name with the most cheapest Price
WITH Cheapest_Name_Brand AS 
(SELECT
	Brand, Product_Name, Category, Price,
	DENSE_RANK() OVER(PARTITION BY Product_Name ORDER BY Price ASC) AS Rank_Number
FROM 
	fashion_products)
SELECT 
	Brand, Product_Name, Category, Price
FROM
	Cheapest_Name_Brand
WHERE
	Rank_Number = 1
ORDER BY 4 ASC;

-- 3. Most purchased Men's Fashion Products  
SELECT DISTINCT
	Product_Name, Category, 
	COUNT(Product_Name) OVER(PARTITION BY Product_Name) AS No_of_Purchase
FROM
	fashion_products
WHERE
	Category LIKE 'Men%'
ORDER BY
	3 DESC;

-- 4. Least purchased Women's Fashion Products  
SELECT DISTINCT
	Product_Name, Category, 
	COUNT(Product_Name) OVER(PARTITION BY Product_Name) AS No_of_Purchase
FROM
	fashion_products
WHERE
	Category LIKE 'Women%'
ORDER BY
	3 ASC;

-- 5. Brands with the highest sales among Kind's fashion
SELECT DISTINCT
	Brand, Category, 
	COUNT(Brand) OVER(PARTITION BY Brand) AS No_of_Purchase
FROM
	fashion_products
WHERE
	Category LIKE 'Kid%'
ORDER BY
	3 DESC;

-- 6. Top 3 Color purchased in Women's Fashion category
SELECT 
	TOP 3 Color, Category, COUNT(Color) AS Color_Count
FROM
	fashion_products
WHERE
	Category = 'Women''s Fashion'
GROUP BY
	Color, Category
ORDER BY
	3 DESC;

-- 7. Size with the highest Number of Sales among the Categories
WITH Size_Cat_Count AS 
	(
	SELECT 
		Size, Category, COUNT(Size) AS Size_Count
	FROM
		fashion_products
	GROUP BY
		Size, Category), -- To determine the count of each Size and Category
Size_Cat_Count2 AS 
	(
	SELECT 
		Size, Category, 
	MAX(Size_Count) AS Highest_Size_Count,
	ROW_NUMBER() OVER(PARTITION BY Category ORDER BY MAX(Size_Count) DESC) AS ROW_Num
	FROM
		Size_Cat_Count
	GROUP BY
		Size, Category) -- To determine the Maximum Size and Category and Filter the size and catergories with the highest count
SELECT
	Size, Category, Highest_Size_Count
FROM
	Size_Cat_Count2
WHERE
	ROW_Num = 1;


SELECT *
FROM fashion_products;


-- Average Price for each Product Name
SELECT Product_Name, AVG(Price) Products_Average_Price
FROM
	fashion_products
GROUP BY
	Product_Name
ORDER BY
	Products_Average_Price DESC;
GO

-- Average Price for each Category
SELECT Category, AVG(Price) Category_Average_Price
FROM
	fashion_products
GROUP BY
	Category
ORDER BY
	Category_Average_Price DESC;
GO

-- Average Price for each Brand
SELECT Brand, AVG(Price) Brand_Average_Price
FROM
	fashion_products
GROUP BY
	Brand
ORDER BY
	Brand_Average_Price DESC;
GO

