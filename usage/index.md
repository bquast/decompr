---
layout: page
title: Usage
modified: 2015-01-04T13:03:02.362000+01:00
comments: true
image:
  feature: shipping-train.jpg
---

As mentioned, the package is written for the free software R ([website](http://www.r-project.org)). 
The download and installation guide can be found here for [Windows](http://cran.r-project.org/bin/windows/base) and [Mac](http://cran.r-project.org/bin/macosx).
In addition we recommend installing [RStudio](http://www.rstudio.com/products/rstudio/), which can be downloaded free of cost  [here](http://www.rstudio.com/products/rstudio/download/).

Once both programs are installed, you can install the latest **stable** version of decompr from [CRAN](http://cran.r-project.org/web/packages/decompr/index.html).

{% highlight r %}
install.packages("decompr")
{% endhighlight %}

Or alternatively the latest development version

{% highlight r %}
# install the devtools package (installs packages from github)
install.packages("devtools")

# load the devtools package
library(devtools)

# use the devtools package to the development version of decompr
install_github("bquast/decompr")
{% endhighlight %}


There is a video briefly expaining how to perform this in RStudio.

<iframe width="560" height="315" src="//www.youtube.com/watch?v=e5rKmukFZ8g" frameborder="0" allowfullscreen></iframe>

Now that the package is installed, we can proceed with loading the application and opening the help file for information.

{% highlight r %}
# load the package
library(decompr)

# open the help file
help(decompr)
{% endhighlight %}

In the following example, we use a fictional dataset (leather data) to illustrate the necessary commands for decomposing
input-output tables. Alternatively, it is possible to use any other available inter-country input-output table (ICIO). 
To this end, it is necessary to split the new input-output table into five separate files (for example using excel) and load them into R. 
The five files are output (a file with only the output values of the countries and industries), 
countries (a list of countries included in the IO table), 
industries (a list of industries included in the IO table), 
intermediate demand (the part of the IO table stating the flows between industries), 
and final demand (the part of the IO table stating the industries' production values for final demand). 
It is important that the last two files only include values but no countries or industries.

{% highlight r %}
# load leather example data
data(leather)

# explore the data
inter
final
countries
industries
out

# use the direct approach
# run the WWZ decomposition
wwz <- decomp(inter,
             final,
             countries,
             industries,
             out,
             method = "wwz")
wwz[1:5,1:5]

# run the Leontief decomposition
leontief  <- decomp(inter,
                    final,
                    countries,
                    industries,
                    out,
                    method = "leontief")
leontief
{% endhighlight %}

If need be, the results can now be exported to a file format that can be processed by other data processing software such as Stata or simply Excel. Below you find an example for exporting the output to basic .csv files.

{% highlight r %}
# write the results of WWZ to a csv file
write.csv(w, file="wwz.csv")

# write the results of Leontief to a csv file
write.csv(lt, file="leontief.csv")
{% endhighlight %}

This YouTube videos gives a brief overwiew into the usage of the package as coded above.

<iframe width="560" height="315" src="//www.youtube.com/embed/hg6TyqapYtc" frameborder="0" allowfullscreen></iframe>

The usage is also described in the R documentation included in the package.

In addition, the contruction of the arrays and computations can be done separately using the atomic functions.

{% highlight r %}
# load leather example data
data(leather)

# create intermediate object (class decompr)
decompr_object <- load_tables_vectors(inter,
                                      final,
                                      countries,
                                      industries,
                                      out        )
str(decompr_object)

# run the WWZ decomposition on the decompr object
w  <- wwz(decompr_object)
w[1:5,1:5]
View(w)

# run the Leontief decomposition on the decompr object
lt  <- leontief(decompr_object)
lt
{% endhighlight %}


Below is an advanced example of looping the process and using the underlying functions to break the process into smaller steps. It is assumed that the data is stored in csv files.

{% highlight r %}
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
