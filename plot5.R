# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
library(ggplot2)

# Select the observations for Baltimore City based on fips value
NEI.Baltimore <- subset(NEI, fips == 24510)

# Find all classfications in SCC which correspond to Motor Vehicles
#
# Assumption: Full data set labelled in SCC.Level.Two variable

SCC.Motor <- SCC[(grepl("Highway Vehicles - Gasoline", SCC$SCC.Level.Two)),]

# Merge with the emissions data by SCC identifier
Motor.Baltimore <- merge(NEI.Baltimore,SCC.Motor, by = "SCC")

# Reduce dataframe by selecting only variables to be plotted
Motor.Baltimore.cut <- data.frame(Motor.Baltimore$SCC, Motor.Baltimore$Emissions,
                                  as.factor(Motor.Baltimore$year))

# Rename the variables for easier reference
names(Motor.Baltimore.cut) <- c("SCC","Emissions","year")

# Summarise the emissions data using dplyr operations
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

# Create plots, faceted by year
Motor <- ggplot(data = MB.all, aes(SCC, Total, color = year))
Motor <- Motor + facet_grid(. ~ year)
Motor <- Motor + labs(title = "Emissions from Motor Vehicle Sources (Baltimore)")
Motor <- Motor + labs( x = "Source of Emissions", y = "Total Emissions (Tons)")
# SCC identifiers and x-axis tick marks removed for clarity
Motor <- Motor + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())
Motor <- Motor + geom_line(aes(group=year))
Motor

# Print to a PNG file
png(filename = "plot5.PNG")
print(Motor)
dev.off()

