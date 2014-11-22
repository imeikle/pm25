# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
library(ggplot2)

# Find all classfications in SCC which correspond to Motor Vehicles
#
# Assumption: Full data set labelled in SCC.Level.Two variable
SCC.Motor <- SCC[(grepl("Highway Vehicles - Gasoline", SCC$SCC.Level.Two)),]

# Select the observations for Baltimore City based on fips value
NEI.Baltimore <- subset(NEI, fips == "24510")

# Select the observations for Los Angeles County based on fips value
NEI.LA <- subset(NEI, fips == "06037")

# Merge with the emissions data by SCC identifier
Motor.Baltimore <- merge(NEI.Baltimore,SCC.Motor, by = "SCC")

# Reduce dataframe by selecting only variables to be plotted
Motor.Baltimore.cut <- data.frame(Motor.Baltimore$SCC, Motor.Baltimore$Emissions,
                                  as.factor(Motor.Baltimore$year))

# Rename the variables for easier reference
names(Motor.Baltimore.cut) <- c("SCC","Emissions","year")

# Merge/Reduce/Rename as above
Motor.LA <- merge(NEI.LA,SCC.Motor, by = "SCC")
Motor.LA.cut <- data.frame(Motor.LA$SCC, Motor.LA$Emissions, as.factor(Motor.LA$year))
names(Motor.LA.cut) <- c("SCC","Emissions","year")

# Summarise the emissions data using dplyr operations for both data sets
Motor.Baltimore.Ems <- Motor.Baltimore.cut %>%
        group_by(SCC, year) %>%
        summarise(Total = sum(Emissions))

Motor.LA.Ems <- Motor.LA.cut %>%
        group_by(SCC, year) %>%
        summarise(Total = sum(Emissions))


# Some years are missing emission observations for SCC values, presumably due to
# changes in what is being monitored. A line graph mis-represents these missing 
# values by averaging between neighbours. To prevent this, missing values are 
# set to zero.

# Create table including all combinations of SCC and year
all.SCC <- expand.grid(SCC = SCC.Motor$SCC, year = c("1999", "2002", "2005", "2008"))

# For both data sets, merge with the full set of source ids,
# creating new entries where required and zeroing them
MB.all <- merge(all.SCC, Motor.Baltimore.Ems, all.x=TRUE)
MB.all[is.na(MB.all)] <- 0

LA.all <- merge(all.SCC, Motor.LA.Ems, all.x=TRUE)
LA.all[is.na(LA.all)] <- 0 

# Add panel variable to both data sets 
# Used to produce separate, aligned plots with labels
MB.all$panel <- "Baltimore"
LA.all$panel <- "Los Angeles"

# Bind both DFs together to create full plot data source
Motor.all <- rbind(MB.all, LA.all)

# Create plots, faceted by panel variable and by year
Motor <- ggplot(data = Motor.all, mapping = aes(SCC, Total, group=1))
# Locations have emission levels, so y-axis scales freely for each panel
Motor <- Motor + facet_grid(panel~year, scale="free")
Motor <- Motor + labs(title = "Emissions from Motor Vehicle Sources")
Motor <- Motor + labs( x = "Source of Emissions", y = "Total Emissions (Tons)")
Motor <- Motor + layer(data = MB.all, geom = c( "line"), color = "blue")
Motor <- Motor + layer(data = LA.all, geom = c( "line"),  color = "red")
Motor <- Motor + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())

# Print to a PNG file
png(filename = "plot6.PNG")
print(Motor)
dev.off()



