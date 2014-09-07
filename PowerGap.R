# Exascalar Data Trend Plots

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
## note the function computes to three digits explicitl

## Read results files

        BigExascalar <- read.csv(paste0(results, "/BigExascalar.csv"), header=TRUE)
        print("data read")

## pick off easy subsets of data

top_Exascalar <- subset(BigExascalar, BigExascalar$ExaRank==1)
        
bottom_Exascalar <- subset(BigExascalar, BigExascalar$ExaRank==500)
bottom_Exascalar$date <- as.Date(bottom_Exascalar$date)

bottom3_Exascalar <- subset(BigExascalar, BigExascalar$ExaRank==497)
        
top_Green <- subset(BigExascalar, green500rank==1)

plot1 <- qplot(bottom_Exascalar$date, bottom_Exascalar$power, bottom_Exascalar, log="y")
plot2 <- qplot(top_Green$date, top_Green$power, top_Green, log="y")

## minimum power takes a bit more work
low_power <- aggregate(BigExascalar$power, list(date = BigExascalar$date), min)
colnames(low_power)<-c("date", "power")
low_power$date <- as.Date(low_power$date, origin="1970-01-01")

low_Exa <- cbind(bottom_Exascalar$date, bottom_Exascalar$power)
colnames(low_Exa)<-c("date", "power")
low_Exa<-as.data.frame(low_Exa)
low_Exa$date <- as.Date(low_Exa$date, origin="1970-01-01")

## create low power table 
## table with lowest power system for each year

datematrix<-as.data.frame(table(BigExascalar$date))

lowpowertable=NULL
for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$power == min(xx$power))
        lowpowertable<-rbind(lowpowertable, xrow)
        }

        lowexatable=NULL
        for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$exascalar == min(xx$exascalar))
        lowexatable<-rbind(lowexatable, xrow)
        }

        highexatable=NULL
        for (ii in 1:length(datematrix[,1])) {
        xx <- BigExascalar[BigExascalar$date == datematrix[ii,1],]
        xrow <- subset(xx, xx$exascalar == mam(xx$exascalar))
        highexatable<-rbind(highexatable, xrow)
        }

stop("check data")

low_Exa_Perf <- cbind(bottom_Exascalar$date, bottom_Exascalar$rmax)
colnames(low_Exa)<-c("date", "rmax")

low_Exa<-as.data.frame(low_Exa)
low_Exa$date <- as.Date(low_Exa$date, origin="1970-01-01")
## median takes a bit more work

par(new=FALSE)

plot(low_power,
     ylim=c(200,20000),
     xlim = c(14000, 16500),
     main = "",
     log="y",
     ylab = "Power (kW)", 
     xlab = "Date",
     col = "red",
     bg = "steelblue2",
     pch=21)
par(new=TRUE)
     
plot(low_Exa, ylim=c(20,20000), xlim = c(14000, 16500), main = "", log="y", ylab = "", col = "black", bg = "green", pch=22)
#wholeplot <- ggplot(BigExascalar, aes(x = mflopswatt, y = rmax)) + coord_trans(x="log10",y="log10") 
#wholeplot<-wholeplot + geom_point(aes(color = factor(date))) 
#wholeplot<- wholeplot+ scale_y_continuous(trans=log_trans(), breaks=c(10^4, 5*10^4, 10^5,5*10^5, 10^6,5*10^6, 10^7,5*10^7,10^8))
#wholeplot<- wholeplot+ scale_x_continuous(trans=log_trans(), breaks=c(10, 50, 100, 500, 1000, 5000, 10000, 50000)) + theme_bw(base_size = 12, base_family = "Helvetica")

#print(wholeplot)