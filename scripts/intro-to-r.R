# install.packages("here")
# install.packages("tidyverse")


# (1 - INTRO TO R)
# Load packages
library(tidyverse)
library(here)

here()
here("data")


# Download the data
## contains data about country stats on GDP, life expectancy, etc
download.file(
  "https://bit.ly/geospatial_data",
  here("data", "gapminder-data.csv")
)


