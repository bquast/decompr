decompr
=======
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.14810.png)](http://dx.doi.org/10.5281/zenodo.14810)
[![Travis-CI Build Status](https://travis-ci.org/bquast/decompr.png?branch=master)](https://travis-ci.org/bquast/decompr)
[![Coverage Status](https://coveralls.io/repos/bquast/decompr/badge.svg?branch=master)](https://coveralls.io/r/bquast/decompr?branch=master)

Bastiaan Quast, <bquast@gmail.com>
----------------------------------
Two Global Value Chains decompositions are implemented.
Firstly, the Wang-Wei-Zhu (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components.
Secondly, the Leontief decomposition (default) derives the value added origin of exports by country and industry, which is also based on Wang, Wei, and Zhu (2013).


Installation
------------
You can install the latest **stable** version from CRAN.

```r
install.packages("decompr")
```

You can install the latest **development** version from GitHub using the `devtools` package.

```r
if (!require('devtools')) install.packages('devtools')
devtools::install_github("bquast/decompr", build_vignettes=TRUE)
```


Usage
------
Please read the included documentation, specifically of the `decomp` function.

```r
library(decompr)
vignette("decomp")

```


Credit
------

This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.


References
----------

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”
