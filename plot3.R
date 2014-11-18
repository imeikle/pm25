NEI.Baltimore <- subset(NEI, fips == 24510)
#qplot(year, Emissions, data = NEI.Baltimore, facets = . ~ type)
ggplot(NEI.Baltimore, aes(year, Emissions)) + geom_point() + geom_smooth(method = "lm") + aes(group=1) + facet_grid( ~ type)

