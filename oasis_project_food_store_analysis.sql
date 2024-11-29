SELECT * FROM oasis_project_cus_seg.ifood_df;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                    -- CREATE DUPLICATE TABLE FOR EDA -- 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE food_store
LIKE ifood_df;

INSERT INTO food_store
SELECT *
FROM ifood_df;		

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                  -- STANDARDIZE THE COLUMN NAMES ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                  

ALTER TABLE food_store
RENAME COLUMN marital_Divorced TO Marital_Divorced;

ALTER TABLE food_store
RENAME COLUMN MntWines TO Amount_On_Wines;

ALTER TABLE food_store
RENAME COLUMN MntWines TO Amount_On_Wines;

ALTER TABLE food_store
RENAME COLUMN MntFruits TO Amount_On_Fruits;

ALTER TABLE food_store
RENAME COLUMN MntMeatProducts TO Amount_On_MeatProducts;

ALTER TABLE food_store
RENAME COLUMN MntFishProducts TO Amount_On_FishProducts;

ALTER TABLE food_store
RENAME COLUMN MntSweetProducts TO Amount_On_SweetProducts;

ALTER TABLE food_store
RENAME COLUMN MntGoldProds TO Amount_On_Gold;

ALTER TABLE food_store
RENAME COLUMN NumDealsPurchases TO Num_Deals_Purchases;

ALTER TABLE food_store
RENAME COLUMN NumWebPurchases TO Num_Web_Purchases;

ALTER TABLE food_store
RENAME COLUMN NumCatalogPurchases TO Num_Catalogue_Purchases;

ALTER TABLE food_store
RENAME COLUMN NumStorePurchases TO Num_Store_Purchases;

ALTER TABLE food_store
RENAME COLUMN NumWebVisitsMonth TO Num_Web_Visits_Last_Month;

ALTER TABLE food_store
RENAME COLUMN AcceptedCmp3 TO Num_Cust_Accepted_Campaign3;

ALTER TABLE food_store
RENAME COLUMN AcceptedCmp4 TO Num_Cust_Accepted_Campaign4;

ALTER TABLE food_store
RENAME COLUMN AcceptedCmp5 TO Num_Cust_Accepted_Campaign5;

ALTER TABLE food_store
RENAME COLUMN AcceptedCmp1 TO Num_Cust_Accepted_Campaign1;

ALTER TABLE food_store
RENAME COLUMN AcceptedCmp2 TO Num_Cust_Accepted_Campaign2;

ALTER TABLE food_store
RENAME COLUMN Complain TO Complain_In_Last_Two_Years;

ALTER TABLE food_store
RENAME COLUMN marital_Married TO Married;

ALTER TABLE food_store
RENAME COLUMN marital_Single TO Single;

ALTER TABLE food_store
RENAME COLUMN Marital_Divorced TO Divorced;

ALTER TABLE food_store
RENAME COLUMN marital_Together TO Cohabitaion;

ALTER TABLE food_store
RENAME COLUMN Marital_Widow TO Widow;

ALTER TABLE food_store
RENAME COLUMN education_Basic TO Basic_Education;

ALTER TABLE food_store
RENAME COLUMN education_Graduation TO Graduate;

ALTER TABLE food_store
RENAME COLUMN education_Master TO Master_Degree;

ALTER TABLE food_store
RENAME COLUMN `education_2n Cycle` TO Education_2nd_Cycle;

ALTER TABLE food_store
RENAME COLUMN education_PhD TO Phd_Holder;

ALTER TABLE food_store
RENAME COLUMN MntTotal TO Total_Amount;

ALTER TABLE food_store
RENAME COLUMN MntRegularProds TO Regular_Amount_Prods;

ALTER TABLE food_store
RENAME COLUMN AcceptedCmpOverall TO Accepted_Overall_Campaign;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                        --  CATEGORIZE CUSTOMER BASE ON THEIR LAST PURCHASE --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE food_store
ADD COLUMN Cust_Category VARCHAR(25) ;

UPDATE food_store
SET Cust_Category = 'Recently Purchase'
WHERE Recency <= 30;

UPDATE food_store
SET Cust_Category = 'Not Quite Long Purchase'
WHERE Recency >= 31;

UPDATE food_store
SET Cust_Category = 'Very Long'
WHERE Recency >= 60;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                        --  CATEGORIZE CUSTOMER BASE ON THEIR YEAS WITH THE STORE --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

ALTER TABLE food_store
ADD COLUMN Cust_Tenure VARCHAR(25) ;

UPDATE food_store
SET Cust_Tenure = 'Six Years'
WHERE Customer_Days <= 2200;

UPDATE food_store
SET Cust_Tenure = 'Eight Years'
WHERE Customer_Days >= 2201;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
						     -- CHECK THE CATEGORY OF CUSTOMERS BASED ON THEIR LAST PURCHASED ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
                             

SELECT Cust_Category,
	COUNT(Recency) AS Customers_Category
FROM food_store
	GROUP BY Cust_Category
    ORDER BY Num_Cate DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                   -- TOTAL AMOUNT SPENT BY CUSTOMERS ---
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	SUM(Regular_Amount_Prods) AS Total_Revenue
FROM food_store;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                     -- REVENUE ON DIFFERENT CUSTOMER SEGMENTS --
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT Cust_Category,
	SUM(Total_Amount) AS Total_Revenue
FROM food_store
	GROUP BY Cust_Category
    ORDER BY Total_Revenue DESC;
    
SELECT Cust_Tenure,
	SUM(Total_Amount) AS Total_Revenue
FROM food_store
	GROUP BY Cust_Tenure
    ORDER BY Total_Revenue DESC;   
    
    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									-- THE TOTAL AMOUNT SPENT ON DIFFERENT PRODUCES BASE ON CUSTOMER TENURE --
------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
DELIMITER $$
CREATE PROCEDURE Cust_Total_Spent()
BEGIN
  
    SELECT Cust_Tenure,
	SUM(Amount_On_Wines) AS Total_Amount_Wines
	FROM food_store
	GROUP BY Cust_Tenure
    ORDER BY Total_Amount_Wines DESC;
    
	SELECT Cust_Tenure,
	SUM(Amount_On_Fruits) AS Total_Amount_Fruits
	FROM food_store
	GROUP BY Cust_Tenure
    ORDER BY Total_Amount_Fruits DESC;
    
    SELECT Cust_Tenure,
	SUM(Amount_On_FishProducts) AS Total_Amount_FishProducts
	FROM food_store
	GROUP BY Cust_Tenure
    ORDER BY Total_Amount_FishProducts DESC;

    SELECT Cust_Tenure,
	SUM(Amount_On_MeatProducts) AS Total_Amount_MeatProducts
	FROM food_store
	GROUP BY Cust_Tenure
    ORDER BY Total_Amount_MeatProducts DESC;
END $$
DELIMITER ;

CALL Cust_Total_Spent();
    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									-- THE TOTAL AMOUNT SPENT ON DIFFERENT PRODUCES BASE ON CUSTOMER SEGMENT --
------------------------------------------------------------------------------------------------------------------------------------------------------------------ 

DELIMITER $$
CREATE PROCEDURE CustCat_Total_Spent()
BEGIN
  
    SELECT Cust_Category,
	SUM(Amount_On_Wines) AS Total_Amount_Wines
	FROM food_store
	GROUP BY Cust_Category
    ORDER BY Total_Amount_Wines DESC;
    
	SELECT Cust_Category,
	SUM(Amount_On_Fruits) AS Total_Amount_Fruits
	FROM food_store
	GROUP BY Cust_Category
    ORDER BY Total_Amount_Fruits DESC;
    
    SELECT Cust_Category,
	SUM(Amount_On_FishProducts) AS Total_Amount_FishProducts
	FROM food_store
	GROUP BY Cust_Category
    ORDER BY Total_Amount_FishProducts DESC;

    SELECT Cust_Category,
	SUM(Amount_On_MeatProducts) AS Total_Amount_MeatProducts
	FROM food_store
	GROUP BY Cust_Category
    ORDER BY Total_Amount_MeatProducts DESC;
END $$
DELIMITER ;

CALL CustCat_Total_Spent();

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					    -- THE NUMBER OF PURCHASES MADE VIA CATALOGUE, STORE, WEB VISITS AND DISCOUNT BY CUSTOMER TENURE --
------------------------------------------------------------------------------------------------------------------------------------------------------------------ 

SELECT Cust_Tenure,
	SUM(Num_Catalogue_Purchases) AS Catalogue_Tot_Purchases
FROM food_store
	GROUP BY Cust_Tenure
	ORDER BY Catalogue_Tot_Purchases;

SELECT Cust_Tenure,
	SUM(Num_Deals_Purchases) AS Deal_Tot_Purchases
FROM food_store
	GROUP BY Cust_Tenure
	ORDER BY Deals_Tot_Purchases;

SELECT Cust_Tenure,
	SUM(Num_Web_Purchases) AS Web_Tot_Purchases
FROM food_store
	GROUP BY Cust_Tenure
	ORDER BY Web_Tot_Purchases;

SELECT Cust_Tenure,
	SUM(Num_Store_Purchases) AS Store_Tot_Purchases
FROM food_store
	GROUP BY Cust_Tenure
	ORDER BY Store_Tot_Purchases;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
									-- THE AVERAGE SPENT ON DIFFERENT PRODUCTS BASE ON CUSTOMER SEGMENT --
------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
  
SELECT Cust_Category,
	AVG(Amount_On_Wines) AS Avg_Amount_Wines
FROM food_store
	GROUP BY Cust_Category
    ORDER BY Avg_Amount_Wines DESC;
    
SELECT Cust_Category,
	AVG(Amount_On_Fruits) AS Avg_Amount_Fruits
FROM food_store
	GROUP BY Cust_Category
    ORDER BY Avg_Amount_Fruits DESC;
    
SELECT Cust_Category,
	AVG(Amount_On_FishProducts) AS Avg_FishProducts
FROM food_store
	GROUP BY Cust_Category
    ORDER BY Total_Amount_FishProducts DESC;

SELECT Cust_Category,
	AVG(Amount_On_MeatProducts) AS Avg_MeatProducts
FROM food_store
	GROUP BY Cust_Category
    ORDER BY Avg_MeatProducts DESC;













	SELECT Cust_Category,
	SUM(Amount_On_MeatProducts) AS Total_Amount_MeatProducts
	FROM food_store
	GROUP BY Cust_Category
    ORDER BY Total_Amount_MeatProducts DESC;
    
    
    
    























SELECT *
FROM food_store;


















------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						              -- CUSTOMERS WITH KID AT HOME AND THE NUMBER OF KIDS --
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT Kidhome,
	COUNT(Kidhome) AS Cnt
FROM food_store
	GROUP BY Kidhome;
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                     
    
    
    
    
    
    
    
                        
                        
                        
                        
                        
                        

























SELECT *
FROM food_store;











