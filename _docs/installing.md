---
layout: single
title: Installing
modified: 2016-09-20
permalink: /installing/
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
