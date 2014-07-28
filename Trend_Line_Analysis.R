# Exascalar Data Trend Plot

# This program pulls in all the data and then plots a trend of the top, mean, and median exascalar.

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

## there are probably ways to simplify this code but this brute force method is easy to read.

Jun14 <- read.csv(paste0(results, "/Jun14.csv"), header=TRUE)
Nov13 <- read.csv(paste0(results, "/Nov13.csv"), header=TRUE)
Jun13 <- read.csv(paste0(results, "/Jun13.csv"), header=TRUE)
Nov12 <- read.csv(paste0(results, "/Nov12.csv"), header=TRUE)
Jun12 <- read.csv(paste0(results, "/Jun12.csv"), header=TRUE)
Nov11 <- read.csv(paste0(results, "/Nov11.csv"), header=TRUE)
Jun11 <- read.csv(paste0(results, "/Jun11.csv"), header=TRUE)
Nov10 <- read.csv(paste0(results, "/Nov10.csv"), header=TRUE)
Jun10 <- read.csv(paste0(results, "/Jun10.csv"), header=TRUE)
Nov09 <- read.csv(paste0(results, "/Nov09.csv"), header=TRUE)
Jun09 <- read.csv(paste0(results, "/Jun09.csv"), header=TRUE)
#Nov08 <- read.csv(paste0(results, "/green500_top_200811.csv"), header=TRUE)
#Jun08 <- read.csv(paste0(results, "/green500_top_200806.csv"), header=TRUE)

print("data read")

##PLOT MID, MEDIAN AND TOP EXASCALAR TREND


TopEx <- rbind(Jun09[1,], Nov09[1,], Jun10[1,], Nov10[1,], Jun11[1,], Nov11[1,], Jun12[1,], Nov12[1,], Jun13[1,], Nov13[1,], Jun14[1,])

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

DatesString<-c("06/01/2009", "11/01/2009","06/01/2010","11/01/2010","06/01/2011","11/01/2011",
               "06/01/2012",
               "11/01/2012","06/01/2013",
               "11/01/2013","06/01/2014")
Date <- as.Date(DatesString, "%m/%d/%Y")
topexascalar<-TopEx$exascalar
#TopExTrend<-as.data.frame(cbind(Date, exascalar))
#TopExTrend$Date <- format(TopExTrend$Date, format = "%B %d %Y")
##PlotMean over Exascalar Data
## EXASCALAR PLOT OVERLAYING TWO LISTS

## plots "reference" list first, then "list of current interest" is overlayed

require(ggplot2)
TopExData <- as.data.frame(cbind(Date, topexascalar))
TopExFit <- lm(topexascalar ~ Date , data = TopExData)

plot(Date, topexascalar,
      ylim=c(-7.0,0),
      xlim = c(14000, 19000),
      main = "",
        ylab = "Exascalar", 
      col = "red",
      bg = "steelblue2",
      pch=21)
##This is a median analysis which is not plotted currently
#par(new=TRUE)

#MedianEx$exascalar <- compute_exascalar(MedianEx)
#medexascalar <- as.numeric(MedianEx$exascalar)

#
#plot(Date, medexascalar,
#     ylim=c(-7.0,0),
#     xlim = c(14000, 19000),
#     xlab = "",
#     ylab = "", 
#     main = "Exascalar Trend",
#     col = "dark blue",
#     bg = "pink",
#     pch=20)

par(new=TRUE)
MeanEx$exascalar <- compute_exascalar(MeanEx)
meanexascalar <- as.numeric(MeanEx$exascalar)

MeanExData <- as.data.frame(cbind(Date, meanexascalar))
MeanExFit <- lm(meanexascalar ~ Date , data = MeanExData)

print("here here")
plot(Date, meanexascalar,
     ylim=c(-7.0,0),
     xlim = c(14000, 19000),
     xlab = "",
     ylab = "", 
     main = "Exascalar Trend",
     col = "dark blue",
     bg = "green",
     pch=19)

topslope<-TopExFit$coefficient[2]
topintercept<-TopExFit$coefficient[1]

## calculate date zero - when the top trend will intercet zero
datezero = -topintercept/topslope

lines(c(14000, datezero), c(topintercept+topslope*14000, topintercept+topslope*datezero))



meanslope<-MeanExFit$coefficient[2]
meanintercept<-MeanExFit$coefficient[1]
lines(c(14000, datezero), c(meanintercept+meanslope*14000, meanintercept+meanslope*datezero))

text(datezero, 0, as.Date(datezero, origin="1970-01-01"), cex=.5, srt=0, pos = 2)
text(datezero, -1, "Top", cex=.7, srt=0, pos = 2)
text(datezero, meanintercept+meanslope*datezero-1, "Mean", cex=.7, srt=0, pos = 2)

text(datezero,
     -7, "data from June14 Green500 and Top500                  ", cex=.4, col="black", pos=3)


## POWER AND PERFORMANCE TREND

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
meanpower<-MeanEx$rmax/MeanEx$mflopswatt
plot(Date, meanpower,
     ylim=c(200,20000),
     xlim = c(14000, 16500),
     log="y",
     xlab = "",
     ylab = "", 
     main = "Exascalar Trend",
     col = "dark blue",
     bg = "green",
     pch=19)

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
meaneff<-MeanEx$mflopswatt
plot(Date, meaneff,
     ylim=c(50,3000),
     xlim = c(14000, 16500),
     log="y",
     xlab = "",
     ylab = "", 
     main = "Exascalar Trend",
     col = "dark blue",
     bg = "green",
     pch=19)

