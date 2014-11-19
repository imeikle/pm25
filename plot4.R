NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)

# Find all classfications in SCC which correspond to Coal Combustion
SCC.coalComb <- SCC[(grepl("Coal", SCC$EI.Sector) & grepl("Combustion", SCC$SCC.Level.One)),]

# Merge with the emissions data and select only variable to be plotted
NEI.SCC <- merge(NEI, SCC.coalComb, by = "SCC")
Coal.Ems <- data.frame(NEI.SCC$SCC, NEI.SCC$Emissions, as.factor(NEI.SCC$year))

# Rename the variables
names(Coal.Ems) <- c("SCC","Emissions","year")

# Put the data in "long" format
Coal.Ems <- Coal.Ems %>%
        group_by(SCC,year) %>%
        summarise(Total = sum(Emissions))

# Working plot
ggplot(data = Coal.Ems, aes(SCC, Total)) + geom_point(color = "blue") + facet_grid(. ~ year)
