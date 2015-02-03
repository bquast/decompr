[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.14810.png)](http://dx.doi.org/10.5281/zenodo.14810)

decompr
=======

Bastiaan Quast, <bquast@gmail.com>
----------------------------------

Two Global Value Chains decompositions are implemented.
Firstly, the Wang-Wei-Zhu (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components.
Secondly, the Leontief decomposition (default) derives the value added origin of exports by country and industry, which is also based on Wang, Wei, and Zhu (2013).


The R package 'decompr' implements two export decomposition algorithms.
Firstly, the Wang-Wei-Zhu (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components.
Secondly, the Source decomposition algorithm derives the value added origin of exports by country and industry, which is also based on Wang, Wei, and Zhu (2013).



Installation
------------
You can install the latest **stable** version from CRAN.

```r
install.packages("decompr")
```

You can install the latest **development** version from GitHub using the `devtools` package.

```r
library(devtools)
devtools::install_github("decompr", "bquast")
```


Usage
------
Please read the included documentation, specifically of the `decomp` function.

```r
library(decompr)
help("decomp")"
```


Credit
------

This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.


References
----------

Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. “The World Input-Output Database (WIOD): Contents, Sources and Methods.” *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”
