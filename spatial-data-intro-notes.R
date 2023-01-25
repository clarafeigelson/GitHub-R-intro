source("setup.R")

#import colorado counties with tigris
counties <- counties(state = "CO")

#import roads for Larimer county
roads <- roads(state = "CO", county = "Larimer")

#set tmap mode to interactive
tmap_mode("view")

#qtm = quick thematic map
qtm(counties)+
  qtm(roads)

#this makes the same map as qtm
tm_shape(counties)+
  tm_polygons()

#look at the class of counties
class(counties)




#point data - not a spatial object yet
poudre_points <- data.frame(name = c("Mishawaka", "Rustic", "Blue Lake Trailhead"),
                            long = c(-105.35634, -105.58159, -105.85563),
                            lat = c(40.68752, 40.69687, 40.57960))

# convert poudre_points to spatial object with sf
# crs = coordinate reference system 
# 4326 = wgs 84 - most common coordinate system in US
poudre_points_sf <- st_as_sf(poudre_points, coords = c("long", "lat"), crs = 4326)



# raster data
# z = zoo level --> the resolution of data --> level 7 is close to 1 km
elevation <- get_elev_raster(counties, z = 7)

# create a quick thematic plot of elevation - but this is rough and does not have a good title
qtm(elevation)

# create a better thematic map of elevation
# tm_shape and tm_raster are prt of the tmap package
# tm_shape specifies that we are working with a spatial data object
# tm_raster specifies that we are working with raster data
# cont = continuous
tm_shape(elevation)+
  tm_raster(style = "cont", title = "Elevation (m)")



# the terra package
elevation <- rast(elevation)

# this renames elevation in the raster info --> helpful for making visuals
names(elevation) <- "Elevation"

# check for projections --> the most important part of this is the user input code
st_crs(counties)

# is crs of counties the same as the crs of the elevation --> the answer is no
crs(counties) == crs(elevation)

# project elevation layer --> matching up the crs of the counties and elevation
# make sure you specify that you are using the terra package
elevation_prj <- terra::project(elevation, counties)

# crop elevation to counties extent
elevation_crop<-crop(elevation, ext(counties))

# quick thematic map cropped to CO 
# ERROR MESSAGE: raster has no values
qtm(elevation_crop)



# read and write spatial data

# save sf/vector data
write_sf(counties, "data/counties.shp")

# save raster data
writeRaster(elevation_crop, "data/elevation.tif")

# save .RData (the variables in the environment)
save(counties, roads, file = "data/spatial_objects.RData")

# remove data from the environment
rm(counties, roads)
