library(sp)
library(rgdal)
library(rgeos)
library(maptools)

sd  <- readOGR("./build/input/zip_code_shapefiles", "ZIP_CODES")