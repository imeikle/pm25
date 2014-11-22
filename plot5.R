NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
library(dplyr)
library(ggplot2)

NEI.Baltimore <- subset(NEI, fips == 24510)

SCC.Motor <- SCC[(grepl("Highway Vehicles - Gasoline", SCC$SCC.Level.Two)),]
Motor.Baltimore <- merge(NEI.Baltimore,SCC.Motor, by = "SCC")
Motor.Baltimore.cut <- data.frame(Motor.Baltimore$SCC, Motor.Baltimore$Emissions, as.factor(Motor.Baltimore$year))
names(Motor.Baltimore.cut) <- c("SCC","Emissions","year")

Motor.Baltimore.Ems <- Motor.Baltimore.cut %>%
        group_by(SCC, year) %>%
        summarise(Total = sum(Emissions))
        
# Some years are missing emission observations for SCC values, presumably due to
# changes in what is being monitored. A line graph mis-represents these missing 
# values by averaging between neighbours. To prevent this, missing values are 
# set to zero.

# Create table including all combinations of SCC and year
all.SCC <- expand.grid(SCC = Motor.Baltimore.Ems$SCC, year = c("1999", "2002", "2005", "2008"))

# Merge table with data, creating new entries where required and zeroing them
MB.all <- merge(all.SCC, Motor.Baltimore.Ems, all.x=TRUE)
MB.all[is.na(MB.all)] <- 0

Motor <- ggplot(data = MB.all, aes(SCC, Total, color = year))
Motor <- Motor + facet_grid(. ~ year)
Motor <- Motor + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())
Motor <- Motor + geom_line(aes(group=year))
Motor

ggplot(data = MB.all, aes(SCC, Total, color = year)) + geom_line(aes(group=year)) + facet_grid(. ~ year)

