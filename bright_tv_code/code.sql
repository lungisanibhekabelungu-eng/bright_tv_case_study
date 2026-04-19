
--- I want to see my table in the coding to start exploryting each column
select * from `constatio_claass`.`default`.`viewership_7` limit 100;
select * from `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles` limit 100;
-----------------------------------------------------------------------------------
---remiving todays date in duration
------------------------------------------------------------------------------------

select
   A. UserID,
   A. Channel2,
   A. RecordDate2,
   A. RecordDate2_to_SA_Time,
   A. date_format(`Duration 2` ,'HH:mm:ss') as Duration_hms
   from `constatio_claass`.`default`.`viewership_7`;

   ---TO RE-ARRANGE DATA ORDER RECORD_TO_SA_
SELECT

   UserID,
    Channel2,
    RecordDate2_to_SA_Time,
   date_format(`Duration 2` ,'HH:mm:ss') as Duration_hms
FROM `constatio_claass`.`default`.`viewership_7` 
ORDER BY RecordDate2_to_SA_Time, UserID ASC;




      
      

------------------------------------------------
-- 1. Checking the RecordDate2_to_SA_Time Range and time
-------------------------------------------------
-- They started collecting the data 2016-01-01 from 10:32
SELECT MIN(RecordDate2_to_SA_Time) AS min_date_and_time 
from  `constatio_claass`.`default`.`viewership_7`;
---the duration of the data is 6 months
---  They last collected the data 2016-04-01

SELECT MAX(RecordDate2_to_SA_Time) AS latest_date 
from `constatio_claass`.`default`.`viewership_7`;
-------------------------------------------------
-- 2. Checking CHANNELS
------------------------------------------------
-- we have 21 CHANNELS
SELECT DISTINCT Channel2
from `constatio_claass`.`default`.`viewership_7`;



---checking the number of provinces

select count( DISTINCT Province)
from `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles` limit 100;

select distinct
initcap(lower(Channel2)) as standardised_channel
from `constatio_claass`.`default`.`viewership_7`;

---remove fake channels
select
UserID,
    Channel2,
    RecordDate2_to_SA_Time,
   date_format(`Duration 2` ,'HH:mm:ss') as Duration_hms
from `constatio_claass`.`default`.`viewership_7`
where lower(channel2 ) != 'Break In Transmission' 
ORDER BY RecordDate2_to_SA_Time, UserID ASC;
---to delete break in transmission
delete
from `constatio_claass`.`default`.`viewership_7`
where Channel2 = 'Break In Transmission';

select
Age,
race,
UserID
from `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles`
WHERE AGE = 0;

---to check empty spaces
select
    UserID,
    Channel2,
    RecordDate2,
    RecordDate2_to_SA_Time,
    date_format(`Duration 2` ,'HH:mm:ss') as Duration_hms
   from `constatio_claass`.`default`.`viewership_7`
   where Channel2 ='';

   ---to check null valuses
   select
    UserID,
    Channel2,
    RecordDate2,
    RecordDate2_to_SA_Time,
    date_format(`Duration 2` ,'HH:mm:ss') as Duration_hms
   from `constatio_claass`.`default`.`viewership_7`
   where Channel2 is null;







---TO CHECK THE NUMBER OF PROVINCES 
SELECT DISTINCT Province
from `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles` limit 100; 

SELECT DISTINCT Email
from `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles` limit 100; 


select * from `constatio_claass`.`default`.`viewership_7` limit 100;
select * from `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles` limit 100;
SELECT 
A.UserID,

--- I want to see my table in the coding to start exploryting each column
select * from `constatio_claass`.`default`.`viewership_7` limit 100;
select * from `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles` limit 100;
-----------------------------------------------------------------------------------
---remiving todays date in duration
------------------------------------------------------------------------------------

SELECT
    A.UserID,
    B.Name,
    B.Surname,
    B.Email,
    
    -- Channel + timestamp, no duplicates
    A.Channel2 AS Channel,
    A.RecordDate2_to_SA_Time,
    
    -- Keep original HH:MM:SS format for Excel pivoting
    `Duration 2` AS Duration,
  
    -- Subscriber Demographics with proper NULL handling
    B.Age,
    COALESCE(B.Province, 'Unknown') AS Province,
    COALESCE(B.Race, 'Other') AS Race,
    COALESCE(B.Gender, 'Unknown') AS Gender,
  
    -- Time buckets based on SA time
    CASE
        WHEN DATE_FORMAT(TO_TIMESTAMP(A.RecordDate2_to_SA_Time, 'M/d/yy H:mm'), 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
        WHEN DATE_FORMAT(TO_TIMESTAMP(A.RecordDate2_to_SA_Time, 'M/d/yy H:mm'), 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '02. Afternoon'
        WHEN DATE_FORMAT(TO_TIMESTAMP(A.RecordDate2_to_SA_Time, 'M/d/yy H:mm'), 'HH:mm:ss') >= '17:00:00' THEN '03. Evening'
    END AS time_buckets,
  
    -- Age Bands with NULL handling
    CASE 
        WHEN B.Age IS NULL THEN '8. Unknown'
        WHEN B.Age < 18 THEN '1. Under 18'
        WHEN B.Age BETWEEN 18 AND 24 THEN '2. 18-24' 
        WHEN B.Age BETWEEN 25 AND 34 THEN '3. 25-34'
        WHEN B.Age BETWEEN 35 AND 44 THEN '4. 35-44'
        WHEN B.Age BETWEEN 45 AND 54 THEN '5. 45-54'
        WHEN B.Age BETWEEN 55 AND 64 THEN '6. 55-64'
        WHEN B.Age BETWEEN 65 AND 89 THEN '7. 65-89'
        WHEN B.Age >= 90 THEN '8. 90+'
        ELSE '8. Unknown'
    END AS Age_Band,
  
    -- Weekend Flag
    CASE 
        WHEN DAYOFWEEK(TO_TIMESTAMP(A.RecordDate2_to_SA_Time, 'M/d/yy H:mm')) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type

FROM `constatio_claass`.`default`.`viewership_7` AS A
LEFT JOIN `constatio_claass`.`default`.`_bright_tv_dataset_user_profiles` AS B
    ON A.UserID = B.UserID;

