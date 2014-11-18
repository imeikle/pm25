# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Transform the year variable to a factor
NEI <- transform(NEI, year = factor(year))

# Turn it into a data.table
library(data.table)
NEI.tbl <- data.table(NEI)

# Sum over the emissions for each year
NEI.sum <- NEI.tbl[,sum(Emissions), by=year]
names(NEI.sum) <- c("year", "Total")

# Create a color palette
pal <- colorRampPalette(c("red", "blue"))

# Display downward trend through a barplot
barplot(NEI.sum$Total, names.arg = NEI.sum$year, col = pal(4))
