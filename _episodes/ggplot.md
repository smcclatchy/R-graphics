---
title: "Scatterplots, histograms, and boxplots with ggplot()"
author: "Sue McClatchy"
date: "October 19, 2015"
output: html_document
---

## Learning Objectives
1. Build a layered plot with ggplot().
2. Save plot to a file.
3. Subset data.

## Introduction
*qplot()* is the simplest to use and its syntax is familiar, but gives the least control. Now let's try *ggplot()*. The base syntax is *ggplot(data, mapping) + layer()*. 

Load the ggplot library.


```r
library(ggplot2)
```

Load the data.


```r
cc <- read.csv(file="http://phenome.jax.org/grpdoc/MPD_projdatasets/CGDpheno3.csv")
```

```
## Warning in file(file, "rt"): cannot open URL 'https://phenome.jax.org/
## grpdoc/MPD_projdatasets/CGDpheno3.csv': HTTP status was '404 Not Found'
```

```
## Error in file(file, "rt"): cannot open the connection to 'http://phenome.jax.org/grpdoc/MPD_projdatasets/CGDpheno3.csv'
```

### Histogram

The ggplot function *aes()* maps data variables to visual properties of the plot.

```r
ggplot(cc, aes(x=RBC))
```

While *aes()* maps data variables to visuals in the plot, it doesn't actually execute the plot. We've included a mapping of red blood cells on the x axis and have indicated the cc data, but *ggplot()* requires a layer. Specifically the layer must be a geom, or geometric object in the plot. Add a layer with *geom_histogram()*.


```r
ggplot(cc, aes(x=RBC)) + 
  geom_histogram()
```

```
## Error in ggplot(cc, aes(x = RBC)): object 'cc' not found
```

The default binwidth (or bar width) is the range of the data divided by 30. Set the binwidth so that the bars break at each 0.1 increment.

```r
ggplot(data = cc, aes(x = RBC)) + 
  geom_histogram(binwidth = 0.1)
```

```
## Error in ggplot(data = cc, aes(x = RBC)): object 'cc' not found
```

Draw a vertical line through the mean value. Outline each bar in black and fill them with white.

```r
ggplot(cc, aes(x=RBC)) +
  geom_histogram(binwidth = 0.1, colour="black", fill = "white") +
  geom_vline(aes(xintercept=mean(RBC, na.rm=T)), color="red", linetype="dashed", size=1)
```

```
## Error in ggplot(cc, aes(x = RBC)): object 'cc' not found
```

Draw vertical lines for the mean by sex. Red is the mean value for females, blue for males.

```r
ggplot(cc, aes(x=RBC)) +
  geom_histogram(binwidth = 0.1, colour="black", fill = "white") +
  geom_vline(aes(xintercept=mean(RBC[sex == "f"], na.rm=T)), color="red", linetype="dashed", size=1) +
  geom_vline(aes(xintercept=mean(RBC[sex == "m"], na.rm=T)), color="blue", linetype="dashed", size=1)
```

```
## Error in ggplot(cc, aes(x = RBC)): object 'cc' not found
```

If you'd like to know whether or not the difference in means is significant, perform a t-test with the *t.test()* function.

The histogram seems to be bimodal. Overlay separate histograms by sex. Lighten the colors with the alpha argument to geom_histogram.

```r
ggplot(data = cc, aes(x = RBC, fill = sex)) + 
  geom_histogram(binwidth = 0.1, alpha = .5, position = "identity")
```

```
## Error in ggplot(data = cc, aes(x = RBC, fill = sex)): object 'cc' not found
```

It appears that only the histogram for females is bimodal. The male histogram appears to have a normal distribution.

Display density plots instead of histograms. Use the alpha argument to *geom_density* to lighten the colors.


```r
ggplot(cc, aes(x=RBC, fill=sex)) + 
  geom_density(alpha=0.5)
```

```
## Error in ggplot(cc, aes(x = RBC, fill = sex)): object 'cc' not found
```

### Scatterplot
Plot red blood cell counts by strain. Here, data = cc, mapping = red blood cells by strain. The layer is geom_point(), .

```r
ggplot(data = cc, aes(x = strain, y = RBC)) + 
  geom_point()
```

```
## Error in ggplot(data = cc, aes(x = strain, y = RBC)): object 'cc' not found
```

Color points by sex.

```r
ggplot(data = cc, aes(x = strain, y = RBC)) +
  geom_point(aes(colour = sex))
```

```
## Error in ggplot(data = cc, aes(x = strain, y = RBC)): object 'cc' not found
```

The strain names on the x-axis are illegible. We could switch x and y axes and place strain names on the y-axis for legibility, however, many geoms in ggplot don't treat the x and y axes equally. For this reason, we'll use *coord_flip()* to place strains on the y axis and red blood cells on the x. This should help readability. Later we will apply a statistical summary to values on the y-axis, so we'll leave RBC counts on the y and flip the coordinates. 

```r
ggplot(data = cc, aes(x = strain, y = RBC)) + 
  geom_point(aes(colour = sex)) + 
  coord_flip()
```

```
## Error in ggplot(data = cc, aes(x = strain, y = RBC)): object 'cc' not found
```

Reorder strains by mean RBC count. Save plot as a variable.

```r
rbc_plot <- ggplot(data = cc, aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE), y = RBC)) + 
  geom_point(aes(colour = sex)) + 
  coord_flip()
```

```
## Error in ggplot(data = cc, aes(x = reorder(strain, RBC, FUN = "mean", : object 'cc' not found
```

```r
rbc_plot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

The strain names are very crowded, so shrink the size of the labels on the y axis using a *theme()*.


```r
rbc_plot <- rbc_plot + theme(axis.text.y = element_text(size = rel(0.5)))
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

```r
rbc_plot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

Label the axes. Remember that y and x axes are flipped, so flip the labels.

```r
rbc_plot <- rbc_plot + xlab("strain") + ylab("red blood cell count (n/uL) ")
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

```r
rbc_plot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

Apply a statistical summary function (mean) to red blood cell count. We wouldn't be able to do this if we hadn't flipped the axes earlier with *coord_flip()*.

```r
rbc_plot <- rbc_plot + stat_summary(fun.y = "mean", geom = "point", colour = "mediumpurple4")
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

```r
rbc_plot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

Add a title.

```r
rbc_plot <- rbc_plot + ggtitle("Mean Red Blood Cells by Strain")
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

```r
rbc_plot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_plot' not found
```

Print plot to scalable vector graphics (svg) file. Replace svg below with pdf for a PDF file, or png for a PNG file.

```r
svg("rbc-strain-means.svg", width= 8, height = 9)
print(rbc_plot)
```

```
## Error in print(rbc_plot): object 'rbc_plot' not found
```

```r
dev.off()
```

```
## null device 
##           1
```

### Boxplots
Boxplots summarize the distribution of continuous variables against discrete ones. Create a boxplot of red blood cells by strain by changing the *geom*. Outliers are shown as purple dots.

Select a subset of the strains to create boxplots. Choose strains with the 3 highest and 3 lowest mean red blood cell counts.

```r
subset_cc <- subset(cc, strain %in% c("ACASTF1", "APWKF1", "B6CASTF1", 
                                      "A/J", "NODAF1", "NOD/ShiLtJ") == TRUE)
```

```
## Error in subset(cc, strain %in% c("ACASTF1", "APWKF1", "B6CASTF1", "A/J", : object 'cc' not found
```

Create boxplots from the subset. Re-order by mean RBC value as before.

```r
ggplot(data = subset_cc, 
                      aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE),
                          y = RBC)) + geom_boxplot()
```

```
## Error in ggplot(data = subset_cc, aes(x = reorder(strain, RBC, FUN = "mean", : object 'subset_cc' not found
```

This time there's no need to flip the axes since the strain names are legible on the x-axis. We also won't apply a statistical summary (the mean in prior example) to y-axis values this time. We have already re-ordered strains by mean RBC values but won't plot a point indicating the mean for each strain. We will plot each data point over the boxplots by adding a scatterplot layer with *geom_point()*. Color the points by sex.


```r
ggplot(data = subset_cc, 
                      aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE),
                          y = RBC)) + geom_boxplot()  +
  geom_point(aes(color = sex))
```

```
## Error in ggplot(data = subset_cc, aes(x = reorder(strain, RBC, FUN = "mean", : object 'subset_cc' not found
```

Separate boxplots by sex. Remove the points and indicate outliers as purple triangles. Save plot as a variable.

```r
rbc_boxplot <- ggplot(data = subset_cc,
                      aes(x = reorder(strain, RBC, FUN = "mean", na.rm = TRUE),
                          y = RBC)) +
  geom_boxplot(aes(colour = sex),
               outlier.colour = "mediumpurple", outlier.shape = 17)
```

```
## Error in ggplot(data = subset_cc, aes(x = reorder(strain, RBC, FUN = "mean", : object 'subset_cc' not found
```

```r
rbc_boxplot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_boxplot' not found
```

The upper whisker extends to the highest value within 1.5 * inter-quartile range, (distance between first and third quartiles). The lower whisker extends to the lowest value within 1.5 * IQR of the hinge. Data beyond the end of the whiskers (outliers) are plotted as triangles.

Rotate the strain labels by 45 degrees and lower them vertically so that they don't run into the plot area.

```r
rbc_boxplot <- rbc_boxplot + theme(axis.text.x = element_text(angle = 45, vjust = 0.7))
```

```
## Error in eval(expr, envir, enclos): object 'rbc_boxplot' not found
```

```r
rbc_boxplot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_boxplot' not found
```

Add x and y axis labels.

```r
rbc_boxplot <- rbc_boxplot + xlab("strain") + 
  ylab("red blood cell count (n/uL)")
```

```
## Error in eval(expr, envir, enclos): object 'rbc_boxplot' not found
```

```r
rbc_boxplot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_boxplot' not found
```

Add a title.

```r
rbc_boxplot <- rbc_boxplot + ggtitle("Red Blood Cell Distribution by Strain and Sex")
```

```
## Error in eval(expr, envir, enclos): object 'rbc_boxplot' not found
```

```r
rbc_boxplot
```

```
## Error in eval(expr, envir, enclos): object 'rbc_boxplot' not found
```

Output the plot to a PDF file. Set width and height.

```r
pdf("rbc-boxplot.pdf", width= 8, height = 9)
print(rbc_boxplot)
```

```
## Error in print(rbc_boxplot): object 'rbc_boxplot' not found
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

> Code Challenge: Create boxplots from one measurement against strain in the cc data using ggplot(). Label the axes and include a title. Add extras such as facets by sex, reordered means, flipped axes, or smaller axis text. Try subsetting the data and boxplotting the data subset.
