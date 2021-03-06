# San Diego Fire Calls Per Capita
Recreate [Ben Sullins' breakdown of SD fire calls](http://bensullins.com/san-diego-fire-department-calls-analysis/) using per capita data.

Fire calls data from the [San Diego Open Data portal](http://data.sandiego.gov/dataset/fire-incidents).

Zip code level population data from [SANDAG Data Surfer](datasurfer.sandag.org)
*Selections: Census, 2010, Zip, 91906
*Selected all zips on data view page
*Downloaded data as .xls file (save as .ods)

Zip code shapefiles from [SanGIS/SANDAG GIS Data Warehouse](www.sangis.org). Zip shapefiles are under the 'Miscellaneous' link in 'GIS Data Categories'.

## Skills
* Use R's GIS packages 
* Use R's shiny and shiny dashboards to display data.

## To do
1. Read data into R. DONE
2. Collapse data at Zip code level. DONE
3. Combine fire calls and population data. DONE
4. Get SD county zip code shape files. DONE
5. Output data & plots to shiny dashboard
6. Modify dashboard to compare different versions of data (raw, per capita)

