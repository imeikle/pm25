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

# Add panel variable for plotting
MB.all$panel <- "Baltimore"
LA.all$panel <- "Los Angeles"

# Bind both DFs together to create plot panels
Motor.all <- rbind(MB.all, LA.all)

Motor <- ggplot(data = Motor.all, mapping = aes(SCC, Total, group=1))
Motor <- Motor + facet_grid(panel~year, scale="free")
Motor <- Motor + layer(data = MB.all, geom = c( "line"), stat = "identity", color = "blue")
Motor <- Motor + layer(data = LA.all, geom = c( "line"), stat = "identity", color = "red")
Motor <- Motor + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())
#Motor <- Motor + theme(axis.text.x = element_blank())
Motor

#ggplot() + geom_point(data = MB.all, aes(SCC, Total), color = "blue") + geom_point(data = LA.all, aes(SCC, Total), color = "red")

