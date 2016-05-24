################################################################
# An exploration of ggplot using scatterplots.
# Sue McClatchy
# created 2014-03-28
# modified 2015-10-15
################################################################

################################################################
# Load libraries and read in data.
################################################################

library(ggplot2)
library(plyr)

# Load the CC founder and inbred survey from Mouse Phenome Database.

cc <- read.csv(file="http://phenome.jax.org/grpdoc/MPD_projdatasets/CGDpheno3.csv")
str(cc)

# How many animals of each strain?
sort(table(cc$strain))
# How many of each by sex?
table(cc$strain, cc$sex)

################################################################
# Quick plots with qplot()
################################################################

# Have a quick exploratory look at the data. The qplot() syntax will be 
# very familiar if you use plot(). Here, a scatterplot of red blood cells 
# with strains on the y axis. 
qplot(RBC, strain, data = cc, 
      xlab="red blood cell count (n/uL)")

# Color points by sex. Add a title.
qplot(x=RBC, y=strain, data=cc, 
      colour=sex, 
      xlab="red blood cell count (n/uL)", 
      main = "Red Blood Cell Count by Sex")

# Order the strains by mean RBC value.
qplot(x=RBC, y=reorder(cc$strain, cc$RBC, FUN=mean, na.rm=TRUE), 
      data=cc, colour=sex, 
      xlab="red blood cell count (n/uL)", 
      ylab = "strain", 
      main = "Red Blood Cell Count by Sex")

# Use facets to view males and females separately.
qplot(x=RBC, y=strain, data=cc, 
      facets = . ~ sex, 
      colour=sex, 
      xlab="red blood cell count (n/uL)", 
      main = "Red Blood Cell Count by Sex")

################################################################
# ggplot()
################################################################

# qplot() is the simplest to use and its syntax is familiar, but gives the least
# control. Now let's try ggplot(). The base syntax is ggplot(data, mapping) + layer().
# Here, data = cc, mapping = RBC by strain
p <- ggplot(cc, aes(x=strain, y=RBC))
p
# Error: No layers in plot

# Add a layer with geom(). Data are shown as points.
p + geom_point()

# Color by sex.
p + geom_point(aes(colour=sex))

# For scatterplots, it's easy to flip the axes, however, many geoms in ggplot
# don't treat the x and y axes equally. For this reason, we'll use coord_flip()
# to place strains on the y axis and RBC on the x.
p + geom_point(aes(colour=sex)) + 
  coord_flip()

# Facet by sex.
p + geom_point(aes(colour=sex)) + 
  coord_flip() + 
  facet_grid(. ~ sex)

# Plot statistical summary functions for each strain by sex. Add a title.
p + geom_point(aes(colour=sex)) + 
  coord_flip() + 
  facet_grid(. ~ sex) + 
  stat_summary(fun.y="mean", geom="point", colour="black") + 
  ggtitle("Mean Red Blood Cells by Strain and Sex")

# Create a new plot that sorts the strains by mean strain RBC value. 
# Title the axes and the plot, and shrink the y axis labels so that they don't overlap.
m <- ggplot(cc, aes(x=reorder(strain, RBC, FUN="mean", na.rm=TRUE), y=RBC)) + 
  geom_point(aes(colour=sex)) + 
  coord_flip() + 
  stat_summary(fun.y="mean", geom="point", colour="mediumpurple4") + 
  ggtitle("Mean Red Blood Cells by Strain and Sex") + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)") + 
  theme(axis.text.y = element_text(size=rel(0.7)))
m

################################################################
# Print plot to svg file.
################################################################

# Replace svg below with pdf for a PDF file, or png for a PNG file.

svg("strainMeans.svg", width=8, height=9)
print(m)
dev.off()

################################################################
# Subset the data to include strains with highest and lowest mean RBC
# and their progenitors or F1s.
################################################################

new.cc <- subset(cc, 
                 strain %in% c("ACASTF1","A/J", "CAST/EiJ", "NOD/ShiLtJ", "NODCASTF1", "NODAF1", "APWKF1", "PWK/PhJ")==TRUE)

# Plot data subset.
ggplot(new.cc, aes(x=reorder(strain, RBC, FUN="mean", na.rm=TRUE), y=RBC)) + 
  geom_point(aes(colour=sex)) + 
  coord_flip() + 
  stat_summary(fun.y="mean", geom="point", colour="mediumpurple4") + 
  ggtitle("Mean Red Blood Cells by Strain and Sex") + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)")

# View boxplots of subsetted data by sex.
ggplot(new.cc, aes(x=reorder(strain, RBC, FUN="mean", na.rm=TRUE), y=RBC)) + 
  geom_boxplot(aes(colour=sex)) + 
  coord_flip() + 
  ggtitle("Mean Red Blood Cells by Strain and Sex") + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)")

################################################################
# Strain means and standard error.
################################################################

# View strain means and standard error of the means (sem). First you must find the sem
# for each strain. Use the following function to do this. Code copied from Cookbook for R
# by Winston Chang, available free at www.cookbook-r.com.

summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
    require(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This does the summary. For each group's data frame, return a vector with
    # N, mean, and sd
    datac <- ddply(data, groupvars, .drop=.drop,
      .fun = function(xx, col) {
        c(N    = length2(xx[[col]], na.rm=na.rm),
          mean = mean   (xx[[col]], na.rm=na.rm),
          sd   = sd     (xx[[col]], na.rm=na.rm)
        )
      },
      measurevar
    )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean" = measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}

# Now that you've defined the function, apply it to the strains. You can obtain sem values by 
# sex and strain with groupvars=c("strain","sex").
strain.sem <- summarySE(cc, measurevar="RBC", groupvars="strain")
strain.sem 

# Plot the means and standard error of the means by strain.
ggplot(strain.sem, aes(x=reorder(strain, RBC, FUN="mean"), y=RBC)) + 
  geom_errorbar(aes(ymin=RBC-se, ymax=RBC+se), width=.1) + 
  geom_point() + 
  coord_flip() + 
  ggtitle("Mean Red Blood Cells by Strain") + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)") + 
  theme(axis.text.y = element_text(size=rel(0.7)))

# Subset the data by choosing the highest and lowest RBC values, and
# compare means to inbreds and F1s of these.
min(strain.sem$RBC, na.rm=TRUE)
max(strain.sem$RBC, na.rm=TRUE)
subset(strain.sem, RBC > 11 | RBC < 9)
new.sem <- subset(strain.sem, strain %in% c("ACASTF1","A/J", "CAST/EiJ", "NOD/ShiLtJ", "NODCASTF1", "NODAF1")==TRUE)

# Plot only these strains.
ggplot(new.sem, aes(x=reorder(strain, RBC, FUN="mean"), y=RBC)) + 
  geom_errorbar(aes(ymin=RBC-se, ymax=RBC+se), width=.1) + 
  geom_point() + 
  coord_flip() + 
  ggtitle("Mean Red Blood Cells by Strain") + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)") + 
  theme(axis.text.y = element_text(size=rel(0.7)))

# Another way to view mean phenotype values by strain and sex, courtesy of Gary Churchill.
# Calculate the mean of all phenotypes in the data by sex and strain. 
pheno.means <- ddply(cc, .(strain,sex), numcolwise(mean), na.rm=T)
pheno.means

heatplot <- ggplot(pheno.means, aes(sex,strain)) + 
  geom_tile(aes(fill=RBC),colour="white") + 
  scale_fill_gradient(low="white", high="steelblue") + 
  ggtitle("Mean Red Blood Cells by Sex and Strain") + 
  theme(axis.text.y = element_text(size=rel(0.7)))
heatplot

################################################################
# Print plot to svg file.
################################################################

# Output to svg.
svg("heatplot.svg", width=8, height=9)
print(heatplot)
dev.off()

################################################################
# Scatterplot one trait against another, or several traits 
# against each other.
################################################################

# Plot glucose against triglyceride and include a linear model. Color points by sex.
ggplot(data=cc, aes(x=GLU, y=TG)) + 
  geom_point(aes(colour=sex)) + 
  geom_smooth(method="lm")

# Also from Gary - some useful plotting functions. The following has nothing to do
# with ggplot, but produces gorgeous scatterplot matrices with histograms along
# the diagonal and trait correlation values in the upper triangle.
# see documentation for "pairs" function 
panel.cor <- function(x, y, digits=2, prefix="", cex.cor, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(0, 1, 0, 1))
    r <- cor(x, y, use="complete.obs")
    txt <- format(c(r, 0.123456789), digits=digits)[1]
    txt <- paste(prefix, txt, sep="")
    if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
    text(0.5, 0.5, txt, cex = cex.cor*0.5, col=c("gray60", "black")[(abs(r)>0.65)+1])
}
#
panel.hist <- function(x, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2],0,1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col="cyan", ...)
}


pairs(cc[,c("CHOL", "HDL", "GLU", "TG", "WBC", "RBC")],
	upper.panel=panel.cor,diag.panel=panel.hist)

