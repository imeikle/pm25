# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")

# Load the dplyr package
library(dplyr)

# Select the observations for Baltimore City based on fips value
NEI.Baltimore <- subset(NEI, fips == 24510)

# Create a table of total emissions in Baltimore per year using dplyr operations
NEI.Baltimore.sum <- NEI.Baltimore %>%
  select(Emissions, year) %>%
  group_by(year) %>%
  summarise(Total = sum(Emissions))

# Create a color palette
pal <- colorRampPalette(c("red", "blue"))

# Display barplot showing a fluctuating, generally downward trend
png(filename = "plot2.PNG")
barplot(NEI.Baltimore.sum$Total, names.arg = NEI.Baltimore.sum$year, col = pal(4))
title(main = "Total emissions - Baltimore", xlab = "Year", ylab = "Total emissions (Tons)")
dev.off()