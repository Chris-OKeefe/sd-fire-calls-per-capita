library(sp)
library(rgdal)
library(rgeos)
library(maptools)
library(readxl)
library(dplyr)
library(stringi)
library(reshape)
library(tmap)

rm(list = ls())

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
fd_calls$call_cat_count <- 1 #initialize a var = 1 for each row 
call_cat_ag <- aggregate(x = fd_calls$call_cat_count, by = list(fd_calls$call_category, fd_calls$date, fd_calls$zip), FUN = sum)
names(call_cat_ag) <- c("call_category", "date", "zip", "calls") #assign names to columns
call_cat_ag <- call_cat_ag[which(nchar(as.character(call_cat_ag$zip)) ==5),] #remove errors in Zip coding
call_cat_ag$zip <- as.numeric(levels(call_cat_ag$zip)[call_cat_ag$zip]) #convert zip codes to numeric

#Create Total rows
call_cat_ag$call_category <- stri_trans_totitle(call_cat_ag$call_category) # convert to title case.
call_category <- aggregate(calls ~ date + zip, data = call_cat_ag, FUN = sum, na.action = na.omit) #generate Total calls data
call_type <- "Total" 
call_category  <- cbind(call_type, call_category) #combind call_type, call_category data
names(call_category) <- c("call_category", "date", "zip", "calls") #rename call_category data
call_cat_ag <- rbind(call_cat_ag, call_category) #combine call_cat_ag, call_category data

#Reshape Data
call_cat_ag_melt <- melt(call_cat_ag, id.vars = c("zip", "date", "call_category"), measure.vars = c("calls"))
call_cat_ag_cast <- cast(call_cat_ag_melt, zip + date ~ call_category) #reshape data (before merge)

##SD Population Data##
pop_ag <- aggregate(x = sd_pop$POPULATION, by = list(sd_pop$ZIP), FUN = sum)
names(pop_ag) <- c("zip", "population")
pop_ag$zip <- as.numeric(pop_ag$zip)

##Merge Population, Fire calls data
pop_fire <- merge(pop_ag, call_cat_ag_cast, by = "zip")
#Create month-year data
pop_fire$month <- substr(pop_fire$date, 1, 7)

#subset data (by date range specified by Shiny input. For now, do it by the data here.)
sd_subset <- subset(pop_fire, date >= "2015-08-19" & date <= "2015-08-29")

##Aggrtegate by zip, call type, month (based on input)
#Initialize "Per Capita" Variables
for (n in names(sd_subset)[4:12]){
    sd_subset[[paste0(n," Per Capita")]] <- NA
}

#Aggregating for Call type data
for (n in names(sd_subset)[4:12]){
    sd_subset[[paste0(n, "_data")]] <- aggregate(x = sd_subset$n, by = list(sd_subset$zip), FUN = sum)
}

for (n in names(sd_subset)[4:12]){
    sd_subset[[paste0(n, "_data")]] <- aggregate(x = paste0("sd_subset$",n), by = list(sd_subset$zip), FUN = sum)
}

Total_data <- aggregate(x = sd_subset$Total, by = list(sd_subset$zip), FUN = sum) # can't calc pc until after this has collapsed by zip
call_data <- aggregate(x = sd_subset$x , by = list(sd_subset$[call type]), FUN = [percent of total]) #apply and do for all call types
month_data <- aggregate(x = sd_subset$Total, by = list(sd_subset$month))

##Zip Data##
names(sd_zip) <- tolower(names(sd_zip))

#Merge aggregated Pop/Fire data with zip data
#sd_zip@data <- left_join(sd_zip@data, call_cat_ag_cast, by = "zip")

#plot(sd_zip)

#I need to find a way to aggregate over an arbitrary range of dates in sd_zip$date
#Until I do that I can't actually plot the data.