Exascalar-Analysis-
===================

Visualize the Top500 and Green500 Supercomputer Lists

![alt text](https://github.com/ww44ss/Exascalar-Analysis-/raw/master/RPlot.png "Exascalar Graph")


Exascalar
=========

This is a repository for code analyzing the Green500 and Top500 computer lists using Exascalar

You can read about Exascalar [here](https://communities.intel.com/community/itpeernetwork/datastack/blog/2011/10/20/rethinking-supercomputer-performance-and-efficiency-for-exascale), 
[here](http://www.datacenterknowledge.com/archives/2013/01/28/the-taxonomy-of-exascalar/), 
and [here](http://www.datacenterknowledge.com/archives/2012/07/10/june-2012-exascalar-efficiency-dominates-hpc/).

####What is Exascalar?
Exascalar is an approach to look at leadership trends in both the Top500 super computer list (based on performance) and the Green500 super computer list (based on efficiency) in a new way.

The analysis came about from the realization that we live in a power and money constrained world. Installing power infrastructure for a large scale supercomputer can cost upward of $10/Watt. A 10 Megawatt supercomputer would require about $100M in capital infrastructure - a sum that is prohibitive to all but a few users. 

It's worth noting the current version of Exascalar is simpler than the original version, which used a kind of circular distance in logarithmic space. A conversation with a colleague convinced me that a better approach would be to base Exascalar on the product of Efficiency*Performance. 

######_Exascalar est mort, vive Exascalar_  

####Why do I care? What can it do for me?
Exascalar allows visualization of the Top500 and Green500 lists on a single graph.

  *Highlights leading indicators of performance leadership   
  *Reveals highly inefficient systems in production (which should be [refreshed](http://www.datacenterknowledge.com/archives/2013/01/28/the-taxonomy-of-exascalar/) )   
  *Shows how the "power wall" limits the trend of performance of the overall population
  
Exascalar provides a simple numerical ranking based on combined leadership. 
  *The Top value is usally dominated by performance    
  *The Median value shows a trend of the "general population"    
   
Enables observations of technology trends


####What data do you use and where did you get it?
Data come from the Green500.org and the Top500.org websites.  
The program assumes the top500 lists are locally stored in a directory called "Exascalar" as .csv files in the sub-directories Top500 and Green500. These directories are clones in this repository.
  Green500.org lists are downloadable directly as .csv files from the Green500 website.
  Top500.org lists are stored on the Top500 site as .xls. Since this anlaysis assumes .csv I have converted them using numbers or Excel. 

Currently I have download files back to 2009.



Current available analyses
==========================

#####Exascalar_Cleaner.R
  This reads in the Top500 and Green500 lists, cleans the data, and creates data.frames with these descriptive names (for example)
  
   _Nov13_ - the combined Top500 and Green 500 list from November 2013  
    
   _Jun09_ - the combined Top500 and Green 500 list from June 2009  
    
  
The program saves the files in a foled called "results"

currently the data saved are:
 "exascalar"    "green500rank" "top500rank"   "rmax"         "power"        "mflopswatt"   "computer"

#####Exascalar_Trend.R 
  This program assumes the Green500 and Top500 lists have been already cleaned with Exascalar_Cleaner.R  
  
  It computes the top and mean exascalar values in a couple of different ways 
  
   1.  Plots the trend of the "top" exascalar.
   2.  finds the median exascalar system for a performance and efficiency number
   3.  computes an "effective" mean from the means of the Top500 (for performance) and Green500 (for efficiency)

  only 1 and 3 are plotted. 
  
 
  
#####Exascalar_PHI (*coming in 2014!*)
This program assumes the Green500 adn Top500 lists hae been already read nto memory (using Exascalar.R)

It finds the systems using Intel Xeon PHI and highlights them on the Exascalar graph

#####Exascalar_Xeon (*coming in 2014!*)
This program assumes the Green500 adn Top500 lists hae been already read nto memory (using Exascalar.R)

It finds the systems using Intel Xeon PHI and highlights them on the Exascalar graph
  
#####Exascalar_NVIDIA (*coming in 2014!*)
This program assumes the Green500 adn Top500 lists hae been already read nto memory (using Exascalar.R)

It finds the systems using NVIDIA GPUs and highlights them on the Exascalar graph
