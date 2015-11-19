---
layout: post
title: decompr  on CRAN
author: Bastiaan_Quast
permalink: decompr-cran
comments: true
---

We are proud to announce that after a few emails back and forth with [Prof. Brian Ripley](http://en.wikipedia.org/wiki/Brian_D._Ripley), which consisted mostly of us appologising for not following the proper procedure for submission, I received an email announing that my [decompr package](http://qua.st/decompr) is now [available on CRAN](http://cran.r-project.org/web/packages/decompr/index.html).

The package can now easily be installed using:

{% highlight r linenos %}
install.packages("decompr")
{% endhighlight %}

The version published contains several updates, most importantly, I used a [regional input-output table](http://www.wiod.org/new_site/database/riots.htm) from the [WIOD project](http://www.wiod.org/), which is substantially smaller and makes the decompositions significantly faster (**EDIT:** the wiod data is now a separate data package, install using `install.packages("wiod")`, see [this post](/wiod).

I will continue to update the package, the first priority is to improve the linear algebra so that decomposition will be less time consuming.

The **development** version, to be used **at your peril**, can be installed from [GitHub](http://github.com/bquast/decompr) using the `devtools` package.

{% highlight r linenos %}
if (!require('devtools')) install.packages('devtools')
devtools::install_github("bquast/decompr")
{% endhighlight %}

For more information on usage, please the help files.

Following installation, the package can be loaded using:

```r
library(decompr)
```

For general information on using the package, please refer to the help files.

```r
help("decompr")
help(package="decompr")
```

For examples of usage, see the function specific help pages, in particular the `decomp()` function.

```r
help("decomp")
help("leontief")
help("wwz")
help("load_tables_vectors")
```

In addition to the help files we provide a long form example in a [vignette](http://cran.r-project.org/web/packages/decompr/vignettes/decompr.html) .

```r
vignette("decompr")
```


Additional Information
-----------------------

An overview of the changes is available in the NEWS file.

```r
news(package="decompr")
```

As well as [this previous post](/decompr/decompr-package).

[![CRAN Version](http://www.r-pkg.org/badges/version/decompr)](http://cran.r-project.org/package=decompr)
[![RStudio Cloud Downloads](http://cranlogs.r-pkg.org/badges/decompr?color=brightgreen)](http://cran.rstudio.com/web/packages/decompr/index.html)


Credit
------

This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.

References
----------

Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. “The World Input-Output Database (WIOD): Contents, Sources and Methods.” *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”
