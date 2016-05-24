# View RNA read counts for a gene.
# Sue McClatchy
# created 2014-10-15
# modified 2015-06-22

# Kidney Renal Clear Cell Carcinoma [KIRC] RNA-Seq data
# A list of RNA-seq data from The Cancer Genome Atlas, subsetted down to 1000 genes and 
# 69 paired columns of data. Provides a matrix of paired data with rows corresponding to 
# genes and columns corresponding to replicates; replic vector specifies replicates and 
# treatment vector specifies non-tumor and tumor group samples respectively within replicate.

# Format
# counts: matrix of RNA-seq data for 1000 sampled genes and 69 paired columns from 
# individuals with Kidney Renal Clear Cell Carcinoma.
# replic: vector detailing which column in counts matrix belongs to each individual.
# treatment: vector detailing whether each column in counts matrix is a non-tumor or tumor sample

source("http://bioconductor.org/biocLite.R")
biocLite("edgeR")
library(ggplot2)
library(SimSeq)
data(kidney)


# View data points (RNA read counts) for gene in row 32.
qplot(kidney$treatment, kidney$counts[32,])

# View a histogram of gene 32 read counts across all samples.
hist(kidney$counts[32,])

# Create a boxplot.
q <- qplot(kidney$treatment, kidney$counts[32,], geom="boxplot")
q

# Add mean to boxplot as a diamond filled with white.
q + stat_summary(fun.y="mean", geom="point", shape=23, size=3, fill="white")

# Add axis labels and plot title.
q + stat_summary(fun.y="mean", geom="point", shape=23, size=3, fill="white") + 
  labs(title="Gene 32 Read Count in Tumor and Non-tumor Samples", x= "treatment", y="read count")

##################################################
# CC strain survey boxplots
##################################################

# Create boxplots from the subsetted CC strain survey data. Order boxplots by strain means.
s <- ggplot(new.cc, aes(x=reorder(strain, RBC, FUN="mean", na.rm=TRUE), y=RBC)) 
s + geom_boxplot(aes(colour=sex)) 

# Add a title, rotate the x-axis labels so that they're not crowded, and label both axes.
# Facet by sex.
s + geom_boxplot(aes(colour=sex)) + 
  ggtitle("Red Blood Cells by Strain and Sex") + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)") + 
  theme(axis.text.x = element_text(angle=30, size=rel(0.9), vjust=.75)) + 
  facet_grid(.~sex)

# Reassign the entire plot to s.
s <- ggplot(new.cc, aes(x=reorder(strain, RBC, FUN="mean", na.rm=TRUE), y=RBC)) + 
  geom_boxplot(aes(colour=sex)) + 
  ggtitle("Red Blood Cells by Strain and Sex") + 
  xlab("strain") + 
  ylab("red blood cell count (n/uL)") + 
  theme(axis.text.x = element_text(angle=30, size=rel(0.9), vjust=.75)) + 
  facet_grid(.~sex)
s

################################################################
# Print plot to svg file.
################################################################

# Output the plot in SVG format for further editing with Adobe Illustrator, Inkscape, or 
# other software as needed. Or, replace svg below with pdf for a PDF file, or png for a PNG file.

svg("boxplots.svg", width=8, height=9)
print(s)
dev.off()
