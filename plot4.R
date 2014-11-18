
# Find all classfications in SCC which correspond to Coal Combustion
SCC.coalComb <- SCC[(grepl("Coal", SCC$EI.Sector) & grepl("Combustion", SCC$SCC.Level.One)),]

# Merge with the emissions data and select only variable to be plotted
NEI.SCC <- merge(NEI, SCC.coalComb, by = "SCC")
NEI.SCC.cut <- data.frame(NEI.SCC$SCC, NEI.SCC$Emissions, as.factor(NEI.SCC$year))

# Rename the variables
names(NEI.SCC.cut) <- c("SCC","Emissions","year")

# Next plots commented as they plot each county
# # Plot showing all SCC emissions (2 x 2)
# qplot(data=NEI.SCC.cut, x=SCC, y=Emissions, facets = ~year)
# 
# # Same plot using ggplot (4 x 1)
# ggplot(data = NEI.SCC.cut, aes(SCC, Emissions)) + geom_point(color = "red") + facet_grid(. ~ year)

# Convert to dplyr tbl
library(dplyr)
NCC.cut <- as.tbl(NEI.SCC.cut)

# Group by year and by SCC classification
NCC.cut <- group_by(NCC.cut, year, SCC)
NCC.cut.sum <- summarise(NCC.cut, sum(Emissions))

# Re-name variables
names(NCC.cut.sum) <- c("year", "SCC","Sum_emissions")

# Plot summed across the USA
ggplot(data = NCC.cut.sum, aes(SCC, Sum_emissions)) + geom_point(color = "blue") + facet_grid(. ~ year)
