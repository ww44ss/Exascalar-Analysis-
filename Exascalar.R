## Exascalar Plot

## This program reads in the Top500 adn Green500 files and labels them with clear easy to remember filenames.
## it "cleans" the column names (for later use)
## it plots two of the data sets overlayed onto a standard "Exascalar" Graph

## All programs in this Exascalar GitHub assume this program has been run first to create the files they need to compute.


## GET THE DATA

##check for Exascalar Directory. If none exists stop program with error

  if(!file.exists("./Exascalar")) stop("Data not found")

## set working directory

  setwd("~/Documents/Exascalar")

# define Data Directories to use

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
## create clean up names function

## as new lists are created may need to add cleaning functions to this list.
## this cleans everything up to Jun14 well enough to enable most functionality for analysis

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
## COMPUTE EXASCALAR  (this is not used in the program)
## SECTION 1 Plots two (current and baseline) exascalar lists
ExaPerf <- 10^12           ##in Megaflops
ExaEff <- 10^12/(20*10^6)  ##in Megaflops/Watt


ExaNov13 <- sqrt(log10(GreenNov13$Rmax/ExaPerf)^2 *(GreenNov13$Mflops.Watt/(ExaEff))^2)
ExaNov12 <- sqrt(log10(GreenNov12$Rmax/ExaPerf)^2 *(GreenNov12$Mflops.Watt/(ExaEff))^2)
ExaNov12 <- sqrt(log10(GreenNov12$Rmax/ExaPerf)^2 *(GreenNov12$Mflops.Watt/(ExaEff))^2)


##----------------------
## EXASCALAR PLOT OVERLAYING TWO LISTS

## plots "reference" list first, then "list of current interest" is overlayed

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

##add text to plots  (Some are commented out to clean up appearance, but left in for possible later convenience)

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

  Exascale = ExaPerf*ExaEff

  isoexaline <- function(exascalar, efficiencyrangelow=0.5*20, efficiencyrangehigh=2*50000, perfrangehigh = 2*10^12, perfrangelow = 0.5*5*10^7){
        matrix(c(Exascale/(10^-exascalar)/perfrangehigh, efficiencyrangehigh, perfrangehigh, Exascale/(10^-exascalar)/efficiencyrangehigh), ncol=2)
}

## Compute Graphical Lines for iso exascalar
## the argument passed is - log10 of exascalar
 
  for (i in 0:7) {lines(isoexaline(-i)[,1], isoexaline(-i)[,2], lwd=.5, lty=2)}

## PROGRAM IS COMPLETE


