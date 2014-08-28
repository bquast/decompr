[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.11470.png)](http://dx.doi.org/10.5281/zenodo.11470)

This page describes the R package decompr, which implements two export decomposition algorithms.
Firstly, the **Wang-Wei-Zhu** (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components.
Secondly, the **Source decomposition** algorithm derives the value added origin of exports by country and industry, which is also based on Wang, Wei, and Zhu (2013).

# Installation
You can install the latest **stable** version from CRAN.

{% highlight r linenos %}
install.packages('decompr')
{% endhighlight %}

You can install the latest **development** version from GitHub using the `devtools` package.

{% highlight r linenos %}
library(devtools)
install_github("bquast/decompr")
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
wwz <- decomp(intermediate_demand, final_demand, method='wwz')
wwz[1:5,1:5]

# run the source decomposition
source  <- decomp(intermediate_demand, final_demand, method='source')
kf[1:5,1:5]

# or use the step-by-step approach
# create intermediate object (class decompr)
decompr.object <- load_tables(intermediate_demand, final_demand)
str(decompr_object)

# run the WWZ decomposition on the decompr object
wwz <- wwz(decompr_object)
wwz[1:5,1:5]

# run the source decomposition on the decompr object
source  <- kung_fu(decompr_object)
source[1:5,1:5]
{% endhighlight %}

# Contribute
The development version is available on Github, in fact this page is the [gh-pages branch](https://github.com/bquast/decompr/tree/gh-pages) of the [**decompr** repository](https://github.com/bquast/decompr).

# References
Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. “The World Input-Output Database (WIOD): Contents, Sources and Methods.” *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”
