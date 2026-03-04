library(terra)

# Replace with the path to the downloaded shapefile
veg_shp <- vect("VEGMAP.Shapefile")

# Quick plot
plot(veg_shp)
# 1️⃣ Load required packages
library(sf)       # For vector data
library(dplyr)    # For data manipulation
library(terra)    # Optional, for raster/vector handling

# 2️⃣ Load the VEGMAP shapefile
# Change the path to where you saved your VEGMAP shapefile
veg_shp <- st_read("VEGMAP2018.shp")

# Inspect it
print(veg_shp)
plot(st_geometry(veg_shp))  # quick check

# Install rinat if you haven't already
# install.packages("rinat")

library(rinat)
library(sf)
library(dplyr)
library(ggplot2)

# 1️⃣ Download Cape Parrot observations from iNaturalist
cp <- get_inat_obs(taxon_name = "Poicephalus robustus", maxresults = 1000)  # adjust maxresults if needed

# Inspect columns
head(cp[, c("longitude", "latitude", "observed_on")])

# 2️⃣ Convert to sf object
cp_geo <- st_as_sf(cp, coords = c("longitude", "latitude"), crs = 4326)

# 3️⃣ Load VEGMAP shapefile
veg_shp <- st_read("path/to/veg_2018.shp")

# Transform CRS to match points
veg_shp <- st_transform(veg_shp, st_crs(cp_geo))

# 4️⃣ Overlay Cape Parrot points on vegetation polygons
cp_with_veg <- st_join(cp_geo, veg_shp, join = st_within)

# 5️⃣ Summary: points per vegetation type
cp_summary <- cp_with_veg %>%
  st_drop_geometry() %>%
  group_by(VEG_CODE, VEG_NAME) %>%  # replace with correct VEGMAP columns
  summarise(n_points = n(), .groups = "drop")

print(cp_summary)

# 6️⃣ Plot Cape Parrot points on vegetation map
ggplot() +
  geom_sf(data = veg_shp, fill = "lightgreen", color = "darkgreen", alpha = 0.5) +
  geom_sf(data = cp_geo, color = "red", size = 2) +
  theme_minimal() +
  labs(title = "Cape Parrot Observations from iNaturalist on VEGMAP")

# 7️⃣ Save results as shapefile
st_write(cp_with_veg, "iNat_CapeParrot_with_VEGMAP.shp", delete_layer = TRUE)

