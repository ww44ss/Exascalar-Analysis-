## POWERGAP2

## Power and Performance Gaps for the most efficient and least advanced (lowest exascalar) Top/Green500 computers

## This program imports the BigExascalar cleaned data set
## it creates two data plots which compare the power and performance of the most efficient adn least advanced computers
## as a function of year 
## and stores the results as the files PerformanceCompare.png adn PowerCompare.png

## this currently uses the base plot routine


## GET THE CLEANED DATA

##check for Exascalar Directory. If none exists stop program with error

##check to ensure results director exists
if(!file.exists("./results")) stop("Data not found in directory Exascalar, first run Exascalar_Cleaner to get tidy data")

## set working directory
# define Data Directories to use
results <- "./results"

require(ggplot2)

## ------------------------
## Read results files

BigExascalar <- read.csv(paste0(results, "/BigExascalar.csv"), header=TRUE)
print("data read")

##CREATE DATA SUBSETS
## ----------------

## create low power table 
## table with lowest power system for each year

datematrix<-as.data.frame(table(BigExascalar$date))

lowpowertable=NULL
for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$power == min(xx$power))
        lowpowertable<-rbind(lowpowertable, xrow)
}

## create low Exascalar table 
## table with lowest Exascalar for each year


lowexatable=NULL
for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$exascalar == min(xx$exascalar))
        lowexatable<-rbind(lowexatable, xrow)
}

## create high Exascalar table 
## table with highest Exascalar for each year

highexatable=NULL
for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$exascalar == max(xx$exascalar))
        highexatable<-rbind(highexatable, xrow)
}

## CREATE PLOTS
## ----------

## power plot

png(filename="PowerCompare.png")

par(new=FALSE)
plot(as.Date(lowexatable$date, origin="1970-01-01"), lowexatable$power,
     ylim=c(20,20000),
     xlim = c(14000, 16500),
     main = "Power (kW)",
     log="y",
     ylab = "Power Comparison (kW)", 
     xlab = "Date",
     col = "red",
     bg = "steelblue2",
     pch=21)
par(new=TRUE)
plot(as.Date(lowpowertable$date, origin="1970-01-01"), lowpowertable$power,
     ylim=c(20,20000),
     xlim = c(14000, 16500),
     main = "",
     log="y",
     ylab = "", 
     xlab = "",
     col = "blue",
     bg = "red",
     pch=22)

## add a legend to the plot
legend("topleft", c("Lowest Exascalar","Lowest Power"), col=c("red", "blue"), pt.bg=c("steelblue2", "red"), pch=21:22, cex=0.8)

dev.off()


## rmax plot

png(filename="PerformanceCompare.png")

par(new=FALSE)
plot(as.Date(lowexatable$date, origin="1970-01-01"), lowexatable$rmax,
     ylim=c(10^3,10^8),
     xlim = c(14000, 16500),
     main = "Performance Comparison (Mflops)",
     log="y",
     ylab = "rmax (Mflops)", 
     xlab = "Date",
     col = "red",
     bg = "steelblue2",
     pch=21)
par(new=TRUE)
plot(as.Date(lowpowertable$date, origin="1970-01-01"), lowpowertable$rmax,
     ylim=c(10^3,10^8),
     xlim = c(14000, 16500),
     main = "",
     log="y",
     ylab = "", 
     xlab = "",
     col = "blue",
     bg = "red",
     pch=22)

## add a legend to the plot
legend("topleft", c("Lowest Exascalar","Lowest Power"), col=c("red", "blue"), pt.bg=c("steelblue2", "red"), pch=21:22, cex=0.8)



dev.off()