# # Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Transform the year variable to a factor
NEI <- transform(NEI, year = factor(year))

# Select the observations for Baltimore City based on fips value
NEI.Baltimore <- subset(NEI, fips == 24510)

# Turn it into a data.table
library(data.table)
NEI.Baltimore.tbl <- data.table(NEI.Baltimore)

# Sum over the emissions for each year
NEI.Baltimore.sum <- NEI.Baltimore.tbl[, sum(Emissions), by=year]
setnames(NEI.Baltimore.sum, "V1", "Total")

# Create a color palette
pal <- colorRampPalette(c("red", "blue"))

# Display barplot showing afluctuating, downward trend
barplot(NEI.Baltimore.sum$Total, names.arg = NEI.Baltimore.sum$year, col = pal(4))
