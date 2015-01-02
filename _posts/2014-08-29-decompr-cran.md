---
layout: post
title: decompr  on CRAN
permalink: decompr-cran
comments: true
---

We are proud to announce that after a few emails back and forth with [Prof. Brian Ripley](http://en.wikipedia.org/wiki/Brian_D._Ripley), which consisted mostly of us appologising for not following the proper procedure for submission, I received an email announing that my [decompr package](http://qua.st/decompr) is now [available on CRAN](http://cran.r-project.org/web/packages/decompr/index.html).

The package can now easily be installed using:

{% highlight r linenos %}
install.packages("decompr")
{% endhighlight %}

The version published contains several updates, most importantly, I used a [regional input-output table](http://www.wiod.org/new_site/database/riots.htm) from the [WIOD project](http://www.wiod.org/), which is substantially smaller and makes the decompositions significantly faster.

I will continue to update the package, the first priority is to improve the linear algebra so that decomposition will be less time consuming.

You can install the latest **development** version from GitHub using the `devtools` package.

{% highlight r linenos %}
library(devtools)
install_github("decompr", "bquast")
{% endhighlight %}


Credit
------

This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.

References
----------

Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. “The World Input-Output Database (WIOD): Contents, Sources and Methods.” *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”
