# Install the following packages if you have not already:
install.packages('raster')
install.packages('randomForest')
install.packages('ggplot2')
install.packages('data.table')

# Once or if the packages are installed, then load them into R:
library(raster)
library (randomForest)
library(ggplot2)
library (data.table)

# Set your working directory:
setwd('C:/Directory')

# Read in your satellite imagery stack:
Imagery <- stack('Imagery.tif')

# Read in your training data polygons. Polygons should have 'Class' column, with labels as text:
Training <- shapefile('Training_Sites.shp')

# Check that your imagery and training data share the same coordinate information. The output should be TRUE:
compareCRS(Training, Imagery)

# Convert the 'class' column in your training polygons to a factor, which is needed for the classifier:
levels(as.factor(Training$Class))
for (i in 1:length(unique(Training$Class))) {cat(paste0(i, " ", levels(as.factor(Training$Class))[i]), sep="\n")}
