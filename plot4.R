SCC[grep("Coal", SCC$EI.Sector),]

SCC[(grepl("Coal", SCC$EI.Sector) & grepl("Combustion", SCC$SCC.Level.One)),]

SCC.coalComb <- SCC[(grepl("Coal", SCC$EI.Sector) & grepl("Combustion", SCC$SCC.Level.One)),]
SCC.NEI <- merge(SCC.coalComb, NEI, by = "SCC")
NEI.SCC <- merge(NEI, SCC.coalComb, by = "SCC")
NEI.SCC.cut <- data.frame(NEI.SCC$SCC, NEI.SCC$Emissions, as.factor(NEI.SCC$year))
names(NEI.SCC.cut) <- c("SCC","Emissions","year")
qplot(data=NEI.SCC.cut, x=SCC, y=Emissions, color=year)
qplot(data=NEI.SCC.cut, x=SCC, y=Emissions, facets = ~year)
# Experiment with scale_color_gradient and scale_fill_continuous:
# http://docs.ggplot2.org/0.9.3.1/scale_gradient.html
