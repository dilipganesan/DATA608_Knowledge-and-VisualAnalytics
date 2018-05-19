# Geocoding a csv column of "addresses" in R

#load ggmap
library(ggmap)

# Select the file from the file chooser

# Read in the CSV data and store it in a variable 
origAddress <- read.csv('gunkids.csv', stringsAsFactors = FALSE)

# Initialize the data frame
geocoded <- data.frame(stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
for(i in 1:nrow(origAddress))
{
  result <- geocode(origAddress$Address[i], output = "latlona", source = "google")
  origAddress$lon[i] <- as.numeric(result[1])
  origAddress$lat[i] <- as.numeric(result[2])
}
# Write a CSV file containing origAddress to the working directory
write.csv(origAddress, "gunkidsgeo.csv", row.names=FALSE)


