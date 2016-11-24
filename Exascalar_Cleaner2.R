## Exascalar Data Clean Up
## Rev2

##  This program reads files in the Top500 and Green500 raw-data folders,
## "cleans" the column names, combine them, and stores the output data as a file called
##  BigExascalar



## STEP 1 REQUIRED LIBRARIES


    library(dplyr)
    library(tidyverse)
    library(stringr)
    library(RCurl)
    library(devtools)

    if( !"yo" %in% installed.packages()[,1] ) {
        library(devtools)
        devtools::install_github("ww44ss/yo")}

    library(yo)

## SET DIRECTORIES

    ##check for Exascalar Directory. If none exists create it
    if(!getwd()=="/Users/winstonsaunders/Documents/Exascalar") setwd("~/Documents/Exascalar")

    # define Data Directories to use

    green500data <- "./green500data"
    top500data <- "./top500data"
    results <- "./results"

## STEP 2: DEFINE UTILITY FUNCTIONS

    ## colnames_cleaner

    colnames_cleaner <- function(tbl){
        ## cleans the Top500 and Green500 files of combined sins of
        ##    column labeling changes over the years.
        ##    note this does not fix all the problems. Some are handled in data processing
        ##    see readme.md for more details.
        ## input: a tibble (data_frame)
        ## output: the tibble with cleaned column names

        colnames(tbl) <-
            colnames(tbl) %>%
            tolower %>%
            gsub(" ", "", .) %>%
            gsub("\\(", ".", .) %>%
            gsub("\\)", "", .) %>%
            gsub(".%" , "" , .) %>%
            gsub("/" , "per", .) %>%
            gsub("effeciency" , "efficiency",.) %>%
            gsub("atorperco" , "atorco",.) %>%
            gsub("-" , "", .) %>%
            gsub("_" , "" , .) %>%
            gsub("totalpower" , "power" , .) %>%
            gsub("mfperwatt", "mflopsperwatt", .) %>%
            gsub("^mfw$", "mflopsperwatt", .) %>%
            gsub("?", "", .) %>%
            gsub("^power.kw$", "power", .) %>%
            yo

        return(tbl)
    }


## STEP 3: CLEAN AND COMBINE THE TOP500 DATA

    list.names <- list.files(top500data) %>% subset(grepl("(.*).csv$",.)) #%>% tibble("files" = .)

    first.pass.flag <- TRUE
    BigExascalar <- NULL

    list.x <- list.names[1]
    list.x <- list.names[2]

    for (list.x in list.names) {

        #cat(c("\n", list.x, "<<======\n"))

        temp.x <- suppressMessages(read_csv(str_c(top500data,"/", list.x)))

        temp.x <- colnames_cleaner(temp.x)

        # colnames(temp) <-
        #     colnames(temp) %>%
        #     tolower %>%
        #     gsub(" ", "", .) %>%
        #     gsub("\\(", ".", .) %>%
        #     gsub("\\)", "", .) %>%
        #     gsub(".%", "", .) %>%
        #     gsub("/", "per", .) %>%
        #     gsub("effeciency", "efficiency",.) %>%
        #     gsub("atorperco", "atorco",.) %>%
        #     gsub("-", "", .) %>%
        #     yo

        ## compute date from filename
        y.m <- list.x %>% str_extract("[0-9]{6,}(?=\\.)")
         y <- y.m %>% str_extract("[0-9]{4}")
         m <- y.m %>% str_extract("[0-9]{2}$")

        date.x <- str_c(y, m, "01", sep = "-")

        ## assign date column
        temp.x$date <- date.x

        ## build tibble
        if(first.pass.flag != TRUE) {

            temp.cn <- colnames(temp.x)

            ## hand-craft forward compatibility of column names
            ## (as column names were modified in a new list, the old one needs to be updated for data continutity)
            ## (in cases where names flip-flopped, it's fixed more generally in the colnames_cleaner function)

            # naming change
            if (list.x == "TOP500_200811.csv") BigExascalar <- BigExascalar %>% mutate(cores = processors) %>% select(-processors)
            # indicator dropped
            if (list.x == "TOP500_201011.csv") BigExascalar <- BigExascalar %>% select(-measuredsize)
            # naming changes
            if (list.x == "TOP500_201111.csv") { BigExascalar <- BigExascalar %>%
                    mutate(totalcores = cores) %>% select(-cores) %>%
                    mutate(processortechnology = processorfamily) %>% select(-processorfamily) %>%
                    mutate(processorspeed.mhz = proc.frequency) %>% select(-proc.frequency) %>%
                    mutate(totalcores = processorcores) %>% select(-processorcores) %>%
                    mutate(segment = applicationarea) %>% select(-applicationarea) %>%
                    yo
            }
            ## naming changes
            if (list.x == "TOP500_201206.csv")
               { BigExascalar <-
                   BigExascalar %>%
                   mutate(acceleratorcoprocessorcores = acceleratorcores) %>%
                   select(-acceleratorcores) %>%
                   mutate(acceleratorcoprocessor = accelerator) %>%
                   select(-accelerator) %>%
                   yo
            }
            ## drop efficiency (not tracked in subsequent years)
            if (list.x == "TOP500_201311.csv") BigExascalar <- BigExascalar %>% select(-efficiency)


            be.cn <- colnames(BigExascalar)

            #cat(c("\nnew col names == ", temp.cn, "\n"))
            #cat(c("\nold col names == ", be.cn, "\n"))
            #cat(c("col number new = ", length(temp.cn), "\n"))
            #cat(c("col number old = ", length(be.cn), "\n"))

            joined <- suppressMessages(full_join(temp.x, BigExascalar))

            ## check that all old names are carried forward, if not, print the colname
            if(dim(joined)[2] > dim(temp.x)[2]) {
                #cat(c("\n\n\nnew col names == ", temp.cn, "\n"))
                #cat(c("\nold col names == ", be.cn, "\n"))
                #cat(c("\nactual col names == ", colnames(joined), "\n"))
                for (names in colnames(BigExascalar)){
                    if (! names %in% colnames(temp)) cat(c("--->", names, " not in superior list  <---- \n"))
                }
            }

            cat(c("col numbers joined temp = ", length(colnames(joined)), "\n"))
            #cat(c("col names joined temp = ", colnames(temp), "\n"))

            temp.x <- joined
        }

        first.pass.flag <- FALSE
        BigExascalar <- temp.x
    }

    ## cache the value
    BigExascalar.hold <- BigExascalar

## GREEN500


    list.names <- list.files(green500data) %>% subset(grepl("(.*).csv$",.)) #%>% tibble("files" = .)

    first.pass.flag <- TRUE
    BigExascalar <- NULL

    list.x <- list.names[1]
    list.x <- list.names[2]

    for (list.x in list.names) {

        cat(c("\n", list.x, "<<======\n"))

        temp.x <- suppressMessages(read_csv(str_c(green500data,"/", list.x)))

        temp.x <- colnames_cleaner(temp.x)

        # colnames(temp) <-
        #     colnames(temp) %>%
        #     tolower %>%
        #     gsub(" ", "", .) %>%
        #     gsub("\\(", ".", .) %>%
        #     gsub("\\)", "", .) %>%
        #     gsub(".%" , "" , .) %>%
        #     gsub("/" , "per", .) %>%
        #     gsub("effeciency" , "efficiency",.) %>%
        #     gsub("atorperco" , "atorco",.) %>%
        #     gsub("-" , "", .) %>%
        #     gsub("_" , "" , .) %>%
        #     gsub("totalpower" , "power" , .) %>%
        #     gsub("mfperwatt", "mflopsperwatt", .) %>%
        #     gsub("^mfw$", "mflopsperwatt", .) %>%
        #     gsub("?", "", .) %>%
        #     gsub("^power.kw$", "power", .) %>%
        #     yo

        ## compute date from filename
        y.m <- list.x %>% str_extract("[0-9]{6,}(?=\\.)")
        y <- y.m %>% str_extract("[0-9]{4}")
        m <- y.m %>% str_extract("[0-9]{2}$")


        date <- str_c(y, m, "01", sep = "-")

        ## create date column
        temp.x$date <- date

        ## restrict data form green500
        temp.x <- temp.x %>%
            select(green500rank, power, top500rank, date) %>%
            rename(green500power = power, rank = top500rank) %>%
            ruhroh


        ## build tibble
        if(first.pass.flag != TRUE) {

            temp.cn <- colnames(temp.x)

            be.cn <- colnames(BigExascalar)

            #cat(c("\nnew col names == ", temp.cn, "\n"))
            #cat(c("\nold col names == ", be.cn, "\n"))
            #cat(c("col number new = ", length(temp.cn), "\n"))
            #cat(c("col number old = ", length(be.cn), "\n"))

            joined <- suppressMessages(full_join(temp.x, BigExascalar))

            if(dim(joined)[2] > dim(temp.x)[2]) {
                #cat(c("\n\n\nnew col names == ", temp.cn, "\n"))
                #cat(c("\nold col names == ", be.cn, "\n"))
                #cat(c("\nactual col names == ", colnames(joined), "\n"))
                for (names in colnames(BigExascalar)){
                    if (! names %in% colnames(temp)) cat(c("--->", names, " not in superior list  <---- \n"))
                }
            }

            cat(c("col numbers joined temp = ", length(colnames(joined)), "\n"))
            #cat(c("col names joined temp = ", colnames(temp), "\n"))

            temp.x <- joined
        }

        first.pass.flag <- FALSE
        BigExascalar <- temp.x
    }


## COMBINE Top500 and Green500

    BigExascalar <-
        BigExascalar.hold %>% left_join(BigExascalar, by = c("date", "rank"))


## COMPUTE EXASCALAR

    ## Define Exascalar in terms of 10^18 flops and 20 MegaWatts
    ExaPerf <- 10^12           ##in Megaflops
    ExaEff <- 10^12/(20*10^6)  ##in Megaflops/Watt

    ## compute it
    BigExascalar <- BigExascalar %>%
        mutate(Exascalar = (log10(rmax*10^3/ExaPerf) + log10(mflopsperwatt/(ExaEff)))/sqrt(2)) %>%
        as_data_frame %>%
        yo



        write(BigExascalar, "./results/BigExascalar.csv")



## PROGRAM IS COMPLETE


