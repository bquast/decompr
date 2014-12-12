---
layout: page
title: Examples
modified: 2014-12-12T15:23:02.362000+01:00
image:
  feature: shipping-train.jpg
---

The usage is described in the R documentation included in the package.

{% highlight r linenos %}
# load the package
library(decompr)

# open the help file
help(decompr)
{% endhighlight %}

{% highlight r linenos %}
# load oil example data
data(oil)

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

In addition, the contruction of the arrays and computations can be done separately using the atomic functions.

{% highlight r linenos %}
# load oil example data
data(oil)

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

# run the Leontief decomposition on the decompr object
lt  <- leontief(decompr_object)
lt
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
