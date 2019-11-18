#libraries we need
library(spocc)
library(mapr)
library(ggplot2)
library(raster)


#downloading GBIF data
#spdist <- occ(query='Crotalus horridus', from='gbif', limit=7500)
spdist <- occ(query='Harmonia axyridis', from='gbif', limit=7500)

#look at s4 class
head(spdist$gbif$data)

#convert to data frame
df=occ2df(spdist)

#cleaner spdist
spdist2 <- occ(query='Crotalus horridus', limit=2500)
map_leaflet(spdist2)

#mapr to map our data
map_leaflet(spdist)

#map with data frame
df = as.data.frame(occ2df(spdist$gbif))

map_leaflet(df)

#getting fancy
map_leaflet(df[,c('name', 'longitude', 'latitude', 'stateProvince', 'country', 'year', 'occurrenceID')])

#Working with WorldClim 
wc = getData('worldclim', var='bio', res = 5)
ext = extent(-125, -55, 20, 60)
df = df %>% filter(longitude>=ext[1], longitude<=ext[2], latitude>=ext[3], latitude <=ext[4])
wc = crop(wc, ext)

#plot raster with points over specific area
ext = extent(-125, -55, 20, 60)
wc = crop(wc, ext)
wc_df = raster::as.data.frame(wc, xy=TRUE)
ggplot() +
  geom_raster(data = wc_df, aes(x = x, y = y, fill = bio1/10)) +
  geom_point(data=df, aes(x=longitude, y=latitude), col='green') +
  coord_quickmap() +
  theme_bw() + 
  scale_fill_gradientn(colours=c('navy', 'white', 'darkred'),
                       na.value = "black")

#Extracting climate data
extr = extract(wc, sp_df[,c('longitude', 'latitude')])
sp_ex =cbind(df[,c('name',
                   'longitude',
                   'latitude',
                   'stateProvidence',
                   'year',
                   'occurrenceID')],
             extr)
sp_ex=na.omit(sp_ex)
head(sp_ex)


summary(extr)
