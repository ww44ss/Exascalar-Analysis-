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

require(ggplot2)
require(scales)

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

BigExascalar <- read.csv(paste0(results, "/BigExascalar.csv"), header=TRUE)


print("data read")

wholeplot <- ggplot(BigExascalar, aes(x = mflopswatt, y = rmax)) + coord_trans(x="log10",y="log10") 
wholeplot<-wholeplot + geom_point(aes(color = factor(date))) 
wholeplot<- wholeplot+ scale_y_continuous(trans=log_trans(), breaks=c(10^4, 5*10^4, 10^5,5*10^5, 10^6,5*10^6, 10^7,5*10^7,10^8))
wholeplot<- wholeplot+ scale_x_continuous(trans=log_trans(), breaks=c(10, 50, 100, 500, 1000, 5000, 10000, 50000))

print(wholeplot)