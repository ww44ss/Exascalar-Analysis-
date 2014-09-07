# Exascalar Data Trend Plot One

## This program imports cleaned data from the Green500 and Top500 lists
## It plots one set of data and the trend of the top and median exascalar overlayed

## GET THE CLEANED DATA

##check for Exascalar Directory. If none exists stop program with error

##check to ensure results director exists
if(!file.exists("./results")) stop("Data not found in directory Exascalar, first run Exascalar_Cleaner to get tidy data")

## set working directory


# define Data Directories to use
results <- "./results"

## ------------------------
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

##PLOT MODE, MEDIAN AND TOP EXASCALAR TREND

##Compute Mode Trend

TopEx <- rbind(Jun09[1,c(1:10)], Nov09[1,c(1:10)], Jun10[1,c(1:10)], Nov10[1,c(1:10)], Jun11[1,c(1:10)], Nov11[1,c(1:10)], Jun12[1,c(1:10)], Nov12[1,c(1:10)], 
               Jun13[1,c(1:10)], Nov13[1,c(1:10)], Jun14[1,c(1:10)])


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

print("meanEx")

##
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

print("medianEx")

##PlotMean over Exascalar Data
## EXASCALAR PLOT OVERLAYING TWO LISTS
dev.off()
## plots "reference" list first, then "list of current interest" is overlayed
png(filename= "ExascalarTrend.png", height=500, width=400)
plot(Jun14$mflopswatt ,
     Jun14$rmax*10^3, 
     log="xy", 
     asp = 4/3.2, 
     xlab = "",
     ylab = "", 
     main = "", 
     col = "red",
     bg = "steelblue2",
     pch=21, 
     xlim=c(10,100000), 
     ylim=c(1*10^7,2*10^12))
par(new=TRUE)
##This plots the "Mean" trend line of efficiency and performance
matplot(MedianEx$mflopswatt,
     MedianEx$rmax*10^3,
     type="l",
     lty=1,
     lwd=6,log="xy", 
     asp = 4/3.2, 
     xlab = "Efficiency (mflops/watt)",
     ylab = "Performance (mflops)", 
     main = "Exascalar", 
     pch=19, 
     cex = 0.6,
     col = "darkred",
     xlim=c(10,100000), 
     ylim=c(1*10^7,2*10^12)
     )
par(new=TRUE)
##plot the trend line of the "Top" exascalar system
matplot(TopEx$mflopswatt,
     TopEx$rmax*10^3, 
     type = "l",
     lty=1,
     lwd=6,
     log="xy", 
     asp = 4/3.2, 
     xlab = "",
     ylab = "", 
     main = "", 
     pch=19, 
     cex = 0.6,
     col = "dark green",
     xlim=c(10,100000), 
     ylim=c(1*10^7,2*10^12))

##label Plot Lines

text(TopEx$mflopswatt[10],
     TopEx$rmax[10]*10^3, "Top", cex=.8, col="dark green", pos=3)

text(MedianEx$mflopswatt[2],
     MedianEx$rmax[2]*10^3, "Median", cex=.8, col="dark red", pos=4)


text(1.0E4,
     1.1E7, "June 2014 ", cex=.8, col="black", pos=3)
text(1.0E4,
     0.7E7, "Green500 and Top500 Lists", cex=.8, col="black", pos=3)

##add text to plots  (Some are commented out to clean up appearance, but left in for possible later convenience)

##add text to plots  (Some are commented out to clean up appearance, but left in for possible later convenience)

#text(0.35e+05, 2e+12, expression(epsilon == 0), cex=.7, srt=-45)
text(0.35e+04, 1e+12, expression(epsilon == -1), cex=.9, srt=-45)
text(1.2e+02, 1e+12, expression(epsilon == -2), cex=.9, srt=-45)
text(0.2e+02, .25e+12, expression(epsilon == -3), cex=.9, srt=-45)
text(0.15e+02, 1.3e+10, expression(epsilon == -4), cex=.9, srt=-45)

text(0.15e+05, .5e+12, "20 MWatt", cex=.7, srt=45)
text(0.15e+05, .5e+10, "0.2 MWatt", cex=.7, srt=45)
#text(0.15e+05, .5e+08, "0.02 MWatt", cex=.7, srt=45)

## GENERATE CONSTANT POWER AND ISO-EXASCALAR LINES FOR THE GRAPH

## These are tbe hashed lines on the graph representing "constant power" and "constant exascalar"
## The approach here is to define functions that create two endpoints for the line segments that 
##    depend on power and exascalar, respectively

isopowerline <- function(megawatts, efficiencyrangelow=10*.9, efficiencyrangehigh=100000*1.1, perfrangehigh = 2*10^12*1.1, perfrangelow = 0.9**5*10^6)
{matrix(c(efficiencyrangelow, efficiencyrangehigh, efficiencyrangelow*megawatts*10^6, efficiencyrangehigh*megawatts*10^6), ncol=2)
}

## Compute Graphical Lines for iso power
## the argument passed in isopowerline is in megawatts

for (i in -2:4) {
        lines(isopowerline(2*10^-i)[,1],isopowerline(2*10^-i)[,2], lwd=.5, lty=2)}

## add graphical lines for iso "exscalar"


ExaPerf <- 10^12           ##in Megaflops
ExaEff <- 10^12/(20*10^6)  ##in Megaflops/Watt

Exascale = ExaPerf*ExaEff

isoexaline <- function(exascalar, efficiencyrangelow=0.5*20, efficiencyrangehigh=2*50000, perfrangehigh = 2*10^12, perfrangelow = 0.5*5*10^7){
        matrix(c(Exascale/(10^(-exascalar*sqrt(2)))/perfrangehigh, efficiencyrangehigh, perfrangehigh, Exascale/(10^(-exascalar*sqrt(2)))/efficiencyrangehigh), ncol=2)
}

## Compute Graphical Lines for iso exascalar
## the argument passed is - log10 of exascalar

for (i in 0:7) {lines(isoexaline(-i)[,1], isoexaline(-i)[,2], lwd=.5, lty=2)}

dev.off()
