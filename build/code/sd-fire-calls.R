library(sp)
library(rgdal)
library(rgeos)
library(maptools)
library(readxl)

#Read in Data
#SD zip code shapefiles
sd_zip  <- readOGR("./build/input/zip_code_shapefiles", "ZIP_CODES")
fd_calls <- read.csv("./build/input/fd_incidents_past_12_mo_datasd.csv", na.strings = "")
sd_pop <- read_excel("./build/input/census_2010_zip_1472015764836.xlsx", sheet = "Age")

#Aggregate sd_pop and fd_calls before merging
#Plot Shapefiles (verify it's in properly)
plot(sd_zip)