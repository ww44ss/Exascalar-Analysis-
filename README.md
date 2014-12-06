Exascalar-Analysis-
===================

Visualize the Top500 and Green500 Supercomputer Lists

![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/Exascalar.png "Exascalar Graph")

This describes some Exploratory Data Analysis I did on the evolution of supercomputing trends from 2009 hence. 
Since the Green500 and Top500 describe different aspects of essentially the same population of supercomputers, the assumption here is there's inherent value in combining the two lists. 

Exascalar reveals answers to the question "how does the population of "top" super computers evolve?"

####About Exascalar

Exascalar looks at both the [Top500](http://www.top500.org) super computer list (based on performance) and the [Green500](http://www.green500.org) super computer list (based on efficiency) in a single visually digestable graph. It overlays a transverse rectilinear coordinate system of power and "Exascalar" onto Power and Efficiency. 

You can more read about the history of Exascalar [here](https://communities.intel.com/community/itpeernetwork/datastack/blog/2011/10/20/rethinking-supercomputer-performance-and-efficiency-for-exascale), 
[here](http://www.datacenterknowledge.com/archives/2013/01/28/the-taxonomy-of-exascalar/), 
and [here](http://www.datacenterknowledge.com/archives/2012/07/10/june-2012-exascalar-efficiency-dominates-hpc/).


####Data Sources
Data come from the Green500.org and the Top500.org websites.  

The data cleaning program assumes the top500 lists are locally stored in a directory called "Exascalar" as .csv files in the sub-directories Top500 and Green500. These directories are cloned in this repository.
  Green500.org lists are downloadable directly as .csv files from the Green500 website.
  Top500.org lists are stored on the Top500 site as .xls. Since this anlaysis assumes .csv I have converted them using numbers or Excel. 

Currently I have download files back to 2009.

Current available analyses
==========================

#####Exascalar_Cleaner.R  

This reads in the Top500 and Green500 lists stored locally, cleans the data, and creates data.frames with descriptive names of columns. The cleaning function gets updated frequently since the cleaning of individual lists is a bit customized (naming and data entry has not been consistent across the years)

Naming conventions are:  
  
   _Nov13.csv_ - the combined Top500 and Green 500 list from November 2013  
    
   _Jun09.csv_ - the combined Top500 and Green 500 list from June 2009  
    
It also creates a file 

   _BigExascalar.csv_ - which is the combined cleaned files with a date column added

The program saves the files in a folder _results_  

currently the data in the cleaned files are:
 "ExaRank" Numerical rank of computers based on Exascalar
 "exascalar" The computed Exacalar Value  
 "green500rank" The rank of the system in the Green 500 (Efficiency)  
 "top500rank"   The rank of the system in the Top500 (Performance)  
 "rmax"  System Performance       
 "power"  System Power      
 "mflopswatt"   Efficiency  
 "computer" A descriptive name of the computer  
  
#####Exascalar_Trend.R 
  This program creates a plot of the most recent Green500 data and plots the trend lines of the Top and Median exascalar.
  
![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/ExascalarTrend.png "Exascalar")
  
#####PlotWholeBigExascalar.R 

This is a exploratory program which plots all the supercomputing data on one plot. 
It only prints to the screen.
  
#####PowerGap2.R

This program extracts the power and performance data of the most efficient and the least advanced (lowest Exascalar)
  
![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/PowerCompare.png "Power Comparison")

Note that the while the power consumption of the worst (lowest exascalar) is 100 times greater than the lowest power system, the performance of the systems are the same. 

The output is stored as _PowerCompare.png_  
  
#####TechTrend.R

This program helps visualize how different technologies contribute to supercomputing leadership by plotting the data for systems against the data of leading supercoputer. For example the grpah below shows how Intel's Xeon Phi systems have evolved.

The are stored as files named _TechTrend_xxx_.png_
   
   ![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/TechTrend_Perf_Phi.png "Xeon Phi ")
   
####Fin  