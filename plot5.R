NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)

NEI.Baltimore <- subset(NEI, fips == 24510)

SCC.Motor <- SCC[(grepl("Highway Vehicles - Gasoline", SCC$SCC.Level.Two)),]
Motor.Baltimore <- merge(NEI.Baltimore,SCC.Motor, by = "SCC")
Motor.Baltimore.cut <- data.frame(Motor.Baltimore$SCC, Motor.Baltimore$Emissions, as.factor(Motor.Baltimore$year))
names(Motor.Baltimore.cut) <- c("SCC","Emissions","year")

library(dplyr)

Motor.Baltimore.Ems <- Motor.Baltimore.cut %>%
        group_by(SCC, year) %>%
        summarise(Total = sum(Emissions))
        
# Subsitute zero for missing values of SCC in each year
all.SCC <- expand.grid(SCC = Motor.Baltimore.Ems$SCC, year = c("1999", "2002", "2005", "2008"))
MB.all <- merge(all.SCC, Motor.Baltimore.Ems, all.x=TRUE)
MB.all[is.na(MB.all)] <- 0


ggplot(data = MB.all, aes(SCC, Total, color = year)) + geom_line(aes(group=year)) + facet_grid(. ~ year)

