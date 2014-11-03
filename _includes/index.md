[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.11510.png)](http://dx.doi.org/10.5281/zenodo.11510)

This page describes the R package decompr. The package enables researchers working on Global Value Chains (GVCs) to derive different GVC indicators at a bilateral and sectoral level (e.g. Vertical Specialization, i.e. foreign value added in exports).

In detail, the package applies two decomposition algorithms to Inter-Country Input-Output tables (ICIOs) such as the ones provided by WIOD (http://www.wiod.org/new_site/home.htm) or TiVA (http://oe.cd/tiva). Firstly, the **Wang-Wei-Zhu** (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components depending on where they are finally consumed along three dimensions (source country, using industry, using country). The algorithm is theoretically derived and explained in Wang, Wei, and Zhu (2013). The main components are domestic value added in gross exports (DViX), foreign value added in gross exports (FVAX), and double counting terms that are misleading in official trade statistics. 
Secondly, the **Source decomposition** algorithm derives the value added origin of an industry’s exports by source country and source industry. Therefore, it covers all four dimensions but at a lesser detail than the Wang-Wei-Zhu algorithm. It applies the basic Leontief insight to gross trade data. A theoretical derivation can also be found in Wang, Wei, and Zhu (2013).

## CRAN
The **decompr** package is hosted on the [Comprehensive R Archive Network (CRAN)](http://cran.r-project.org/). There is a dedicated CRAN decompr page which can be accessed here:

http://cran.r-project.org/web/packages/decompr/index.html

## World Investment Forum 2014
The slides from the presentation at the World Investment Forum 2014 in Geneva are available [here in PDF format](https://github.com/bquast/decompr/blob/gh-pages/_includes/WIF-2014-10-15.pdf?raw=true).

# Authors
Bastiaan Quast (bastiaan.quast@graduateinstitute.ch)

Victor Kümmritz (victor.kummritz@graduateinstitute.ch)


# Installation
You can install the latest **stable** version from [CRAN](http://cran.r-project.org/web/packages/decompr/index.html).

{% highlight r linenos %}
install.packages("decompr")
{% endhighlight %}

In addition there is a video briefly expaining how to perform this in RStudio.

<iframe width="560" height="315" src="//www.youtube.com/embed/pdYJ2QjNiY8" frameborder="0" allowfullscreen></iframe>


You can install the latest **development** version from GitHub using the `devtools` package.

{% highlight r linenos %}
library(devtools)
install_github("decompr", "bquast")
{% endhighlight %}


# Usage
The usage is described in the R documentation included in the package.


{% highlight r linenos %}
# load the package
library(decompr)

# load World Input-Output Database for 2011
data(wiod)

# explore the data
dim(intermediate_demand) # (2 + GN + totals) x (2 + GN)
dim(final_demand)        # (2 + GN + totals) x (2 + G*5)
intermediate_demand[1:40,1:40]
final_demand[1:40,1:10]

# use the direct approach
# run the WWZ decomposition
wwz <- decomp(intermediate_demand,
              final_demand,
              method="wwz")
wwz[1:5,1:5]

# run the source decomposition
source  <- decomp(intermediate_demand,
                  final_demand,
                  method="source")
kf[1:5,1:5]

# or use the step-by-step approach
# create intermediate object (class decompr)
decompr.object <- load_tables(intermediate_demand,
                              final_demand)
str(decompr_object)

# run the WWZ decomposition on the decompr object
wwz <- wwz(decompr_object)
wwz[1:5,1:5]

# run the source decomposition on the decompr object
source  <- kung_fu(decompr_object)
source[1:5,1:5]
{% endhighlight %}

Below is an advanced example of looping the process and using the underlying functions to break the process into smaller steps. It is assumed that the data is stored in csv files.

{% highlight r linenos %}
## create a vector with the years
year <- c(1995, 2000, 2005, 2008)

## load the data

# run the loop once for every year
# i.e. the length of the vector
for (i in length(year) ) {
  
  # read the file names of the csv data
  inter.csv <- paste("WID", year[i], ".csv", sep="")
  final.csv <- paste("WFD", year[i], ".csv", sep="")
  
  # write the data to temporary objects
  inter.obj <- read.csv(inter.csv, header = FALSE, sep = ";")
  final.obj <- read.csv(final.csv, header = FALSE, sep = ";")
  
  # rename the temporary objects
  # include the year
  assign(paste("inter", year[i], sep=""), inter.obj )
  assign(paste("final", year[i], sep=""), final.obj )
}

## load the decompr package
library(decompr)

## construct a decompr object for each year
for (i in length(year) ) {
  
  # create object names from vector
  inter.obj <- paste("inter", year[i], sep="")
  final.obj <- paste("final", year[i], sep="")
  
  # construct the decompr object
  decompr.obj <- load_tables(inter.obj, final.obj)
  
  # rename the decompr object to include the year
  assign(paste("decompr", year[i], sep=""), decompr.obj )  
}

## perform the decomposition
for (i in length(year) ) {
  
  # create object names from vector
  decompr.obj <- paste("decompr", year[i], sep="")
  
  # run the WWZ decomposition
  wwz.obj <- wwz(decompr.obj)
  
  # rename the output object
  assign(paste("wwz", year[i], sep=""), wwz.obj )
}
{% endhighlight %}


# Contribute
The development version is available on Github, in fact this page is the [gh-pages branch](https://github.com/bquast/decompr/tree/gh-pages) of the [**decompr** repository](https://github.com/bquast/decompr).


# References
Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. “The World Input-Output Database (WIOD): Contents, Sources and Methods.” *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”

# Credits
The authors gratefully acknowledge funding from the SNF under the projects 135148 ”Production Sharing, Global Trade and Trade Governance”.
