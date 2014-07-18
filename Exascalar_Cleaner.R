## Exascalar Data Clean Up

## This program reads files in the Top500 and Green500 folders,  
## it "cleans" the column names (for later use)
## combines them with clear easy to remember filenames.
## and stores the files as .csv's

## The values in the final data frame are
## exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, name (long descriptive name of computer), 

## All programs in this Exascalar GitHub Repository assume this program has been run first to create the files they need to compute.


## GET THE RAW DATA
## Assumes the wd is the Documents directory 
##check for Exascalar Directory. If none exists stop program with error

## set working directory



# define Data Directories to use

green500data <- "./green500data"
top500data <- "./top500data"
results <- "./results"

## ------------------------
## Read and Clean Green500

# import data set

## there are probably ways to simplify this code but this brute force method is easy to read.

GreenJun14 <- read.csv(paste0(green500data, "/GreenJun14.csv"), header=TRUE)
##Note GreenJUn13.csv is an artifically constructed data set from web data (.csv was not avail on website)
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

## ---------------------
## create clean up names function

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

## each set of data is treated separately since data sets are not consistent
## each set requires a certain amount of hand crafting

## JUN 14 CLEANING
## ---- 

        ## labels reduce confusion on merge
        names(GreenJun14)<-cleanupnames(names(GreenJun14), label=".g")
        names(TopJun14)<-cleanupnames(names(TopJun14), label=".t")
        
        ##there are some pesky commas in some of the power numbers that need to be cleaned out
        GreenJun14$power.g <-gsub("[,]","", GreenJun14$power.g)
        GreenJun14$mflopswatt.g <-gsub("[,]","", GreenJun14$mflopswatt.g)
        
        ##for GreenJun14 need to create a top500rank column
        ##first turn columns into numeric values
        GreenJun14$mflopswatt.g<-as.numeric(GreenJun14$mflopswatt.g)
        GreenJun14$power.g<-as.numeric(GreenJun14$power.g)
        GreenJun14 <- within(GreenJun14, rmax.g <- mflopswatt.g*power.g)
        
        GreenJun14<-GreenJun14[order(GreenJun14$rmax.g),]
        top500rank <- nrow(GreenJun14):1
        GreenJun14t <- cbind(top500rank,GreenJun14)
        GreenJun14<-GreenJun14t
        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 


        ## merge megaset
        tt <- merge(GreenJun14, TopJun14, by="top500rank", all.x=TRUE)
        ## select relevant columns  (these are hand crafted per list)
        Jun14 <- cbind(tt[,c(2, 1, 7, 6, 3, 5)])

        ##names cleanup
        names(Jun14) <- names_clean_2(names(Jun14))
        Jun14$rmax<-as.numeric(as.character(Jun14$rmax))
        Jun14$mflopswatt<-as.numeric(as.character(Jun14$mflopswatt))
        ##compute exascalar
        exascalar <- compute_exascalar(Jun14)
        ##add exascalar result to data frame
        Jun14 <- cbind(exascalar, Jun14)
        ##sort by exascalar
        Jun14 <- Jun14[order(exascalar),]
        ##renumber rows
        row.names(Jun14) <- 1:nrow(Jun14)
        ##final cleaned data
        ##write file to results folder
        write.csv(Jun14, "./results/Jun14.csv")


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
        Nov13 <- cbind(tt[,c(2, 1, 3, 4, 5, 8)])

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

        #convert exascalar rank to integer
        Nov13$exascalar <- as.integer(Nov13$exascalar)

        ##final cleaned data
        ##write file to results folder

        write.csv(Nov13, "./results/Nov13.csv")


## ----
## JUN13 CLEANING


        ## label tagging to reduce confusion on merge
        names(GreenJun13)<-cleanupnames(names(GreenJun13), label=".g")
        names(TopJun13)<-cleanupnames(names(TopJun13), label=".t")
        
        ##here is the final order of names
        ##exascalarrank, exascalar, green500rank, top500rank, rmax, power, megaflopswatt, computer, 

        ## merge megaset
        tt <- merge(GreenJun13, TopJun13, by="top500rank", all.x=TRUE)

        ## select relevant columns  (these are hand crafted per list)
        Jun13 <- cbind(tt[,c(2, 1, 3, 4, 6, 11)])

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
                
        #convert exascalar rank to integer
        Jun13$exascalar <- as.integer(Jun13$exascalar)
       
        ##final cleaned data
        ##write file to results folder
        write.csv(Jun13, "./results/Jun13.csv")


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
        #convert exascalar rank to integer
        Nov12$exascalar <- as.integer(Nov12$exascalar)
        ##final cleaned data
        ##write file to results folder
        write.csv(Nov12, "./results/Nov12.csv")


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
        #convert exascalar rank to integer
        Jun12$exascalar <- as.integer(Jun12$exascalar)
        ##final cleaned data
        ##write file to results folder
        write.csv(Jun12, "./results/Jun12.csv")

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

        #convert exascalar rank to integer
        Nov11$exascalar <- as.integer(Nov11$exascalar)

        ##final cleaned data
        ##write file to results folder
        write.csv(Nov11, "./results/Nov11.csv")

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

        #convert exascalar rank to integer
        Jun11$exascalar <- as.integer(Jun11$exascalar)

        ##final cleaned data
        ##write file to results folder
        write.csv(Jun11, "./results/Jun11.csv")
        

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

        #convert exascalar rank to integer
        Nov10$exascalar <- as.integer(Nov10$exascalar)

        ##final cleaned data
        ##write file to results folder
        write.csv(Nov10, "./results/Nov10.csv")


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

        #convert exascalar rank to integer
        Jun10$exascalar <- as.integer(Jun10$exascalar)

        ##final cleaned data
        ##write file to results folder
        write.csv(Jun10, "./results/Jun10.csv")


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

        #convert exascalar rank to integer
        Nov09$exascalar <- as.integer(Nov09$exascalar)

        ##final cleaned data
        ##write file to results folder
        write.csv(Nov09, "./results/Nov09.csv")


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


        #convert exascalar rank to integer
        Jun09$exascalar <- as.integer(Jun09$exascalar)


        ##final cleaned data
        ##write file to results folder
        write.csv(Jun09, "./results/Jun09.csv")



## PROGRAM IS COMPLETE


