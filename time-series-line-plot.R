# This script recreates the Sequence Read Archive
# database growth plot shown at 
# http://www.ncbi.nlm.nih.gov/Traces/sra/
#
# Sue McClatchy 
# created 2015-06-14
# modified 2016-07-18 expanded code with step-by-step additions for each block

# Load the libraries. If you haven't installed the packages yet, you'll need
# to do so by selecting each from the Packages tab in RStudio, or by typing
# install.packages("ggplot2")
# and 
# install.packages("scales")

library(ggplot2)
library(scales)

# Read in the data from the Sequence Read Archive at NCBI.
sra <- read.csv("http://www.ncbi.nlm.nih.gov/Traces/sra/sra_stat.cgi")

# What is the structure of the data?
str(sra)

# How are the dates formatted?
class(sra$date)
head(sra$date)

# View dates in month/day/year format.
class(as.Date(sra$date, format="%m/%d/%Y"))
head(as.Date(sra$date, format="%m/%d/%Y"))

# Change date format to month/day/year format so that they display
# correctly on the x-axis.
sra$date <- as.Date(sra$date, format="%m/%d/%Y")
class(sra$date)
head(sra$date)
str(sra)

# Plot the number of bases by layering a line over the dates on the x-axis.
ggplot(data = sra, mapping = aes(x = date)) + 
  geom_line(aes(y = bases))

# Layer open access bases on top of the line representing bases.
ggplot(data = sra, mapping = aes(x = date)) + 
  geom_line(aes(y = bases)) + 
  geom_line(aes(y = open_access_bases))

# Change the line colors and sizes.
ggplot(data = sra, mapping = aes(x = date)) + 
  geom_line(aes(y = bases), colour = "blue", size = 1.5) + 
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5)

# The plot seems to show zero bases until the year 2010. 
# Check the smallest number of total bases and open access bases 
# in the data.
min(sra$bases)
min(sra$open_access_bases)

# Transform the y axis to a logarithm base 10 scale for accurate display.
ggplot(data = sra, aes(x = date)) +
  geom_line(aes(y = bases), colour = "blue", size = 1.5) + 
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5) +
  scale_y_log10()

# Manually define the y axis breaks.
ggplot(data = sra, aes(x = date)) +
  geom_line(aes(y = bases), colour = "blue", size = 1.5) +
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5) +
  scale_y_log10(breaks = c(1e+10, 1e+11, 1e+12, 1e+13, 1e+14, 1e+15))

# Supply simpler superscripted exponents on the y axis.
ggplot(data = sra, aes(x = date)) +
  geom_line(aes(y = bases), colour = "blue", size = 1.5) +
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5) +
  scale_y_log10(breaks = c(1e+10, 1e+11, 1e+12, 1e+13, 1e+14, 1e+15),
                labels = expression("10"^"10", "10"^"11", "10"^"12",
                                    "10"^"13", "10"^"14", "10"^"15"))

# How many data points are there in each year?
table(format(sra$date, "%Y"))

# Remove the single measurements in years 2000 and 2007.
which(format(sra$date, "%Y") %in% c("2000", "2007"))
sra <- sra[-(1:2),]
table(format(sra$date, "%Y"))
head(sra$date)

# Save the plot to a variable called logplot.
logplot <- ggplot(data = sra, aes(x = date)) +
  geom_line(aes(y = bases), colour = "blue", size = 1.5) +
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5) +
  scale_y_log10(breaks = c(1e+10, 1e+11, 1e+12, 1e+13, 1e+14, 1e+15),
                labels = expression("10"^"10", "10"^"11", "10"^"12",
                                    "10"^"13", "10"^"14", "10"^"15"))
logplot

# Specify the breaks in the x-axis so that each year is shown. Redefine logplot.
logplot <- logplot + scale_x_date(labels = date_format("%Y"), 
                       breaks = date_breaks("years"))
logplot

# Add text annotations to the plot. 
# Redefine logplot again to save the changes.
logplot <- logplot +
  annotate("text", x = sra$date[1255], y = 1.5e+15, 
           label = "total bases") +
  annotate("text", x = sra$date[1665], y = 1.5e+14, 
           label = "open access bases")
logplot

# Add axis labels. 
logplot <- logplot +
  xlab("Year") +
  ylab("Number of bases")
logplot

# Add a title.
logplot <- logplot +
  ggtitle("Sequence Read Archive Database Growth")
logplot

# Save the plot as a PDF using the pdf() command. You can also save as a 
# png(), jpeg(), tiff(), or bmp() using the corresponding command.
# The title goes inside the parentheses and is surrounded by double quotes.
# Be sure to turn the graphics device off afterward to return graphics output 
# to your plot window in RStudio.
# Use dev.off() to turn off the graphics device.
pdf("SRA-database-growth.pdf")
print(logplot)
dev.off()



