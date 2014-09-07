## Exascalar Data Clean Up

##  This program reads files in the Top500 and Green500 folders,  
## "cleans" the column names (for later use)
## combines them 
## and stores the output data in two forms:
##      MmmYy.csv is the data from that month
##      BigExascalar is a combined list of all data

## The values in the final data frame are
## exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, name (long descriptive name of computer), 

## All programs in this Exascalar GitHub Repository assume this program has been run first to create the files they need to compute.


## STEP 1 GET THE RAW DATA
## Assumes the wd is the Documents directory 
## check for Exascalar Directory. If none exists stop program with error

## set working directory

##check for Exascalar Directory. If none exists create it
if(!getwd()=="/Users/winstonsaunders/Documents/Exascalar") setwd("~/Documents/Exascalar")

# define Data Directories to use

green500data <- "./green500data"
top500data <- "./top500data"
results <- "./results"

## ------------------------
## Read and Clean Green500

# import data set

## there are probably ways to simplify this code but this brute force method is easy to read.

GreenJun14 <- read.csv(paste0(green500data, "/green500_top_201406.csv"), header=TRUE)
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



TopJun14 <- read.csv(paste0(top500data, "/TOP500_201406.csv"), header=TRUE)
TopNov13 <- read.csv(paste0(top500data, "/TOP500_201311.csv"), header=TRUE)
TopJun13 <- read.csv(paste0(top500data, "/TOP500_201306.csv"), header=TRUE)
TopNov12 <- read.csv(paste0(top500data, "/TOP500_201211.csv"), header=TRUE)
TopJun12 <- read.csv(paste0(top500data, "/TOP500_201206.csv"), header=TRUE)
TopNov11 <- read.csv(paste0(top500data, "/TOP500_201111.csv"), header=TRUE)
TopJun11 <- read.csv(paste0(top500data, "/TOP500_201106.csv"), header=TRUE)
TopNov10 <- read.csv(paste0(top500data, "/TOP500_201011.csv"), header=TRUE)
TopJun10 <- read.csv(paste0(top500data, "/TOP500_201006.csv"), header=TRUE)
TopNov09 <- read.csv(paste0(top500data, "/TOP500_200911.csv"), header=TRUE)
TopJun09 <- read.csv(paste0(top500data, "/TOP500_200906.csv"), header=TRUE)
#TopNov08 <- read.csv(paste0(top500data, "/TOP500_200811.csv"), header=TRUE)
#TopJun08 <- read.csv(paste0(top500data, "/TOP500_200806.csv"), header=TRUE)

BigExascalar<-NULL

## ---------------------
## STEP 2 CLEAN RESULTS AND STORE ANALYZE DATA 
##create clean up names function

## this is a general "cleanup"
## as it turns out I need to custom clean up almost each list below to combine them and standardize on naming

## as new lists are created may need to add cleaning functions to this list.
## this cleans everything up to Jun14 well enough to enable most functionality for analysis

cleanupnames <- function(xlist, label = ""){
        xlist <-tolower(          xlist)
        xlist <-gsub("_", "",     xlist)
        xlist <-sub("per", "",    xlist)
        xlist <-gsub("[.]","",      xlist)
        xlist <-sub("mfw", "mflopswatt", xlist)
        xlist <-sub("totalpowerkw", "power", xlist)
        xlist <-sub("powerkw", "power", xlist)
        xlist <-sub("totalpower", "power", xlist)
        ##here some gynmansitcs are required to keep dulicated like "greengreen500rank" out of picture
        xlist <-sub("green500rank", "hold_my_beer", xlist)
        xlist <-sub("top500rank","hold_my_hand", xlist)
        xlist <-sub("rank", "top500rank", xlist)
        xlist <-sub("hold_my_hand", "top500rank", xlist)
        xlist <-sub("hold_my_beer", "green500rank", xlist)
        ##specific clean up for Jun11
        xlist <-sub("mflopswattatt", "mflopswatt", xlist)
        
        ## define which list each variable comes from using label. this avoids messy warnings
        xlist<-paste0(xlist, label)
        ## except rmax which is used later in merge
        xlist <- sub("top500rank.*", "top500rank", xlist)
        
}

## names_clean_2 gets rid of the labels
## need to use [.] for period to make wildcard work properly
names_clean_2 <- function(xlist){
        xlist <- sub("*[.]t", "", xlist)
        xlist <- sub("*[.]g", "", xlist)
}

## ---------------------------------
## EXASCALAR FUNCTION
## create compute_exascalar function

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

## CLEAN FILES
## --------------------------

## each set of data is treated separately since data sets are not consistent year to year.
## each set requires a certain amount of hand crafting (especially earlier years)
##here is current data in the outpur files
##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 



## JUN 14 CLEANING
## ---- 
        ## labels reduce confusion on merge
        names(GreenJun14)<-cleanupnames(names(GreenJun14), label=".g")
        names(TopJun14)<-cleanupnames(names(TopJun14), label=".t")

        ## merge megaset
        tt <- merge(GreenJun14, TopJun14, by="top500rank", all.x=TRUE)
        ## select relevant columns  (these are hand crafted per list)
        
        Jun14<-tt[, c("green500rank.g", "top500rank", "rmax.g", "power.g", "mflopswatt.g", "computer.g")]

        names(Jun14) <- names_clean_2(names(Jun14))

        ##compute exascalar
        exascalar <- compute_exascalar(Jun14)
        ##add exascalar result to data frame
        Jun14 <- cbind(exascalar, Jun14)
        ##sort by exascalar
        Jun14 <- Jun14[order(exascalar),]
        ##renumber rows
        
        ExaRank <- c(1:nrow(Jun14))
        Jun14<-cbind(ExaRank, Jun14)

        ##define date vector
        date = rep(as.Date("06/01/2014", "%m/%d/%Y"), nrow(Jun14))
        ##bind it to the data
        Jun14 <- cbind(date,Jun14)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Jun14)

        ## final cleaned data
        ## write file to results folder
        write.csv(Jun14, "./results/Jun14.csv")

 
print("Jun14")


## ---------
## NOV 13 cleaning



        ## labels reduce confusion on merge
        names(GreenNov13)<-cleanupnames(names(GreenNov13), label=".g")
        names(TopNov13)<-cleanupnames(names(TopNov13), label=".t")

        ##delete the ninth column of Nov13 this is an extraordinary edit since the original csv contains two column named name and Name (ugh)
        GreenNov13 <- GreenNov13[,-9]

        ## merge megaset
        tt <- merge(GreenNov13, TopNov13, by="top500rank", all.x=TRUE)

        ## select relevant columns

        Nov13<-tt[, c("green500rank.g", "top500rank", "rmax.g", "power.g", "mflopswatt.g", "name.g")]

        ##names cleanup
        
        names(Nov13) <- names_clean_2(names(Nov13))

        ##specific column names substitution for Nov13
        names(Nov13) <- sub("name", "computer", names(Nov13))
        ##compute exascalar
        exascalar <- compute_exascalar(Nov13)
        ##final cleaned data
        Nov13 <- cbind(exascalar, Nov13)

        Nov13 <- Nov13[order(exascalar),]

        row.names(Nov13) <- 1:nrow(Nov13)

        ExaRank <- c(1:nrow(Nov13))
        Nov13<-cbind(ExaRank, Nov13)

        ##define date vector
        date = rep(as.Date("11/01/2013", "%m/%d/%Y"), nrow(Nov13))
        ##bind it to the data
        Nov13 <- cbind(date,Nov13)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Nov13)


        ##final cleaned data
        ##write file to results folder

        write.csv(Nov13, "./results/Nov13.csv")

print("Nov13")

## ----
## JUN13 CLEANING


        ## label tagging to reduce confusion on merge
        names(GreenJun13)<-cleanupnames(names(GreenJun13), label=".g")
        names(TopJun13)<-cleanupnames(names(TopJun13), label=".t")
        

        ## merge megaset
        tt <- merge(GreenJun13, TopJun13, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Jun13 <- cbind(tt[,c(2, 1, 3, 4, 6, 11)])
        Jun13t<-tt[, c("green500rank.g", "top500rank", "rmax.g", "power.g", "mflopswatt.g", "computer.g")]

        ##names cleanup
        names(Jun13) <- names_clean_2(names(Jun13))
        ##compute exascalar
        exascalar <- compute_exascalar(Jun13)
        ##add exascalar result to data frame
        Jun13 <- cbind(exascalar, Jun13)
        ##sort by exascalar
        Jun13 <- Jun13[order(exascalar),]
        ##renumber rows
        row.names(Jun13) <- 1:nrow(Jun13)
        ## add ExaRank column
        ExaRank <- c(1:nrow(Jun13))
        Jun13<-cbind(ExaRank, Jun13)

                
        ##define date vector
        date = rep(as.Date("06/01/2013", "%m/%d/%Y"), nrow(Jun13))
        ##bind it to the data
        Jun13 <- cbind(date,Jun13)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Jun13)

        ##final cleaned data
        ##write file to results folder
        write.csv(Jun13, "./results/Jun13.csv")
print("Jun13")

## NOV12 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenNov12)<-cleanupnames(names(GreenNov12), label=".g")
        names(TopNov12)<-cleanupnames(names(TopNov12), label=".t")
        ##for GreenNov12 need to create a top500rank column
                GreenNov12<-GreenNov12[order(GreenNov12$rmax.g),]
                top500rank <- nrow(GreenNov12):1
                GreenNov12 <- cbind(top500rank,GreenNov12)

       
        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 
        
        ## merge megaset
        tt <- merge(GreenNov12, TopNov12, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Nov12 <- cbind(tt[,c(2, 1, 11, 9, 8, 17)])

        ##names cleanup
        names(Nov12) <- names_clean_2(names(Nov12))
        ##compute exascalar
        exascalar <- compute_exascalar(Nov12)
        ##add exascalar result to data frame
        Nov12 <- cbind(exascalar, Nov12)
        ##sort by exascalar
        Nov12 <- Nov12[order(exascalar),]
        ##renumber rows
        row.names(Nov12) <- 1:nrow(Nov12)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Nov12))
        Nov12<-cbind(ExaRank, Nov12)


        ##define date vector
        date = rep(as.Date("11/01/2012", "%m/%d/%Y"), nrow(Nov12))
        ##bind it to the data
        Nov12 <- cbind(date,Nov12)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Nov12)



        ##final cleaned data
        ##write file to results folder
        write.csv(Nov12, "./results/Nov12.csv")

print("Nov12")

## JUN12 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenJun12)<-cleanupnames(names(GreenJun12), label=".g")
        names(TopJun12)<-cleanupnames(names(TopJun12), label=".t")

        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenJun12, TopJun12, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Jun12 <- cbind(tt[,c(2, 1, 22, 8, 7, 5)])

        ##names cleanup
        names(Jun12) <- names_clean_2(names(Jun12))

        ##compute exascalar
        exascalar <- compute_exascalar(Jun12)
        ##add exascalar result to data frame
        Jun12 <- cbind(exascalar, Jun12)
        ##sort by exascalar
        Jun12 <- Jun12[order(exascalar),]
        ##renumber rows
        row.names(Jun12) <- 1:nrow(Jun12)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Jun12))
        Jun12<-cbind(ExaRank, Jun12)

        ##define date vector
        date = rep(as.Date("06/01/2012", "%m/%d/%Y"), nrow(Jun12))
        ##bind it to the data
        Jun12 <- cbind(date,Jun12)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Jun12)



        ##final cleaned data
        ##write file to results folder
        write.csv(Jun12, "./results/Jun12.csv")

print("Jun12")

# NOV11 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenNov11)<-cleanupnames(names(GreenNov11), label=".g")
        names(TopNov11)<-cleanupnames(names(TopNov11), label=".t")

        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenNov11, TopNov11, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Nov11 <- cbind(tt[,c(2, 1, 19, 8, 7, 5)])

        ##names cleanup
        names(Nov11) <- names_clean_2(names(Nov11))

        ##compute exascalar
        exascalar <- compute_exascalar(Nov11)
        ##add exascalar result to data frame
        Nov11 <- cbind(exascalar, Nov11)
        ##sort by exascalar
        Nov11 <- Nov11[order(exascalar),]
        ##renumber rows
        row.names(Nov11) <- 1:nrow(Nov11)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Nov11))
        Nov11<-cbind(ExaRank, Nov11)

        ##define date vector
        date = rep(as.Date("11/01/2011", "%m/%d/%Y"), nrow(Nov11))
        ##bind it to the data
        Nov11 <- cbind(date,Nov11)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Nov11)



        ##final cleaned data
        ##write file to results folder
        write.csv(Nov11, "./results/Nov11.csv")

print("Nov11")

# JUN11 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenJun11)<-cleanupnames(names(GreenJun11), label=".g")
        names(TopJun11)<-cleanupnames(names(TopJun11), label=".t")

        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenJun11, TopJun11, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Jun11 <- cbind(tt[,c(2, 1, 16, 8, 7, 5)])

        ##names cleanup
        names(Jun11) <- names_clean_2(names(Jun11))
        
        ##compute exascalar
        exascalar <- compute_exascalar(Jun11)
        ##add exascalar result to data frame
        Jun11 <- cbind(exascalar, Jun11)
        ##sort by exascalar
        Jun11 <- Jun11[order(exascalar),]
        ##renumber rows
        row.names(Jun11) <- 1:nrow(Jun11)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Jun11))
        Jun11<-cbind(ExaRank, Jun11)

        ##define date vector
        date = rep(as.Date("06/01/2011", "%m/%d/%Y"), nrow(Jun11))
        ##bind it to the data
        Jun11 <- cbind(date,Jun11)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Jun11)

        ##final cleaned data
        ##write file to results folder
        write.csv(Jun11, "./results/Jun11.csv")
        
print("Jun11")

# NOV10 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenNov10)<-cleanupnames(names(GreenNov10), label=".g")
        names(TopNov10)<-cleanupnames(names(TopNov10), label=".t")

        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenNov10, TopNov10, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Nov10 <- cbind(tt[,c(2, 1, 16, 8, 7, 5)])

        ##names cleanup
        names(Nov10) <- names_clean_2(names(Nov10))
        ##compute exascalar
        exascalar <- compute_exascalar(Nov10)
        ##add exascalar result to data frame
        Nov10 <- cbind(exascalar, Nov10)
        ##sort by exascalar
        Nov10 <- Nov10[order(exascalar),]
        ##this data set requires a complete cases check
        Nov10<-Nov10[complete.cases(Nov10),]
        ##renumber rows
        row.names(Nov10) <- 1:nrow(Nov10)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Nov10))
        Nov10<-cbind(ExaRank, Nov10)

        ##define date vector
        date = rep(as.Date("11/01/2010", "%m/%d/%Y"), nrow(Nov10))
        ##bind it to the data
        Nov10 <- cbind(date,Nov10)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Nov10)


        ##final cleaned data
        ##write file to results folder
        write.csv(Nov10, "./results/Nov10.csv")

print("Nov10")

# JUN10 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenJun10)<-cleanupnames(names(GreenJun10), label=".g")
        names(TopJun10)<-cleanupnames(names(TopJun10), label=".t")

        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenJun10, TopJun10, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Jun10 <- cbind(tt[,c(2, 1, 16, 8, 7, 5)])
        
        ##names cleanup
        names(Jun10) <- names_clean_2(names(Jun10))

        ##SPECIAL INSTRUCTIONS
        ## for some reason there are comma in the power data so this elimiates them and turns the data into numberic
        Jun10$power <- sub("[,]", "", Jun10$power)
        Jun10$power <- as.numeric(Jun10$power)
        ##SPECIAL INSTRUCTION - END

        ##compute exascalar
        exascalar <- compute_exascalar(Jun10)
        ##add exascalar result to data frame
        Jun10 <- cbind(exascalar, Jun10)
        ##sort by exascalar
        Jun10 <- Jun10[order(exascalar),]
        ##this data set requires a complete cases check
        Jun10<-Jun10[complete.cases(Jun10),]
        ##renumber rows
        row.names(Jun10) <- 1:nrow(Jun10)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Jun10))
        Jun10<-cbind(ExaRank, Jun10)

        ##define date vector
        date = rep(as.Date("06/01/2010", "%m/%d/%Y"), nrow(Jun10))
        ##bind it to the data
        Jun10 <- cbind(date,Jun10)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Jun10)



        ##final cleaned data
        ##write file to results folder
        write.csv(Jun10, "./results/Jun10.csv")

print("Jun10")

# NOV09 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenNov09)<-cleanupnames(names(GreenNov09), label=".g")
        names(TopNov09)<-cleanupnames(names(TopNov09), label=".t")

        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenNov09, TopNov09, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Nov09 <- cbind(tt[,c(2, 1, 16, 8, 7, 5)])

        ##names cleanup
        names(Nov09) <- names_clean_2(names(Nov09))
        ##compute exascalar
        exascalar <- compute_exascalar(Nov09)
        ##add exascalar result to data frame
        Nov09 <- cbind(exascalar, Nov09)
        ##sort by exascalar
        Nov09 <- Nov09[order(exascalar),]
        ##this data set requires a complete cases check
        Nov09<-Nov09[complete.cases(Nov09),]
        ##renumber rows
        row.names(Nov09) <- 1:nrow(Nov09)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Nov09))
        Nov09<-cbind(ExaRank, Nov09)

        ##define date vector
        date = rep(as.Date("11/01/2009", "%m/%d/%Y"), nrow(Nov09))
        ##bind it to the data
        Nov09 <- cbind(date,Nov09)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Nov09)

        ##final cleaned data
        ##write file to results folder
        write.csv(Nov09, "./results/Nov09.csv")

print("Nov09")

# JUN09 CLEANING
## ----

        ## label tagging to reduce confusion on merge
        names(GreenJun09)<-cleanupnames(names(GreenJun09), label=".g")
        names(TopJun09)<-cleanupnames(names(TopJun09), label=".t")

        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenJun09, TopJun09, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Jun09 <- cbind(tt[,c(2, 1, 16, 8, 7, 5)])

        ##names cleanup
        names(Jun09) <- names_clean_2(names(Jun09))
        ##compute exascalar
        exascalar <- compute_exascalar(Jun09)
        ##add exascalar result to data frame
        Jun09 <- cbind(exascalar, Jun09)
        ##sort by exascalar
        Jun09 <- Jun09[order(exascalar),]
        ##this data set requires a complete cases check
        Jun09<-Jun09[complete.cases(Jun09),]
        ##renumber rows
        row.names(Jun09) <- 1:nrow(Jun09)

        ## add ExaRank column
        ExaRank <- c(1:nrow(Jun09))
        Jun09<-cbind(ExaRank, Jun09)

        ##define date vector
        date = rep(as.Date("06/01/2009", "%m/%d/%Y"), nrow(Jun09))
        ##bind it to the data
        Jun09 <- cbind(date,Jun09)
        ## Put values in BigExascalar
        BigExascalar <- rbind(BigExascalar,Jun09)


        ##final cleaned data
        ##write file to results folder
        write.csv(Jun09, "./results/Jun09.csv")

print("Jun09")

##OUTPUT BIGEXASCALAR

        write.csv(BigExascalar, "./results/BigExascalar.csv")


## PROGRAM IS COMPLETE


