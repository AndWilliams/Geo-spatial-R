mkdir newrepo
cd newrepo

mkdir tmp #For stuff you do NOT want to commit to Git (e.g., climate dataa)
mkdir data # for data you do want to keep
mkdir R # for code
mkdir figures # for images and results files
echo "BIO331 Course Repository for Spatial Bioinformatics Unit" > README.md

# Downloading and working with raster data
library(raster)

clim = getData('worldclim', var='bio', res=5, path='tmp')

#resolution: 5 arcminutes
#lattitude & Longitude 42° 35' 10"
#formula is Degrees Minutes Seconds
#degrees is roughly calculated by the amount of (minutes*.166)/60 = degrees with decimals
#1 km ~= 0.5 min


#define an 'extent' object.
#eastern US
# defines area(xmin, xmax, ymin, ymax) 
ext = extent(-74, -69, 40, 45)

#crop data using our extent variable
c2=crop(clim,ext)

#basic plotting
plot(c2[[1]])

library(ggplot2)

c2_df = as.data.frame(c2, xy= TRUE)
head(c2_df)

#ggplot

ggplot()+
  geom_raster(data =c2_df, aes(x=x, y=y, fill=bio1))+
  coord_quickmap()

#making the ggplot call a variable that we can edit and interact with
base=ggplot()+
  geom_raster(data =c2_df, aes(x=x, y=y, fill=bio1))+
  coord_quickmap()

#edit of graph
base+ theme_bw()

#change the colors of the plot
base + 
  theme_bw() + 
  scale_fill_gradientn(colours=c('navy', 'white', 'darkred'), na.value = "black")