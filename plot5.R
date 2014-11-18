SCC.Motor <- SCC[(grepl("Highway Vehicles - Gasoline", SCC$SCC.Level.Two)),]
Motor.Baltimore <- merge(NEI.Baltimore,SCC.Motor, by = "SCC")
Motor.Baltimore.cut <- data.frame(Motor.Baltimore$SCC, Motor.Baltimore$Emissions, as.factor(Motor.Baltimore$year))
names(Motor.Baltimore.cut) <- c("SCC","Emissions","year")

library(dplyr)
Motor.Baltimore.cut <- group_by(Motor.Baltimore.cut, year, SCC)
Motor.cut.sum <- summarise(Motor.Baltimore.cut, sum(Emissions))
names(Motor.cut.sum) <- c("year", "SCC","Sum_emissions")
ggplot(data = Motor.cut.sum, aes(SCC, Sum_emissions)) + geom_point(color = "blue") + facet_grid(. ~ year)
