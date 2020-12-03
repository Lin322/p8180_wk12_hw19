###########################
#  IN-CLASS ASSIGNMENT 9  #
###########################

#Install sqldf package
install.packages("sqldf")

#Load sqldf package
library(sqldf)
library(tidyverse)

#Set working directory (point to folder where you have NHANES csv files)
setwd("C:/Users/fengl/Desktop/p8180_sqldf")

#Import the NHANES demographics csv file and call it "demo"
demo = read.csv("NHANES_Demographics.csv")

#Import the NHANES triglycerides csv file and call it "tri"
tri = read.csv("NHANES_Triglycerides.csv")

#Show the first few records of each dataframe to identify any common fields between them
head(demo)
head(tri)

#1. Write a query that would allow you to fill out table 1 and assign the results to an object called table1
table1_precise = sqldf("
    SELECT Race_Hispanic_origin_w_NH_Asian AS race, COUNT(Race_Hispanic_origin_w_NH_Asian) AS frequency, AVG(Age_in_years_at_screening) AS avg_age  
    FROM demo 
    GROUP BY Race_Hispanic_origin_w_NH_Asian")

table1 = sqldf("SELECT race, frequency, ROUND(avg_age,1) AS age_round FROM table1 GROUP BY race, frequency")

#2. Show the distribution of race by gender and display the race/gender combinations from highest to lowest 
#   frequency.  Note: when using SQL in R, you *can* refer to column aliases outside of the SELECT clause.

race_gender = sqldf("
                    SELECT Race_Hispanic_origin_w_NH_Asian AS race, Gender AS gender, COUNT(Gender) AS freq 
                    FROM demo
                    GROUP BY race, gender
                    ORDER BY freq DESC")

#3. Count the number of women who were pregnant at the time of screening.  Use the column alias preg_at_screen.
preg_count = sqldf("
                   SELECT Pregnancy_status_at_exam AS pregnancy, COUNT(Pregnancy_status_at_exam) AS preg_at_screen
                   FROM demo
                   WHERE pregnancy = 1
                   GROUP BY pregnancy")

#4. How many men refused to provide annual household income?
man_refused = sqldf("
                    SELECT Gender, Annual_household_income AS income, COUNT(Annual_household_income) AS man_refused
                    FROM demo
                    WHERE Gender = 1 AND income = 77
                    GROUP BY Gender, income
                    ")
# There are 57 men who refused to provide annual household income. 

#5. What is the mean LDL level (mg/dL) for men and women?  Use column alias mean_ldl and round results to 
#   1 decimal place.  
ldl_full = sqldf("
                 SELECT demo.Gender,demo.Race_Hispanic_origin_w_NH_Asian AS race, tri.*
                 FROM demo
                 LEFT JOIN tri
                 ON demo.Respondent_sequence_number = tri.Respondent_sequence_number")
head(ldl_full)



mean_ldl = sqldf("
                 SELECT Gender AS gender, AVG(LDL_cholesterol_mg_dL) AS mean_ldl
                 FROM ldl_full  
                 WHERE gender = 1
                 GROUP BY gender")

mean_ldl_round = sqldf("
                       SELECT gender, ROUND(mean_ldl,1)
                       FROM mean_ldl
                       GROUP BY gender")
    
#6. Display the minimum and maximum triglyceride levels (mmol/L) for each race.  Use column aliases min_tri and max_tri.
tri_max_min = sqldf("
                    SELECT race, MAX(Triglyceride_mmol_L) AS max_tri, MIN(Triglyceride_mmol_L) AS min_tri
                    FROM ldl_full
                    GROUP BY race")

    
#7. Create a new data frame that can be used for future analyses that combines all demographic data and any 
#   matching triglyceride data.  Call it demo_tri.
demo_tri = sqldf("
                 SELECT demo.*, tri.Triglyceride_mg_dL, tri.Triglyceride_mmol_L, tri.LDL_cholesterol_mg_dL, tri.LDL_cholesterol_mmol_L
                 FROM demo
                 LEFT JOIN tri
                 ON demo.Respondent_sequence_number = tri.Respondent_sequence_number")

