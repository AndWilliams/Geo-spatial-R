library(raster)
library(dplyr)
library(ggplot2)
taxon= "Nothofagus antarctica"
files = list.files('data', pattern = taxon, full.names=T)
print(files)

gri.files = files[grep('.gri', files)] #Only need one of the two files to read. R 'raster::stack()' finds the other.

mods = stack(gri.files)
names(mods) = c('current', '2070_2.6', '2070_8.5') ## Verify this is the same order as in gri.files object
plot(mods)

#Shifts 2.6 (best case scenario)
library(ggplot2)
  
  shift26 = mods[[2]] - mods[[1]] # future 2.6 scenario minus current prediction
  
  shift26_df = raster::as.data.frame(shift26, xy=T)
  
  (base26 = ggplot() +
      geom_raster(data = shift26_df, 
                  aes(x = x, y = y, fill = layer)) + 
      coord_quickmap() +
      theme_bw() + 
      scale_fill_gradientn(colours=c('navy', 'white', 'darkred'), na.value = "black"))


#Shifts 8.5 (worst case)
library(ggplot2)
  
  shift85 = mods[[3]] - mods[[1]] # future 2.6 scenario minus current prediction
  
  shift85_df = raster::as.data.frame(shift85, xy=T)
  
  (base85 = ggplot() +
      geom_raster(data = shift85_df, 
                  aes(x = x, y = y, fill = layer)) + 
      coord_quickmap() +
      theme_bw() + 
      scale_fill_gradientn(colours=c('navy', 'white', 'darkred'), na.value = "black"))


#Zoom in
ext = extent(-72, -58, -50, -25)#(West, East, South, North)
  shift85.NE = crop(shift85, ext)
  shift85.NE_df = raster::as.data.frame(shift85.NE, xy=T)
  
  (base85.NE = ggplot() +
      geom_raster(data = shift85.NE_df, 
                  aes(x = x, y = y, fill = layer)) + 
      coord_quickmap() +
      theme_bw() + 
      scale_fill_gradientn(colours=c('navy', 'white', 'darkred'), na.value = "black"))
