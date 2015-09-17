# Visualizing change: Top500, Green500, and Exascalar
Winston Saunders  
August 02, 2015  

###Comparing November and June 2014 Green500 and Top500

The [Exascalar](http://www.datacenterknowledge.com/archives/2012/07/10/june-2012-exascalar-efficiency-dominates-hpc/) analysis is one of the best ways to visualize changes in the efficiency and perforance (as measured by the [Green500](http:\\green500.org) and [Top500](http:\\top500.org) lists, respctively) since it compares both metrics in one common analysis. 

In this case the analysis is especially revealing: while the #1 supercomputer in the Top500 has not changed in the last five publications of the lists, the population of the Green500 list has been far from stagnant. Since historically efficiency leadership has prediated performance leadership, the analysis allows us to "look ahead" to understand high perfomrance systems of the future. 





### Exascalar Plot 

The easiest way to visualize change in the Top500 and Green500 lists is to overlay the Exascalar plots of November 2014 with that of June 2014.  

In the plot below points from November are smaller red dots, points with empty blue circles are computers that are no longer on the list, and red points with blue circles around them are computers on both lists. Changes are clearly visible. While the highestperformance computer did not change, changes within the population as well as at the extremes o efficiency are evident.   

<img src="Exascalar_Visualization_July_2015_files/figure-html/unnamed-chunk-2-1.png" title="" alt="" style="display: block; margin: auto;" />

####KPI's: Bounding the November 2014 Supercomputer Population

Since Exascalar, as visulaized by above, is mostly descriptive of the _population_ of supercomputers, it's interesting to understand the parameters of the population as these comprise some of the more interesting computers from the list. These Key Performance Indicators of the population are listed below.  

It is worthwhile to note that the highest Exascalar, lowest Exascalar, and Lowest Power system describe, roughly, the "vertices"" of the triangular shape of the population, while the highest power, lowest performance and highest efficiency roughly bound the "sides"" of the triangle.  
 



<!-- html table generated in R 3.2.1 by xtable 1.7-4 package -->
<!-- Sun Aug  9 22:39:50 2015 -->
<table border=1>
<tr> <th>  </th> <th> ExaRank </th> <th> exascalar </th> <th> green500rank </th> <th> top500rank </th> <th> rmax </th> <th> power </th> <th> mflopswatt </th>  </tr>
  <tr> <td align="right"> Top Performance </td> <td align="right">   1 </td> <td align="right"> -2.04 </td> <td align="right">  83 </td> <td align="right">   1 </td> <td align="right"> 33862700 </td> <td align="right"> 17808.00 </td> <td align="right"> 1901.54 </td> </tr>
  <tr> <td align="right"> Top Efficiency </td> <td align="right">  27 </td> <td align="right"> -3.00 </td> <td align="right">   1 </td> <td align="right"> 160 </td> <td align="right"> 412674 </td> <td align="right"> 50.32 </td> <td align="right"> 7031.58 </td> </tr>
  <tr> <td align="right"> Highest Power </td> <td align="right"> 194 </td> <td align="right"> -3.68 </td> <td align="right">  78 </td> <td align="right"> 497 </td> <td align="right"> 165887 </td> <td align="right"> 19431.30 </td> <td align="right"> 1906.75 </td> </tr>
  <tr> <td align="right"> Lowest Performance </td> <td align="right"> 457 </td> <td align="right"> -4.39 </td> <td align="right"> 408 </td> <td align="right"> 500 </td> <td align="right"> 164791 </td> <td align="right"> 887.10 </td> <td align="right"> 185.76 </td> </tr>
  <tr> <td align="right"> Lowest Efficiency </td> <td align="right"> 500 </td> <td align="right"> -5.04 </td> <td align="right"> 500 </td> <td align="right"> 475 </td> <td align="right"> 168600 </td> <td align="right"> 7625.82 </td> <td align="right"> 22.11 </td> </tr>
  <tr> <td align="right"> Lowest Power </td> <td align="right">  66 </td> <td align="right"> -3.24 </td> <td align="right">   2 </td> <td align="right"> 392 </td> <td align="right"> 193913 </td> <td align="right"> 28.25 </td> <td align="right"> 6842.33 </td> </tr>
  <tr> <td align="right"> Highest Exascalar </td> <td align="right">   1 </td> <td align="right"> -2.04 </td> <td align="right">  83 </td> <td align="right">   1 </td> <td align="right"> 33862700 </td> <td align="right"> 17808.00 </td> <td align="right"> 1901.54 </td> </tr>
  <tr> <td align="right"> Lowest Exascalar </td> <td align="right"> 500 </td> <td align="right"> -5.04 </td> <td align="right"> 500 </td> <td align="right"> 475 </td> <td align="right"> 168600 </td> <td align="right"> 7625.82 </td> <td align="right"> 22.11 </td> </tr>
   </table>



####KPI's for the Population of New Entrants

Of the _new_ entrants its interesting to note the same parameters as above as a kind of bound on the population of the newest systems. It's interesting to note in this particular year new systems occupy both the highest and lowest efficiency. 




The median Exascalar of the New Computers is -3.47 compared to the median of all computers on the June 2015 list -3.84 and the November 2014 list -3.99.


<style>

table { 
    display: table;
    border-collapse: collapse;
    border-spacing: 10px;
    border-color: gray;
    background-color: #a1b2c3;
    text-align: center
    font: 12px arial, sans-serif;
}
th, td {
    
    padding: 5px;
}
</style>


<!-- html table generated in R 3.2.1 by xtable 1.7-4 package -->
<!-- Sun Aug  9 22:39:50 2015 -->
<table border=1>
<tr> <th>  </th> <th> ExaRank </th> <th> exascalar </th> <th> green500rank </th> <th> top500rank </th> <th> rmax </th> <th> power </th> <th> mflopswatt </th>  </tr>
  <tr> <td align="right"> Top Performance </td> <td align="right">   5 </td> <td align="right"> -2.49 </td> <td align="right">  13 </td> <td align="right">   6 </td> <td align="right"> 6271000 </td> <td align="right"> 2325.00 </td> <td align="right"> 2403.01 </td> </tr>
  <tr> <td align="right"> Top Efficiency </td> <td align="right">  27 </td> <td align="right"> -3.00 </td> <td align="right">   1 </td> <td align="right"> 160 </td> <td align="right"> 412674 </td> <td align="right"> 50.32 </td> <td align="right"> 7031.58 </td> </tr>
  <tr> <td align="right"> Highest Power </td> <td align="right"> 194 </td> <td align="right"> -3.68 </td> <td align="right">  78 </td> <td align="right"> 497 </td> <td align="right"> 165887 </td> <td align="right"> 19431.30 </td> <td align="right"> 1906.75 </td> </tr>
  <tr> <td align="right"> Lowest Performance </td> <td align="right"> 194 </td> <td align="right"> -3.68 </td> <td align="right">  78 </td> <td align="right"> 497 </td> <td align="right"> 165887 </td> <td align="right"> 19431.30 </td> <td align="right"> 1906.75 </td> </tr>
  <tr> <td align="right"> Lowest Efficiency </td> <td align="right"> 485 </td> <td align="right"> -4.50 </td> <td align="right"> 487 </td> <td align="right"> 337 </td> <td align="right"> 218407 </td> <td align="right"> 2217.60 </td> <td align="right"> 98.49 </td> </tr>
  <tr> <td align="right"> Lowest Power </td> <td align="right">  66 </td> <td align="right"> -3.24 </td> <td align="right">   2 </td> <td align="right"> 392 </td> <td align="right"> 193913 </td> <td align="right"> 28.25 </td> <td align="right"> 6842.33 </td> </tr>
  <tr> <td align="right"> Highest Exascalar </td> <td align="right">   5 </td> <td align="right"> -2.49 </td> <td align="right">  13 </td> <td align="right">   6 </td> <td align="right"> 6271000 </td> <td align="right"> 2325.00 </td> <td align="right"> 2403.01 </td> </tr>
  <tr> <td align="right"> Lowest Exascalar </td> <td align="right"> 485 </td> <td align="right"> -4.50 </td> <td align="right"> 487 </td> <td align="right"> 337 </td> <td align="right"> 218407 </td> <td align="right"> 2217.60 </td> <td align="right"> 98.49 </td> </tr>
   </table>







