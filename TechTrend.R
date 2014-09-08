## TECHTREND.R
## Technology Trend Plot

## Tech Trend search string is defined below (TechTrendSearchString)
## the output is TechTrend_"TechTrendSearchString".png
## the search is not case sensitive

# This program reads the BigExascalar data set
## it computes the trend of the Top Exascalar
## and then parses the "computer name" to create another data set 

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



## Create Technology Trend\
## this section just searches for code names inside the computer name and creates a table of values based on that
## note that the search is not case sensitive

        TechTrendSearchString = "Infiniband"
        ## use grepl to search for substring
        bbb <- grepl(TechTrendSearchString, BigExascalar$computer, ignore.case=TRUE)
        ## get the locations
        ccc <- which(bbb ==TRUE)
        ## subset Big Exascalar
        TechTrend <- BigExascalar[ccc,]
print("number of points =")
print(length(ccc))

## CREATE PLOTS
## ----------
png(filename=paste0("TechTrend_Power_",TechTrendSearchString,".png"))

par(new=FALSE)
plot(as.Date(highexatable$date, origin="1970-01-01"), highexatable$power,
     ylim=c(20,20000),
     xlim = c(14000, 16500),
     main = "Power (kW)",
     type="o",
     log="y",
     ylab = "Power Comparison (kW)", 
     xlab = "Date",
     col = "red",
     bg = "steelblue2",
     pch=21)
par(new=TRUE)
plot(as.Date(TechTrend$date, origin="1970-01-01"), TechTrend$power,
     ylim=c(20,20000),
     xlim = c(14000, 16500),
     main = "",
     log="y",
     ylab = "", 
     xlab ="",
     col = "blue",
     bg = "red",
     pch=22)
legend("topleft", c("TopExascalar",TechTrendSearchString), col=c("red", "blue"), pt.bg=c("steelblue2", "red"), pch=21:22, cex=0.8)

dev.off()
## rmax plot

png(filename=paste0("TechTrend_Perf_",TechTrendSearchString,".png"))

par(new=FALSE)
plot(as.Date(highexatable$date, origin="1970-01-01"), highexatable$rmax,
     ylim=c(10^3,10^8),
     xlim = c(14000, 16500),
     main = "Performance Comparison (Mflops)",
     log="y",
     type="o",
     ylab = "rmax (Mflops)", 
     xlab = "Date",
     col = "red",
     bg = "steelblue2",
     pch=21)
par(new=TRUE)
plot(as.Date(TechTrend$date, origin="1970-01-01"), TechTrend$rmax,
     ylim=c(10^3,10^8),
     xlim = c(14000, 16500),
     main = "",
     log="y",
     ylab = "", 
     xlab = "",
     col = "blue",
     bg = "red",
     pch=22)
#plot(ylim=c(10^3,10^8),
#     xlim = c(14000, 16500),
#    main = "",
#   log="y",
#  ylab = "", 
# xlab = "",
legend("topleft", c("Highest Exascalar",TechTrendSearchString), col=c("red", "blue"), pt.bg=c("steelblue2", "red"), pch=21:22, cex=0.8)



dev.off()