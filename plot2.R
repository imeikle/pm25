subset(NEI, fips == 24510)
NEI.Baltimore <- subset(NEI, fips == 24510)
library(data.table)
NEI.Baltimore.tbl <- data.table(NEI.Baltimore)

NEI.Baltimore.sum <- NEI.Baltimore.tbl[, sum(Emissions), by=year]
setnames(NEI.Baltimore.sum, "V1", "Total")
plot(Total ~ year, NEI.Baltimore.sum)

pal <- colorRampPalette(c("red", "blue"))

barplot(NEI.Baltimore.sum$Total, names.arg = NEI.Baltimore.sum$year, col = pal(4))
