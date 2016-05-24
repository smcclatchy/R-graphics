# This script recreates the Sequence Read Archive
# database growth plot shown at 
# http://www.ncbi.nlm.nih.gov/Traces/sra/
# Sue McClatchy 
# created 2015-06-14
# modified 2015-10-26 added header

library(ggplot2)
library(scales)

sra <- read.csv("http://www.ncbi.nlm.nih.gov/Traces/sra/sra_stat.cgi")
str(sra)
class(sra$date)
head(sra$date)
class(as.Date(sra$date, format="%m/%d/%Y"))
head(as.Date(sra$date, format="%m/%d/%Y"))

sra$date <- as.Date(sra$date, format="%m/%d/%Y")
class(sra$date)
head(sra$date)
str(sra)

ggplot(sra, aes(date)) +
  geom_line(aes(y = bases)) +
  geom_line(aes(y = open_access_bases)) +
  scale_y_log10()

ggplot(sra, aes(date)) +
  geom_line(aes(y = bases), colour = "blue", size = 1.5) +
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5)

min(sra$bases)
min(sra$open_access_bases)

ggplot(sra, aes(date)) +
  geom_line(aes(y = bases), colour = "blue", size = 1.5) +
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5) +
  scale_y_log10(breaks = c(1e+10, 1e+11, 1e+12, 1e+13, 1e+14, 1e+15),
                labels = expression("10"^"10", "10"^"11", "10"^"12",
                                    "10"^"13", "10"^"14", "10"^"15"))

table(format(sra$date, "%Y"))
which(format(sra$date, "%Y") == c("2000", "2007"))

sra <- sra[-(1:2),]
head(sra$date)

logplot <- ggplot(sra, aes(date)) +
  geom_line(aes(y = bases), colour = "blue", size = 1.5) +
  geom_line(aes(y = open_access_bases), colour = "yellow", size = 1.5) +
  scale_y_log10(breaks = c(1e+10, 1e+11, 1e+12, 1e+13, 1e+14, 1e+15),
                labels = expression("10"^"10", "10"^"11", "10"^"12",
                                    "10"^"13", "10"^"14", "10"^"15"))
logplot

logplot + scale_x_date(labels = date_format("%Y"), 
                       breaks = date_breaks("years"))

logplot <- logplot + scale_x_date(labels = date_format("%Y"), 
                       breaks = date_breaks("years")) +
  annotate("text", x = sra$date[1255], y = 1.5e+15, 
           label = "total bases") +
  annotate("text", x = sra$date[1665], y = 1.5e+14, 
           label = "open access bases") +
  xlab("Year") +
  ylab("Number of bases") + 
  theme(axis.title.x = element_text(vjust= -.5)) +
  ggtitle("Sequence Read Archive Database Growth")
  
pdf("SRA-database-growth.pdf")
print(logplot)
dev.off()



