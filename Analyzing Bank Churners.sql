USE bankchurners_1;

-- STEP 1: Examine the data

-- Check for duplicates
SELECT 
	CLIENTNUM,
    COUNT(CLIENTNUM) AS Duplicated
FROM
	bankchurners_1
GROUP BY
	CLIENTNUM
HAVING
	Duplicated > 1;

-- Check max and minimum customer age
SELECT
	MIN(Customer_Age), MAX(Customer_Age)
FROM
	bankchurners_1;

-- STEP 2: Age Categorization for customers for Existing and Attrited customers
CREATE TABLE Age_Summarized AS
(SELECT 
	bc.CLIENTNUM,
    bc.Attrition_Flag,
    "25-34" AS Age_Group
    FROM bankchurners_1 bc
    WHERE bc.Customer_Age BETWEEN 25 AND 34
UNION
SELECT 
	bc.CLIENTNUM,
    bc.Attrition_Flag,
    "35-44" AS Age_Group
    FROM bankchurners_1 bc
    WHERE bc.Customer_Age BETWEEN 35 AND 44
UNION
SELECT 
	bc.CLIENTNUM,
    bc.Attrition_Flag,
    "45-54" AS Age_Group
    FROM bankchurners_1 bc
    WHERE bc.Customer_Age BETWEEN 45 AND 54
UNION
SELECT 
	bc.CLIENTNUM,
    bc.Attrition_Flag,
    "55-64" AS Age_Group
    FROM bankchurners_1 bc
    WHERE bc.Customer_Age BETWEEN 55 AND 64
UNION
SELECT 
	bc.CLIENTNUM,
    bc.Attrition_Flag,
    "65+" AS Age_Group
    FROM bankchurners_1 bc
    WHERE bc.Customer_Age > 64);

-- STEP 3: Attrited customers' distribution in different age brackets
SELECT 
	ags.Attrition_Flag,
    ags.age_group,
    COUNT(*)/ (SELECT COUNT(*) FROM age_summarized WHERE Attrition_Flag = "Attrited Customer")*100 AS Customer_Age_Distribution_percent
FROM
	age_summarized ags
WHERE
	ags.Attrition_Flag = "Attrited Customer"
GROUP BY
	ags.age_group;

-- STEP 4: Attrited customers' gender distribution 
SELECT 
	Attrition_Flag,
    Gender,
    COUNT(*)/ (SELECT COUNT(*) FROM bankchurners_1 WHERE Attrition_Flag = "Attrited Customer")*100 AS Customer_Gender_Distribution_percent
FROM
	bankchurners_1
WHERE
	Attrition_Flag = "Attrited Customer"
GROUP BY
	Gender;

-- STEP 5: Attrited customers' income distribution 
SELECT 
	Attrition_Flag,
    Income_Category,
    COUNT(*)/ (SELECT COUNT(*) FROM bankchurners_1 WHERE Attrition_Flag = "Attrited Customer")*100 AS Customer_Income_Distribution_percent
FROM
	bankchurners_1
WHERE
	Attrition_Flag = "Attrited Customer"
GROUP BY
	Income_Category
ORDER BY
	3;

-- STEP 6: Attrited customers' marital status distribution 
SELECT 
	Attrition_Flag,
    Marital_Status,
    COUNT(*)/ (SELECT COUNT(*) FROM bankchurners_1 WHERE Attrition_Flag = "Attrited Customer")*100 AS Customer_Gender_Distribution_percent
FROM
	bankchurners_1
WHERE
	Attrition_Flag = "Attrited Customer"
GROUP BY
	Marital_Status;

-- STEP 7: Attrited customers' education level distribution 
SELECT 
	Attrition_Flag,
    Education_Level,
    COUNT(*)/ (SELECT COUNT(*) FROM bankchurners_1 WHERE Attrition_Flag = "Attrited Customer")*100 AS Customer_Gender_Distribution_percent
FROM
	bankchurners_1
WHERE
	Attrition_Flag = "Attrited Customer"
GROUP BY
	Education_Level
ORDER BY
	3;

-- STEP 8: Modified RFM Analysis For Attrited customers
SELECT 
	CLIENTNUM,
    Attrition_Flag,
    Months_Inactive_12_mon AS Months_Inactive,
    Total_Trans_Ct AS Frequency,
    Total_Trans_Amt AS Monetary,
    NTILE(5) OVER (ORDER BY Months_Inactive_12_mon DESC) AS MI,
    NTILE(5) OVER (ORDER BY Total_Trans_Ct) AS F,
    NTILE(5) OVER (ORDER BY Total_Trans_Amt) AS M
FROM
	bankchurners_1
WHERE
	Attrition_Flag = "Attrited Customer";

-- STEP 9: Average RFM: Existing vs Attrited customers
SELECT 
    Attrition_Flag,
    AVG(Months_Inactive_12_mon) AS Months_Inactive,
    AVG(Total_Trans_Ct) AS Frequency,
    AVG(Total_Trans_Amt) AS Monetary
FROM
	bankchurners_1
GROUP BY
	Attrition_Flag;

-- STEP 10: Average Months on book: Existing vs Attrited customers
SELECT
	Attrition_Flag,
	AVG(Months_on_book) 
FROM
	bankchurners_1
GROUP BY
	Attrition_Flag;

-- STEP 11: Average total relationship counts: Existing vs Attrited customers
SELECT
	Attrition_Flag,
	AVG(Total_Relationship_Count) 
FROM
	bankchurners_1
GROUP BY
	Attrition_Flag;

-- STEP 12: Average months inactive and contacts count in the last year: Existing vs Attrited customers
SELECT
	Attrition_Flag,
	AVG(Months_Inactive_12_mon),
    AVG(Contacts_Count_12_mon)
FROM
	bankchurners_1
GROUP BY
	Attrition_Flag;

-- STEP 13: Average Avg_Utilization_Ratio: Existing vs Attrited customers
SELECT 
    Attrition_Flag,
    AVG(Avg_Utilization_Ratio)
FROM
	bankchurners_1
GROUP BY
	Attrition_Flag;

-- STEP 14: Average Credit limit and Revolving Balance by Card Category: Existing vs Attrited customers
SELECT 
    Attrition_Flag,
    Card_Category,
    AVG(Credit_Limit),
    AVG(Total_Revolving_Bal)
FROM
	bankchurners_1
GROUP BY
	Attrition_Flag, Card_Category
ORDER BY
	1, 2;