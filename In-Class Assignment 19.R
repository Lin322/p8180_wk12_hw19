##################################
# READING CSV FILES FROM THE WEB #
##################################

#Add the URL inside the quotes
url <- "[ADD THE CSV WEB ADDRESS HERE]"

#Assign the csv data to a data frame
covid_inpt <- read.csv(url)

#Show the column names in the data frame
names(covid_inpt)

#Show the first few rows of the data frame
head(covid_inpt)

####################### SQL #######################

install.packages("sqldf")
library(sqldf)

##### To refer to variables with a period in the name, surround the variable name in [] #####

#QUESTION 1 - Are the earliest and most recent dates reported the same for all states/terrories?  
#If so, give the date of earliest and most recent reporting.  If not, list the different dates reported by state.
earliset_last_date = sqldf(
  "SELECT state, MIN(collection_date) AS earliest_report_date, MAX(collection_date) AS most_recent_report_date
   FROM covid_inpt
   GROUP BY state
  ")

#QUESTION 2 - Which state/territory had the highest percentage of inpatient beds occupied by COVID-19
#patients on 11/28/2020?  What percentage of inpatient beds were occupied?


#QUESTION 3 - Which date and state/territory had the highest ever percentage of inpatient beds occupied by COVID-19
#patients since recording began?


#QUESTION 4 - What were the 3 worst days (by percentage) recorded for inpatient beds occupied by COVID-19 patients
#in New York State?  Report the date, number, and percentage of inpatient beds occupied.


#QUESTION 5 - Which state/territory appears to have been most successful during the reporting period in
#keeping COVID-19 patients out of inpatient beds?  Base on the average percentage of inpatient beds
#utilized over the reporting period.


#QUESTION 6 - Using the same query you wrote in #5, adjust it to show the top 10 most successful states
#during the reporting period.   
#Is New York State among the top 10? If yes, give its rank and average percentage.




###################################################################
# PULLING JSON DATA FROM THE WEB USING HTTR AND JSONLITE PACKAGES #
###################################################################

install.packages("httr")
library(httr)

install.packages("jsonlite")  #This package will help convert JSON data to a data frame
library(jsonlite)


#Restrict this data only to ZIP code 10032 and use SQL to provide an insight about restaurant 
#violations in the campus neighborhood.

#Pull restaurant violations data for Washington Heights
wahi <- GET("[ADD YOUR LINK TO JSON DATA HERE]", query = list("zipcode" = 10032))
new <- content(wahi, "text")

#Create data frame from JSON data
wahi_df <- fromJSON(new) #NOTE: this will be limited to 1000 records due to throttling

#Show variable names for new data frame
colnames(wahi_df)


####################### SQL #######################

#QUESTION 7 - How many critical violations are reported in this sample of inspections?


#QUESTION 8 - Give the name and address (building, street) of restaurant(s) with the highest 
#number of critical violations.  Account for possible ties in your results.


#QUESTION 9 - Similarly to question 8, give the name and address (building, street) of 
#restaurant(s) with the most A grades.  Account for possible ties in your results.


#QUESTION 10 - Create a data frame called closed containing restaurants that were indicated 
#to be closed in the action field.  The data frame should contain the restaurant name, 
#address (building, street), inspection date, and action.


#QUESTION 11 - List the restaurants included in the closed data frame and order them by number 
#of closures, from most to least.  Include the restaurant name and address.


#QUESTION 12 - Use SQL to answer a question of your choice about restaurant violations in the 
#campus neighborhood.


