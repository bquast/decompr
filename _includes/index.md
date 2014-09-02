[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.11510.png)](http://dx.doi.org/10.5281/zenodo.11510)

This page describes the R package decompr, which implements two export decomposition algorithms.
Firstly, the **Wang-Wei-Zhu** (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components.
Secondly, the **Source decomposition** algorithm derives the value added origin of exports by country and industry, which is also based on Wang, Wei, and Zhu (2013).


# Installation
You can install the latest **stable** version from [CRAN](http://cran.r-project.org/web/packages/decompr/index.html).

{% highlight r linenos %}
install.packages("decompr")
{% endhighlight %}

You can install the latest **development** version from GitHub using the `devtools` package.

{% highlight r linenos %}
library(devtools)
install_github("decompr", "bquast")
{% endhighlight %}


# Usage
The usage is described in the R documentation included in the package. In addition...

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
