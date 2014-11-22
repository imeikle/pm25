# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
library(ggplot2)

# Find all classfications in SCC which correspond to Coal Combustion
SCC.coalComb <- SCC[(grepl("Coal", SCC$EI.Sector) 
    & grepl("Combustion", SCC$SCC.Level.One)),]

# Merge with the emissions data and select only variables to be plotted
NEI.SCC <- merge(NEI, SCC.coalComb, by = "SCC")
Coal.Ems <- data.frame(NEI.SCC$SCC, NEI.SCC$Emissions, as.factor(NEI.SCC$year))

# Rename the variables
names(Coal.Ems) <- c("SCC","Emissions","year")

# Summarise the emissions data using dplyr operations
Coal.Ems <- Coal.Ems %>%
        group_by(SCC,year) %>%
        summarise(Total = sum(Emissions))

# Working plot
# ggplot(data = Coal.Ems, aes(SCC, Total)) + geom_point(color = "blue") + facet_grid(. ~ year)
# Working histogram
# ggplot(data = Coal.Ems, aes(SCC, Total)) + geom_histogram(stat = "identity") + facet_grid(. ~ year)

# Working histogram with color - year as facet grid
# ggplot(data = Coal.Ems, aes(SCC, Total)) + geom_histogram(stat = "identity", aes(color = factor(year))) + facet_grid(. ~ year)

# Working histogram with color - year as color stack
# ggplot(data = Coal.Ems, aes(SCC, Total)) + geom_histogram(stat = "identity", aes(color = factor(year)))
# with terms re-arranged
# ggplot(data = Coal.Ems, aes(SCC, Total, color = factor(year))) + geom_histogram(stat = "identity")

# using fill
# ggplot(data = Coal.Ems, aes(SCC, Total, fill = factor(year))) + geom_histogram(stat = "identity")

# using line
# ggplot(data = Coal.Ems, aes(SCC, Total, color=year)) + geom_line(aes(group=year))

# Using line and facet grid - Needs data zeroing as in plot 5
ggplot(data = Coal.Ems, aes(SCC, Total, color=year)) + geom_line(aes(group=year))  + facet_grid(. ~ year)
