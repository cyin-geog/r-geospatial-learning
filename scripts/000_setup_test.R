# 000_setup_test.R
# Purpose: simplest possible setup check for the
# "Geospatial Data Carpentry for Urbanism" lesson.
# Run in RStudio with:  source("R/00_setup_test.R")
# Success = three packages load, versions print, and one test map plots.

# 1. Install only what is missing (binary packages, no compiling) ----
needed <- c("tidyverse", "sf", "terra")
missing_pkgs <- needed[!needed %in% rownames(installed.packages())]
if (length(missing_pkgs) > 0) {
  install.packages(missing_pkgs)
}

# 2. Load ----
library(tidyverse)  # ggplot2 + dplyr, from the Nov 9-10 workshop
library(sf)         # vector data
library(terra)      # raster data

cat("R version:   ", R.version.string, "\n")
cat("sf version:  ", as.character(packageVersion("sf")), "\n")
cat("terra version:", as.character(packageVersion("terra")), "\n")
cat("sf links to GDAL:", sf_extSoftVersion()["GDAL"], "\n")

# 3. Test 1, vector: build 3 points (UCSB, Isla Vista, Goleta) ----
places <- tibble(
  name = c("UCSB", "Isla Vista", "Goleta"),
  lon  = c(-119.8489, -119.8553, -119.8276),
  lat  = c(34.4133, 34.4133, 34.4358)
)

places_sf <- st_as_sf(places, coords = c("lon", "lat"), crs = 4326)
print(places_sf)
cat("CRS is geographic (degrees):", st_is_longlat(places_sf), "\n")

# Reproject to UTM Zone 11N (meters), the working CRS for Santa Barbara
places_utm <- st_transform(places_sf, 32611)
print(st_coordinates(places_utm))

# 4. Test 2, one map with ggplot2 (skills from Nov 9-10) ----
ggplot(places_sf) +
  geom_sf(size = 3) +
  geom_sf_text(aes(label = name), nudge_y = 0.004) +
  labs(
    title = "Setup test: three places near UCSB",
    subtitle = "Vector points in sf, plotted with ggplot2 / geom_sf"
  ) +
  theme_minimal()

# 5. Test 3, raster: make a tiny elevation-like raster and plot it ----
r <- rast(nrows = 10, ncols = 10,
          xmin = -119.87, xmax = -119.82,
          ymin = 34.40, ymax = 34.45, crs = "EPSG:4326")
values(r) <- 1:ncell(r)
names(r) <- "test_raster"
plot(r, main = "Setup test: terra raster")

cat("\nSetup test finished. If you saw two plots and no red errors,\n")
cat("you are ready for Lesson 1, Episodes 1-4.\n")
