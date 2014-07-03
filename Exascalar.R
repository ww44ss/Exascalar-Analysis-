##Exascalar Plotting

## Get the data

##check for Exascalar Directory. If none exists send error
if(!file.exists("./Exascalar")){stop("it appears the data is not present")}
##past in the link for the .csv file of interest
fileUrl <- ""

setwd("~/Documents/Exascalar")

# Data Directories to use
green500data <- "./green500data"
top500data <- "./top500data"
results <- "./results"

## ------------------------
## Read and Clean Green500

# import data set

## there are probably ways to simplify this code but this brute force method is easy to read.

GreenNov13 <- read.csv(paste0(green500data, "/green500_top_201311.csv"), header=TRUE)
GreenJun13 <- read.csv(paste0(green500data, "/green500_top_201306.csv"), header=TRUE)
GreenNov12 <- read.csv(paste0(green500data, "/green500_top_201211.csv"), header=TRUE)
GreenJun12 <- read.csv(paste0(green500data, "/green500_top_201206.csv"), header=TRUE)
GreenNov11 <- read.csv(paste0(green500data, "/green500_top_201111.csv"), header=TRUE)
GreenJun11 <- read.csv(paste0(green500data, "/green500_top_201106.csv"), header=TRUE)
GreenNov10 <- read.csv(paste0(green500data, "/green500_top_201011.csv"), header=TRUE)
GreenJun10 <- read.csv(paste0(green500data, "/green500_top_201006.csv"), header=TRUE)
GreenNov09 <- read.csv(paste0(green500data, "/green500_top_200911.csv"), header=TRUE)
GreenJun09 <- read.csv(paste0(green500data, "/green500_top_200906.csv"), header=TRUE)
GreenNov08 <- read.csv(paste0(green500data, "/green500_top_200811.csv"), header=TRUE)
GreenJun08 <- read.csv(paste0(green500data, "/green500_top_200806.csv"), header=TRUE)


## ---------------------
## clean names function
## as new lists are created may need to add cleaning functions to this list.
## this cleans everything up to Jun14. 

cleanupnames <- function(xlist){
        xlist <-tolower(          xlist)
        xlist <-gsub("_", "",     xlist)
        xlist <-sub("per", "",    xlist)
        xlist <-gsub("[.]","",      xlist)
}

## clean names

names(GreenNov13)<-cleanupnames(names(GreenNov13))
names(GreenJun13)<-cleanupnames(names(GreenJun13))
names(GreenNov12)<-cleanupnames(names(GreenNov12))
names(GreenJun12)<-cleanupnames(names(GreenJun12))
names(GreenNov11)<-cleanupnames(names(GreenNov11))
names(GreenJun11)<-cleanupnames(names(GreenJun11))
names(GreenNov10)<-cleanupnames(names(GreenNov10))
names(GreenJun10)<-cleanupnames(names(GreenJun10))
names(GreenNov09)<-cleanupnames(names(GreenNov09))
names(GreenJun09)<-cleanupnames(names(GreenJun09))

## ---------------------
## Read and Clean Top500 

TopJun14 <- read.csv(paste0(top500data, "/TOP500_201406.csv"), header=TRUE)
TopNov13 <- read.csv(paste0(top500data, "/TOP500_201311.csv"), header=TRUE)
TopJun13 <- read.csv(paste0(top500data, "/TOP500_201306.csv"), header=TRUE)
TopNov12 <- read.csv(paste0(top500data, "/TOP500_201211.csv"), header=TRUE)


names(TopJun14)<-cleanupnames(names(TopJun14))
names(TopNov13)<-cleanupnames(names(TopNov13))
names(TopJun13)<-cleanupnames(names(TopJun13))
names(TopNov12)<-cleanupnames(names(TopNov12))
#names(GreenJun12)<-cleanupnames(names(GreenJun12))
#names(GreenNov11)<-cleanupnames(names(GreenNov11))
#names(GreenJun11)<-cleanupnames(names(GreenJun11))
#names(GreenNov10)<-cleanupnames(names(GreenNov10))
#names(GreenJun10)<-cleanupnames(names(GreenJun10))
#names(GreenNov09)<-cleanupnames(names(GreenNov09))
#names(GreenJun09)<-cleanupnames(names(GreenJun09))

## ---------------------
## Exascalar Analysis
## SECTION 1 Plots two (current and baseline) exascalar lists
ExaPerf <- 10^12           ##in Megaflops
ExaEff <- 10^12/(20*10^6)  ##in Megaflops/Watt


ExaNov13 <- sqrt(log10(GreenNov13$Rmax/ExaPerf)^2 *(GreenNov13$Mflops.Watt/(ExaEff))^2)
ExaNov12 <- sqrt(log10(GreenNov12$Rmax/ExaPerf)^2 *(GreenNov12$Mflops.Watt/(ExaEff))^2)
ExaNov12 <- sqrt(log10(GreenNov12$Rmax/ExaPerf)^2 *(GreenNov12$Mflops.Watt/(ExaEff))^2)
##----------------------
##Exascalar Plot overlaying two lists


plot(GreenJun13$mflopswatt ,
     GreenJun13$rmax*10^3, 
     log="xy", 
     asp = 4/3.2, 
     xlab = "",
     ylab = "", 
     main = "", 
     col = "blue",
     pch=1, 
     xlim=c(10,100000), 
     ylim=c(5*10^7,2*10^12))
par(new=TRUE)
plot(GreenNov13$mflopswatt,
     GreenNov13$rmax*10^3, 
     log="xy", 
     asp = 4/3.2,
     xlab = "efficiency (mflops/watt)",
     ylab = "rmax (mflops)", 
     main = "Exascalar", 
     pch=19, 
     cex = 0.6,
     col = "red",
     xlim=c(10,100000), 
     ylim=c(5*10^7,2*10^12))

##add text
#text(0.35e+05, 2e+12, expression(epsilon == 0), cex=.7, srt=-45)
#text(0.35e+04, 2e+12, expression(epsilon == -1), cex=.7, srt=-45)
text(0.7e+03, 1e+12, expression(epsilon == -2), cex=.7, srt=-45)
#text(0.35e+02, 2e+12, expression(epsilon == -3), cex=.7, srt=-45)
text(0.3e+02, .25e+12, expression(epsilon == -4), cex=.7, srt=-45)
#text(0.3e+02, .25e+11, expression(epsilon == -5), cex=.7, srt=-45)
text(0.15e+02, .5e+10, expression(epsilon == -6), cex=.7, srt=-45)

text(0.15e+05, .5e+12, "20 MWatt", cex=.7, srt=45)
text(0.15e+05, .5e+10, "0.2 MWatt", cex=.7, srt=45)
#text(0.15e+05, .5e+08, "0.02 MWatt", cex=.7, srt=45)

##Generate Constant power and exascalar curves for the graph

isopowerline <- function(megawatts, efficiencyrangelow=10*.9, efficiencyrangehigh=100000*1.1, perfrangehigh = 2*10^12*1.1, perfrangelow = 0.9**5*10^6)
        {matrix(c(efficiencyrangelow, efficiencyrangehigh, efficiencyrangelow*megawatts*10^6, efficiencyrangehigh*megawatts*10^6), ncol=2)
        }

## Add Graphical Lines for iso power
## the argument passed in isopowerline is in megawatts
for (i in -2:4) {
lines(isopowerline(2*10^-i)[,1],isopowerline(2*10^-i)[,2], lwd=.5, lty=2)}

## add graphical lines for iso "exscalar"

Exascale = ExaPerf*ExaEff

isoexaline <- function(exascalar, efficiencyrangelow=0.5*20, efficiencyrangehigh=2*50000, perfrangehigh = 2*10^12, perfrangelow = 0.5*5*10^7){
        matrix(c(Exascale/(10^-exascalar)/perfrangehigh, efficiencyrangehigh, perfrangehigh, Exascale/(10^-exascalar)/efficiencyrangehigh), ncol=2)
}

for (i in 0:7) {lines(isoexaline(-i)[,1], isoexaline(-i)[,2], lwd=.5, lty=2)}



