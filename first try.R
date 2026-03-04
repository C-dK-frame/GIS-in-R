library(sf)
install.packages(c("rinat", "sf", "dplyr","rosm","ggspatial","ggplot2"))
library(rinat)
library(sf)
library(dplyr)
library(rinat)
library(dplyr)
library(ggplot2)
library(sf)

cp <- get_inat_obs(
  taxon_name = "Poicephalus robustus",
  place_id = 6986,        # South Africa
  maxresults = 5000, quality = "research"
)

cp <- st_as_sf(cp, coords = c("longitude", "latitude"), crs = 4326)
class(cp)


ggplot() +
  geom_sf(data = cp) +
  theme_minimal()
library(ggspatial)
install.packages("prettymapr")
library(ggspatial)
ggplot() +
  annotation_map_tile(type = "osm", progress = "none") +
  geom_sf(data = cp, color = "darkgreen", size = 1) +
  theme_minimal()
library(leaflet)
install.packages("leaflet")
leaflet() %>%
  addTiles() %>%
  addCircleMarkers(
    data = cp,
    radius = 4,
    color = "forestgreen",
    popup = cp$url
  )



install.packages("rnaturalearthdata")
# Load libraries
library(sf)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)

# 1️⃣ Get South Africa country polygon
sa <- ne_countries(country = "South Africa", scale = "medium", returnclass = "sf")

# 2️⃣ Make some example points (replace with your real points)
set.seed(123)
n <- 20
points_df <- data.frame(
  lon = runif(n, 16.5, 32.5), 
  lat = runif(n, -35, -22)
)

# Convert to sf object
points_sf <- st_as_sf(points_df, coords = c("lon", "lat"), crs = 4326) # WGS84

# 3️⃣ Quick bounding box crop (optional, zoom to South Africa)
sa_bbox <- st_bbox(sa)
points_sf <- st_crop(points_sf, sa_bbox)

# 4️⃣ Plot map with points
ggplot() +
  geom_sf(data = sa, fill = "lightyellow", color = "black") +
  geom_sf(data = points_sf, color = "red", size = 2) +
  theme_minimal() +
  ggtitle("Temporary Map: Points over South Africa") +
  coord_sf(xlim = c(16.5, 33), ylim = c(-35, -22))
library(ggplot2)
library(ggspatial)

ggplot() +
  annotation_map_tile(type = "osm", progress = "none") +
  geom_sf(data = cp, color = "darkgreen", size = 2) +
  coord_sf(xlim = c(18, 20), ylim = c(-35.5, -33.5)) +  # Cape region extent
  labs(title = "Cape Parrot Sightings (Poicephalus robustus)") +
  theme_minimal()
library(leaflet)

leaflet(data = cp) %>%
  addProviderTiles("OpenStreetMap") %>%
  addCircleMarkers(
    radius = 4,
    color = "forestgreen",
    fillOpacity = 0.7,
    popup = ~paste0("<b>", url, "</b><br>", url)
  )
library(rnaturalearth)
library(rnaturalearthdata)

sa <- ne_countries(country = "South Africa", scale = "medium", returnclass = "sf")
cape_extent <- st_crop(sa, xmin = 25, xmax = 60, ymin = -35.5, ymax = -20)

ggplot() +
  annotation_map_tile(type = "osm", progress = "none") +
  geom_sf(data = cape_extent, fill = NA, color = "black") +
  geom_sf(data = cp, color = "darkgreen", size = 2) +
  theme_minimal()

library(raster)
library(ggplot2)
library(sf)
install.packages("geodata")
# download average temperature (tavg) for South Africa
temp_rsa <- geodata::worldclim_country(
  country = "South Africa",
  var = "tavg",     # mean temperature
  res = 10,         # resolution in arc minutes
  path = tempdir()
)
temp_mean <- terra::app(temp_rsa, mean)  # mean across all months
cp_geo <- st_as_sf(cp)  # ensures sf


# convert raster for ggplot
temp_df <- as.data.frame(terra::as.points(temp_mean), xy = TRUE)
colnames(temp_df) <- c("lon","lat","temp")

library(terra)

# Suppose temp_mean is your SpatRaster (1 layer)
temp_df <- as.data.frame(temp_mean, xy = TRUE, na.rm = TRUE)

# Check column names
names(temp_df)
colnames(temp_df) <- c("lon", "lat", "temp")

ggplot() +
  geom_raster(data = temp_df, aes(x = lon, y = lat, fill = temp)) +
  scale_fill_viridis_c(name = "Temp (°C)") +
  geom_sf(data = cp_geo, color = "red", size = 1) +
  coord_sf(xlim = c(16, 33), ylim = c(-35.5, -22)) +
  theme_minimal() +
  labs(title = "Mean Annual Temperature & Cape Parrot Sightings")




