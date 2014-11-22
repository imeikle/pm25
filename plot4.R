# Read in data provided
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)
library(ggplot2)

# Find all classfications in SCC which correspond to Coal Combustion
#
# Assumption: Full data set obtained by union of 
#   EI.Sector variable mention of Coal
#   SCC.Level.One variable mention of Combustion

SCC.coalComb <- SCC[(grepl("Coal", SCC$EI.Sector) 
    & grepl("Combustion", SCC$SCC.Level.One)),]

# Merge with the emissions data by SCC identifier
NEI.SCC <- merge(NEI, SCC.coalComb, by = "SCC")

# Reduce dataframe by selecting only variables to be plotted
Coal.Ems <- data.frame(NEI.SCC$SCC, NEI.SCC$Emissions, as.factor(NEI.SCC$year))

# Rename the variables for easier reference
names(Coal.Ems) <- c("SCC","Emissions","year")

# Summarise the emissions data using dplyr operations
Coal.Ems <- Coal.Ems %>%
        group_by(SCC,year) %>%
        summarise(Total = sum(Emissions))

# Some years are missing emission observations for SCC values, presumably due to
# changes in what is being monitored. A line graph mis-represents these missing 
# values by averaging between neighbours. To prevent this, missing values are 
# set to zero.

# Create table including all combinations of SCC and year
all.SCC <- expand.grid(SCC = Coal.Ems$SCC, year = c("1999", "2002", "2005", "2008"))

# Merge table with data, creating new entries where required and zeroing them
Coal.all <- merge(all.SCC, Coal.Ems, all.x=TRUE)
Coal.all[is.na(Coal.all)] <- 0

# Change number format so that y-axis is easier to read
opt <- getOption("scipen")
options("scipen" = 20)

Coal <- ggplot(data = Coal.all, aes(SCC, Total, color=year))
Coal <- Coal + facet_grid(. ~ year)
Coal <- Coal + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())
Coal <- Coal + geom_line(aes(group=year))
Coal

# Revert number format
options("scipen" = opt)

# Need to remove axis text
#ggplot(data = Coal.all, aes(SCC, Total, color=year)) + geom_line(aes(group=year))  + facet_grid(. ~ year)
