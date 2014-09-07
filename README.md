Exascalar-Analysis-
===================

Visualize the Top500 and Green500 Supercomputer Lists

![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/Exascalar.png "Exascalar Graph")


Exascalar
=========

This is a repository for code analyzing the Green500 and Top500 computer lists using Exascalar

You can read about Exascalar [here](https://communities.intel.com/community/itpeernetwork/datastack/blog/2011/10/20/rethinking-supercomputer-performance-and-efficiency-for-exascale), 
[here](http://www.datacenterknowledge.com/archives/2013/01/28/the-taxonomy-of-exascalar/), 
and [here](http://www.datacenterknowledge.com/archives/2012/07/10/june-2012-exascalar-efficiency-dominates-hpc/).

####What is Exascalar?
Exascalar is an approach to look at supercomputing leadership trends in both the Top500 super computer list (based on performance) and the Green500 super computer list (based on efficiency) in a single visually digestable graph. It's about the population of the Top supercomputers. 

The general question Exascalar addresses is "how does the population of "top" super computers evolve?"

The Top500 and Green500 lists are really just that. Lists. Lists are hard to visualize and frankly, apart from the top one or two, nobody really pays attention to much else to what is going on under the covers. But that's where the technology story is most interesting. 

Exascalar combines the efficiency analysis and performance analysis into one easily digested graph. It overlays a transverse rectilinear coordinate system of power and "Exascalar." Exascalar measures supercomputing leadership as both performance (scale) and efficiency (capability).

It's worth noting the current  Exascalar is simpler than the original version, which used a kind of circular distance in logarithmic space. A conversation with a colleague convinced me that a better approach would be to base Exascalar on the product of Efficiency*Performance. 

####Why Invent Exascalar?
Exascalar allows visualization of the Top500 and Green500 lists on a single graph.

  *Highlights leading indicators of performance leadership   
  *Reveals highly inefficient systems in production (which should be [refreshed](http://www.datacenterknowledge.com/archives/2013/01/28/the-taxonomy-of-exascalar/) )   
  *Shows how the "power wall" limits the trend of performance of the overall population
  
Exascalar provides a simple numerical ranking based on combined leadership. 
  *The Top value is usally dominated by performance    
  *The Median value shows a trend of the "general population"    
   
Exascalar enables observations of technology trends more easily than other methods. At root it is a data visualization tool.


####What data do you use and where did you get it?
Data come from the Green500.org and the Top500.org websites.  

The data cleaning program assumes the top500 lists are locally stored in a directory called "Exascalar" as .csv files in the sub-directories Top500 and Green500. These directories are clones in this repository.
  Green500.org lists are downloadable directly as .csv files from the Green500 website.
  Top500.org lists are stored on the Top500 site as .xls. Since this anlaysis assumes .csv I have converted them using numbers or Excel. 

Currently I have download files back to 2009.


Current available analyses
==========================

#####Exascalar_Cleaner.R
  This reads in the Top500 and Green500 lists, cleans the data, and creates data.frames with these descriptive names (for example). The cleaning function gets updated frequently since the cleaning of individual lists is a a bit customized (naming and data enrty has not been consistent across the years)
  
   _Nov13.csv_ - the combined Top500 and Green 500 list from November 2013  
    
   _Jun09.csv_ - the combined Top500 and Green 500 list from June 2009  
    
It also creates a file 

   _BigExascalar.csv_ - which is the combined cleaned files with a date column added

The program saves the files in a foled called "results"

currently the data saved are:
 "exascalar"    "green500rank" "top500rank"   "rmax"         "power"        "mflopswatt"   "computer"

#####Exascalar_Trend.R 
  This program creates a plot of the most recent Green500 data and plots the trend lines of the Top and Median exascalar.
  
#####PlotWholeBigExascalar.R 
  This is a exploratory program which plots all teh supercoputing data on one plot. 
  
#####PowerGap2.R
  This program extracts the power and performance data of the most efficient and the least advanced (lowest Exascalar)
  
![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/PowerCompare.png "Power Comparison")

Note that the performance of the systems are the same. 
  
#####TechTrend.R
   This program helps visualize how different technologies contribute to supercomputing leadership by plotting the data for systems against the data of leading supercoputer. For example the grpah below shows all teh Xeon Phi systems.
   
   ![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/TechTrend_Perf_Phi.png "Xeon Phi ")
   
 