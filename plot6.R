NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)

SCC.Motor <- SCC[(grepl("Highway Vehicles - Gasoline", SCC$SCC.Level.Two)),]

NEI.Baltimore <- subset(NEI, fips == "24510")
NEI.LA <- subset(NEI, fips == "06037")

Motor.Baltimore <- merge(NEI.Baltimore,SCC.Motor, by = "SCC")
Motor.Baltimore.cut <- data.frame(Motor.Baltimore$SCC, Motor.Baltimore$Emissions, as.factor(Motor.Baltimore$year))
names(Motor.Baltimore.cut) <- c("SCC","Emissions","year")

Motor.LA <- merge(NEI.LA,SCC.Motor, by = "SCC")
Motor.LA.cut <- data.frame(Motor.LA$SCC, Motor.LA$Emissions, as.factor(Motor.LA$year))
names(Motor.LA.cut) <- c("SCC","Emissions","year")

Motor.Baltimore.Ems <- Motor.Baltimore.cut %>%
        group_by(SCC, year) %>%
        summarise(Total = sum(Emissions))

Motor.LA.Ems <- Motor.LA.cut %>%
        group_by(SCC, year) %>%
        summarise(Total = sum(Emissions))

# Subsitute zero for missing values of SCC in each year
all.SCC <- expand.grid(SCC = SCC.Motor$SCC, year = c("1999", "2002", "2005", "2008"))

MB.all <- merge(all.SCC, Motor.Baltimore.Ems, all.x=TRUE)
MB.all[is.na(MB.all)] <- 0

LA.all <- merge(all.SCC, Motor.LA.Ems, all.x=TRUE)
LA.all[is.na(LA.all)] <- 0 

# Problematic difference in scale - need to plot separately, one above the other - Include fips and use as a factor?
ggplot() + geom_point(data = MB.all, aes(SCC, Total), color = "blue") + geom_point(data = LA.all, aes(SCC, Total), color = "red")

