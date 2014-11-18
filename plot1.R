NEI <- transform(NEI, year = factor(year))
# Unsatisfactory boxplot with truncated y-axis due to massive outlierlibrary(data.table)

boxplot(Emissions ~ year, NEI, ylim = c(0,0.5))

library(data.table)
# Turn it into a datatable
NEI.tbl <- data.table(NEI)
# Sum over the emissions for each year
NEI.sum <- NEI.tbl[,sum(Emissions), by=year]
names(NEI.sum) <- c("year", "Total")
plot(Total ~ year, NEI.sum)

barplot(NEI.sum$Total, names.arg = NEI.sum$year, col = heat.colors(4))
pal <- colorRampPalette(c("red", "blue"))
barplot(NEI.sum$Total, names.arg = NEI.sum$year, col = pal(4))
