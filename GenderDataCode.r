library(tidyverse)
library(DT)
library(data.table)
library(dplyr)
library(stringr)
library(PGRdup)
library(gender)

#IMPORT
##OJO Data
OJO_Data <- read_csv("SQ 780 Data.csv")
OJO_Data$ID <- seq.int(nrow(OJO_Data))
names(OJO_Data)[1] <- "County"
##County FIPS
FIPS <- read_csv("Counties and FIPS.csv")

#ID GENDER
##format names
NamesDF <- OJO_Data %>% 
  select(defname, ID) %>% 
  separate(defname, c("Last", "First", "Middle"))
##Add Min and Max Years
NamesDF$YearMin=1930
NamesDF$YearMax=2010
##Rejoin
NamesDF <- left_join(OJO_Data, NamesDF)
##Gender
GenderDF <- NamesDF %>%
  gender_df(name_col = "First",
            year_col = c("YearMin", "YearMax"),
            method = c("ssa", "ipums", "napp", "demo"))
names(GenderDF)[1] <- "First"
##Rejoin DFs
GenderedData <- inner_join(NamesDF, GenderDF, by = "First")
names(GenderedData)[1] <- "County"
##Anonymize
CleanGenderData <- read_csv("C:/Users/Jensen/Documents/_Graduate/Multimedia Journalism/GenderedData.csv")
CleanGenderData <- CleanGenderData %>% 
  subset(select = -c(defname, Last, First, Middle, YearMin, YearMax, year_min, year_max))

#EXPORT
write_csv(CleanGenderData, "Gendered SQ 780 Data.csv")


#NOTE: Code is defunct due to deleted gender package. Anonymized results from when this code was made are posted here.