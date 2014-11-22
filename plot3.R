# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")

library(ggplot2)

# Select the observations for Baltimore City based on fips value
NEI.Baltimore <- subset(NEI, fips == 24510)

# Create plots faceted by source type
Types <- ggplot(NEI.Baltimore, aes(year, Emissions))
Types <- Types + aes(group=1) + facet_grid( ~ type)
# Fit a linear model to show trend for each source
Types <- Types + geom_point() + geom_smooth(method = "lm") 
Types
