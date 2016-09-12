library(sp)
library(rgdal)
library(rgeos)
library(maptools)
library(readxl)
library(dplyr)

function(start_date, end_date, variable){
    aggregate() #fd_calls
    aggregate() #sd_pop
    left_join()
    plot() # plot using variable from function args.
}
#Read in Data
#SD zip code shapefiles
sd_zip  <- readOGR("./build/input/zip_code_shapefiles", "ZIP_CODES")
fd_calls <- read.csv("./build/input/fd_incidents_past_12_mo_datasd.csv", na.strings = "")
    #Assume missing data is zero?
sd_pop <- read_excel("./build/input/census_2010_zip_1472015764836.xlsx", sheet = "Age")

#Aggregate sd_pop and fd_calls before merging

##FD calls##
#Separate date and time in fd_calls data.
fd_calls$date <- substr(fd_calls$response_date,1,10)
fd_calls$date <- as.Date(fd_calls$date)

#Aggregate FD calls data by call category, date, and zip code.
call_cat_ag <- aggregate(x = fd_calls$call_cat_count, by = list(fd_calls$call_category, fd_calls$date, fd_calls$zip), FUN = sum)
names(call_cat_ag) <- c("call_category", "date", "zip", "calls")

#Remove errors in zip coding
call_cat_ag <- call_cat_ag[which(nchar(as.character(call_cat_ag$zip)) ==5),]

##SD Population Data##
pop_ag <- aggregate(x = sd_pop$POPULATION, by = list(sd_pop$ZIP), FUN = sum)
names(pop_ag) <- c(zip, population)

#It looks like Sullins' Tableau project aggregates on the fly based on the date range you give it.
#Plot Shapefiles (verify it's in properly)
plot(sd_zip)