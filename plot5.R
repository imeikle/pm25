SCC.Motor <- SCC[(grepl("Highway Vehicles - Gasoline", SCC$SCC.Level.Two)),]
Motor.Baltimore <- merge(NEI.Baltimore,SCC.Motor, by = "SCC")
