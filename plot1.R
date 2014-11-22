# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")

library(dplyr)

# Create a table of total emissions per year using dplyr operations
NEI.sum <- NEI %>%
  select(Emissions, year) %>%
  group_by(year) %>%
  summarise(Total = sum(Emissions))

# Create a color palette
pal <- colorRampPalette(c("red", "blue"))

# Change number format so that y-axis is easier to read
opt <- getOption("scipen")
options("scipen" = 20)

# Print table as a barplot to show dereasing trend
barplot(NEI.sum$Total, names.arg = NEI.sum$year, col = pal(4))
title(main = "Total emissions across USA", xlab = "Year", ylab = "Total emissions (Tons)")

# Revert number format
options("scipen" = opt)
