#libraries we need
library(spocc)
library(mapr)
library(ggplot2)
library(raster)

ext = extent(-125, -55, 20, 60)

spdist <- occ(query='Harmonia axyridis', from='gbif', limit=7500)
df=occ2df(spdist)

df = as.data.frame(occ2df(spdist$gbif))
map_leaflet(df[,c('name', 'longitude', 'latitude', 'stateProvince', 'country', 'year', 'occurrenceID')])

df = df %>% filter(longitude>=ext[1], longitude<=ext[2], latitude>=ext[3], latitude <=ext[4])
wc = crop(wc, ext)
wc_df = raster::as.data.frame(wc, xy=TRUE)

ggplot() +
  geom_raster(data = wc_df, aes(x = x, y = y, fill = bio1/10)) +
  geom_point(data=df, aes(x=longitude, y=latitude), col='green') +
  coord_quickmap() +
  theme_bw() + 
  scale_fill_gradientn(colours=c('navy', 'white', 'darkred'),
                       na.value = "black")