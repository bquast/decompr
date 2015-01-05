---
layout: home
title: decompr, GVC decomposition in R
comments: true
tags: [Jekyll, theme, responsive, blog, template]
image:
  feature: shipping-sphere.jpg
---

The **decompr** package enables researchers working on Global Value Chains (GVCs) to derive different GVC indicators at a bilateral and sectoral level (e.g. Vertical Specialization, i.e. foreign value added in exports).

Specifically, the package applies two decomposition algorithms to Inter-Country Input-Output tables (ICIOs) such as the ones provided by [WIOD](http://www.wiod.org/new_site/home.htm) or [TiVA](http://oe.cd/tiva).

Firstly, the **Wang-Wei-Zhu** (Wang, Wei, and Zhu 2014) algorithm splits bilateral gross exports into 16 value added components,
depending on where they are finally consumed along three dimensions (source country, using industry, using country).
The algorithm is theoretically derived and explained in Wang, Wei, and Zhu (2014).
The main components are domestic value added in gross exports (DViX), foreign value added in gross exports (FVAX), and double counting terms that are misleading in official trade statistics.

Secondly, the **Leontief decomposition** algorithm derives the value added origin of an industry's exports by source country and source industry.
Therefore, it covers all four dimensions but at a lesser detail than the Wang-Wei-Zhu algorithm. It applies the basic Leontief insight to gross trade data.
A theoretical derivation can also be found in Wang, Wei, and Zhu (2014).

## CRAN
The **decompr** package is hosted on the [Comprehensive R Archive Network (CRAN)](http://cran.r-project.org/). There is a dedicated CRAN decompr page which can be accessed here:

[http://cran.r-project.org/web/packages/decompr/index.html](http://cran.r-project.org/web/packages/decompr/index.html)

## Citing

Citation information is included with the package. If you use decompr for data analysis, please cite R as well as decompr, using citation() and citation("decompr") respectively, or use the information below.

{% highlight r %}
citation("decompr")

To cite decompr in publications please use:

  Quast, B.A. and V. Kummritz (2015). decompr: Global Value Chain decomposition in R. CTEI Working Papers, 1.

A BibTeX entry for LaTeX users is

  @Article{,
    title = {decompr: Global Value Chain decomposition in R},
    author = {Bastiaan Quast and Victor Kummritz},
    organization = {The Graduate Institute},
    address = {Maison de la Paix, Geneva, Switzerland},
    year = {2015},
    journal = {CTEI Working Papers},
    number = {1},
    url = {http://qua.st/decompr},
  }

We have invested a lot of time and effort in creating decompr, please cite it when using it for data analysis.
See also 'citation()' for citing R.
{% endhighlight %}


# References
Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. "The World Input-Output Database (WIOD): Contents, Sources and Methods." *WIOD Background Document Available at www.Wiod.Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2014. "Quantifying International Production Sharing at the Bilateral and Sector Levels."