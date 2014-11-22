# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")

library(ggplot2)

# Select the observations for Baltimore City based on fips value
NEI.Baltimore <- subset(NEI, fips == 24510)

# Create plots faceted by source type
# Year needs to be a factor to line up x-axis labels
Types <- ggplot(NEI.Baltimore, aes(as.factor(year), Emissions))
Types <- Types + aes(group=1) + facet_grid( ~ type)
Types <- Types + theme(axis.text.x  = element_text(angle=90))
Types <- Types + labs(title = "Emission Trends by Source Type")
Types <- Types + labs( x = "Year", y = "Emissions (Tons)")
Types <- Types + scale_x_discrete(breaks = c("1999","2002","2005", "2008"),
                  labels = c("1999","2002","2005", "2008"))
# Fit a linear model to show trend for each source
Types <- Types + geom_point() + geom_smooth(method = "lm")

# Print to a PNG file
png(filename = "plot3.PNG")
print(Types)
dev.off()
