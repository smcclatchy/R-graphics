---
title: "Scatterplots and histograms with qplot()"
author: "Sue McClatchy"
date: "October 15, 2015"
output: html_document
---

## Learning Objectives
1. Load data from a URL.
2. Build a plot with qplot().

## Introduction
R is a powerful language for data exploration and visualization. We will use the ggplot package developed by Hadley Wickham to build publication quality graphics. 

Load the ggplot library.


```r
library(ggplot2)
```

Read in data by specifying a URL for the file argument. This file contains baseline survey data for the 8 inbred Collaborative Cross founder strains and 54 F1 hybrids. Measurements include blood, cardiovascular, bone, body size, weight, and composition. For more information about this data set, see the [CGDpheno3 data](http://phenome.jax.org/db/q?rtn=projects/details&id=439) at Mouse Phenome Database.


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





















