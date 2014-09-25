# Exascalar Data Trend Plot

# This program pulls in all the data and then plots a trend of the top, mean, and median exascalar.
# plan to update to pull big exascalar file

## This program imports cleaned data from the Green500 and Top500 lists


## GET THE CLEANED DATA

##check for Exascalar Directory. If none exists stop program with error

##check to ensure results director exists
if(!file.exists("./results")) stop("Data not found in directory Exascalar, first run Exascalar_Cleaner to get tidy data")

## set working directory


# define Data Directories to use
results <- "./results"

## ------------------------


ExaPerf <- 10^12           ##in Megaflops
ExaEff <- 10^12/(20*10^6)  ##in Megaflops/Watt

## this function coputes Exascalar from a list with columns labeled $rmax and $megaflopswatt
## note the function computes to three digits explicitly

compute_exascalar <- function(xlist){
        ## compute exascalar
        t1 <- (log10(xlist$rmax*10^3/ExaPerf) + log10(xlist$mflopswatt/(ExaEff)))/sqrt(2)
        ## round to three digits
        t2 <- round(t1, 3) 
        ## clean up
        format(t2, nsmall=3)
}

## Read results files

# import data set

BigExascalar <- read.csv(paste0(results, "/BigExascalar.csv"), header=TRUE)
print("data read")



## create datamatrix table to select as function of date various stats.
datematrix<-as.data.frame(table(BigExascalar$date))

##PLOT MID, MEDIAN AND TOP EXASCALAR TREND

##the way this works is for each date first take the subest of BigExascalar and then find the max value.
TopEx <- NULL

for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$exascalar == max(xx$exascalar))
        TopEx<-rbind(TopEx, xrow)
}
    

MeanEx <- NULL

for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$exascalar == mean(xx$exascalar))
        MeanEx<-rbind(MeanEx, xrow)
}
    


MedianPerf <- NULL

for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$rmax == median(xx$rmax))
        MedianPerf<-rbind(MedianPerf, xrow)
}

Median <- NULL

for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$rmax == median(xx$rmax))
        MedianPerf<-rbind(MedianPerf, xrow)
}

##mean efficiency function calculated the mean perforance adn power and then the mean efficiency from that ratio
##thus defined it reflects the popultion of the Top500 computers. 

mean_eff <- function(list){mean(list$rmax)/mean(list$power)}

MeanEx <- matrix(c(mean_eff(Jun09), mean_eff(Nov09),
                   mean_eff(Jun10), mean_eff(Nov10),
                   mean_eff(Jun11), mean_eff(Nov11),
                   mean_eff(Jun12), mean_eff(Nov12),
                   mean_eff(Jun13), mean_eff(Nov13),
                   mean_eff(Jun14),
                   mean(Jun09$rmax), mean(Nov09$rmax),
                   mean(Jun10$rmax), mean(Nov10$rmax),
                   mean(Jun11$rmax), mean(Nov11$rmax),
                   mean(Jun12$rmax), mean(Nov12$rmax),
                   mean(Jun13$rmax), mean(Nov13$rmax), 
                   mean(Jun14$rmax)),
                 ncol=2, nrow = 11)
MeanEx <- as.data.frame(MeanEx)
names(MeanEx) <- c("mflopswatt", "rmax")

median_eff <- function(list){median(list$rmax)/median(list$power)}

MedianEx <- matrix(c(median_eff(Jun09), median_eff(Nov09),
                     median_eff(Jun10), median_eff(Nov10),
                     median_eff(Jun11), median_eff(Nov11),
                     median_eff(Jun12), median_eff(Nov12),
                     median_eff(Jun13), median_eff(Nov13),
                     median_eff(Jun14),
                     median(Jun09$rmax), median(Nov09$rmax),
                     median(Jun10$rmax), median(Nov10$rmax),
                     median(Jun11$rmax), median(Nov11$rmax),
                     median(Jun12$rmax), median(Nov12$rmax),
                     median(Jun13$rmax), median(Nov13$rmax), 
                     median(Jun14$rmax)),
                   ncol=2, nrow = 11)
MedianEx <- as.data.frame(MedianEx)
names(MedianEx) <- c("mflopswatt", "rmax")

bottom_eff <- function(list){list$rmax[which(list$X == max(list$X))]/list$power[which(list$X == max(list$X))]}
bottom_perf <- function(list){list$rmax[which(list$X == max(list$X))]}

BottomGreen <- matrix(c(bottom_eff(Jun09), bottom_eff(Nov09),
                        bottom_eff(Jun10), bottom_eff(Nov10),
                        bottom_eff(Jun11), bottom_eff(Nov11),
                        bottom_eff(Jun12), bottom_eff(Nov12),
                        bottom_eff(Jun13), bottom_eff(Nov13),
                        bottom_eff(Jun14),
                        bottom_perf(Jun09), bottom_perf(Nov09),
                        bottom_perf(Jun10), bottom_perf(Nov10),
                        bottom_perf(Jun11), bottom_perf(Nov11),
                        bottom_perf(Jun12), bottom_perf(Nov12),
                        bottom_perf(Jun13), bottom_perf(Nov13), 
                        bottom_perf(Jun14)),
                      ncol=2, nrow = 11)

BottomGreen <- as.data.frame(MedianEx)
names(BottomGreen) <- c("mflopswatt", "rmax")

top_eff <- function(list){list$rmax[which(list$green500rank == 1)[1]]/list$power[which(list$green500rank == 1)[1]]}
top_perf <- function(list){list$rmax[which(list$green500rank == 1)[1]]}

TopGreen <- matrix(c(top_eff(Jun09), top_eff(Nov09),
                     top_eff(Jun10), top_eff(Nov10),
                     top_eff(Jun11), top_eff(Nov11),
                     top_eff(Jun12), top_eff(Nov12),
                     top_eff(Jun13), top_eff(Nov13),
                     top_eff(Jun14),
                     top_perf(Jun09), top_perf(Nov09),
                     top_perf(Jun10), top_perf(Nov10),
                     top_perf(Jun11), top_perf(Nov11),
                     top_perf(Jun12), top_perf(Nov12),
                     top_perf(Jun13), top_perf(Nov13), 
                     top_perf(Jun14)),
                   ncol=2, nrow = 11)

TopGreen <- as.data.frame(TopGreen)
names(TopGreen) <- c("mflopswatt", "rmax")

DatesString<-c("06/01/2009", "11/01/2009","06/01/2010","11/01/2010","06/01/2011","11/01/2011",
               "06/01/2012",
               "11/01/2012","06/01/2013",
               "11/01/2013","06/01/2014")
Date <- as.Date(DatesString, "%m/%d/%Y")


## EXASCALAR TREND

## Plot of the Top and Median Exascalar for current cleaned data set


require(ggplot2)
## create TopEx vector
topexascalar<-TopEx$exascalar
## create TopEX data frame for fitting
TopExData <- as.data.frame(cbind(Date, topexascalar))
## fitted model of Top Exascalar data
TopExFit <- lm(topexascalar ~ Date , data = TopExData)
## plot the data
plot(Date, topexascalar,
     ylim=c(-7.0,0),
     xlim = c(14000, 19000),
     main = "",
     ylab = "Exascalar", 
     col = "red",
     bg = "steelblue2",
     pch=21)


par(new=TRUE)
print('median')
## create median vector for plotting
MedianEx$exascalar <- compute_exascalar(MedianEx)
medianexascalar <- as.numeric(MedianEx$exascalar)
## createe median data fram for fitting
MedianExData <- as.data.frame(cbind(Date, medianexascalar))
##fitted model of median data 
MedianExFit <- lm(medianexascalar ~ Date , data = MedianExData)


plot(Date, medianexascalar,
     ylim=c(-7.0,0),
     xlim = c(14000, 19000),
     xlab = "",
     ylab = "", 
     main = "Exascalar Trend",
     col = "dark blue",
     bg = "green",
     pch=19)

## get parameters for fitted lines

topslope<-TopExFit$coefficient[2]
topintercept<-TopExFit$coefficient[1]

## calculate date zero - when the top trend will intercet zero exascalar
## the zero date is an important figure of merit of the population (zero exascalar) 
##  representing the most advanced supercomputing capability

datezero = -topintercept/topslope
##draw lines
lines(c(14000, datezero), c(topintercept+topslope*14000, topintercept+topslope*datezero))


medianslope<-MedianExFit$coefficient[2]
medianintercept<-MedianExFit$coefficient[1]
## draw fitted line for median
lines(c(14000, datezero), c(medianintercept+medianslope*14000, medianintercept+medianslope*datezero))
## add text to graph
text(datezero, 0, as.Date(datezero, origin="1970-01-01"), cex=.5, srt=0, pos = 2)
text(datezero, -1.2, "Top", cex=.7, srt=0, pos = 2)
text(datezero, medianintercept+medianslope*datezero-1.2, "Median", cex=.7, srt=0, pos = 2)

text(datezero-100,
     -7, "data from June14 Green500 and Top500                     ", cex=.4, col="black", pos=3)

TopEx<-cbind(TopEx, Date)

## POWER TREND PLOT

powerplot <- ggplot(TopEx, aes(x = Date, y = power)) + geom_point() + coord_trans(y="log10")
## get rid of grid lines
powerplot <- powerplot + theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank())
## add performance ski
powerplot<-powerplot+ geom_point(aes(alpha = rmax))
png(filename=paste0(d, "/ExaPowerTrend.png"))
##print(aaaaaa)
dev.off()


par(new=FALSE)
toppower<-TopEx$power
plot(Date, toppower,
     ylim=c(200,20000),
     xlim = c(14000, 16500),
     main = "",
     log="y",
     ylab = "Power (kW)", 
     col = "red",
     bg = "steelblue2",
     pch=21)
par(new=TRUE)
medianpower<-MedianEx$rmax/MeanEx$mflopswatt
plot(Date, medianpower,
     ylim=c(200,20000),
     xlim = c(14000, 16500),
     log="y",
     xlab = "",
     ylab = "", 
     main = "Power Trend",
     col = "dark blue",
     bg = "green",
     pch=19)


text(Date[5], toppower[5], "Top Power", cex=.7, srt=0, pos = 2)
text(Date[5], medianpower[5], "Median Power", cex=.7, srt=0, pos = 2)

text(16222,
     300, "data from June14 Green500 and Top500                     ", cex=.4, col="black", pos=3)



topeff<-TopEx$mflopswatt
plot(Date, topeff,
     ylim=c(50,3000),
     xlim = c(14000, 16500),
     log="y",
     main = "",
     ylab = "efficiency (mflops per Watt)", 
     col = "red",
     bg = "steelblue2",
     pch=21)
par(new=TRUE)
medianeff<-MedianEx$mflopswatt
plot(Date, medianeff,
     ylim=c(50,3000),
     xlim = c(14000, 16500),
     log="y",
     xlab = "",
     ylab = "", 
     main = "Efficiency Trend",
     col = "dark blue",
     bg = "green",
     pch=19)

