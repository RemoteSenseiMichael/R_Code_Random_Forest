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

# Optional step is if your raster bands need renaming. View your raster bands:
names(Imagery)

# Rename bands:
names(Imagery) <- c("b1", "b2", "b3")

# Sample your imagery and classes, and save to a dataframe:
Sample <- extract(Imagery, Training, df = TRUE)

# Only run this following step if tuneRF function indicates, later, there are NA values in your data. It assigns all NA samples to 1:
Sample[is.na(Sample)] <-1

# Save your samples once completed:
save(Sample , file = 'C:/Samples.rda')

# Sampling produces a row each pixel and column for each band, as well as an ID column for each polygon. Establish a relationship between ID and Classes:
Sample$cl <- as.factor(Training$Class[match(Sample$ID, seq(nrow(Training)))])

# Then delete the initial ID column as it is not needed anymore:
Sample <- Sample[-1]

# Print a summary of your samples per class:
summary(Sample$cl)

# Display the structure of your Sample:
str(Sample)

# Tune a RF model:
RFmodel <- tuneRF(x = Sample[-ncol(Sample)], y = Sample$cl, strata = Sample$cl, ntreeTry = 50, improve = 0.05, trace = TRUE, plot = TRUE, doBest = TRUE, importance = TRUE)

# Call your model to see optimal parameters:
RFmodel

# Plot the variable importance metrics:
varImpPlot(RFmodel)

# If you want to extract the importance values as a dataframe, use the function:
Importance(RFmodel)

# Plot the RF model to see the relationship between OOB error and the number of trees used. Each variable in the plotted graph corresponds to the OOB for each class:
Plot(RFmodel)

# Save your RF model
save(RFmodel, file = 'E:/RFmodel.RData')

# Use your RF model to classify all the pixels in your imagery:
Classification <- predict(Imagery, RFmodel, filename = 'E:/Classification.tif')

# Plot your RF classification:
plot(Classification)





