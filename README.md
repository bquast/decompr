decompr
=======
[![License](http://img.shields.io/badge/license-GPLv3-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)
[![CRAN Version](http://www.r-pkg.org/badges/version/decompr)](https://cran.r-project.org/package=decompr)
[![R build status](https://github.com/bquast/decompr/workflows/R-CMD-check/badge.svg)](https://github.com/bquast/decompr/actions?workflow=R-CMD-check)
[![Coverage status](https://codecov.io/gh/bquast/decompr/branch/master/graph/badge.svg?token=eKinPv6wxA)](https://app.codecov.io/gh/bquast/decompr)
[![Total RStudio Cloud Downloads](http://cranlogs.r-pkg.org/badges/grand-total/decompr?color=brightgreen)](https://cran.r-project.org/package=decompr)
[![Monthly RStudio Cloud Downloads](http://cranlogs.r-pkg.org/badges/decompr?color=brightgreen)](https://cran.r-project.org/package=decompr)


Demonstration
---------------
![decompr GUI demonstration](https://github.com/bquast/R-demo-GIFs/blob/master/decompr.gif)

Description
---------------
Two Global Value Chains decompositions are implemented.
Firstly, the Wang, Wei, and Zhu (2013) algorithm splits bilateral gross exports into 16 value added components.
Secondly, the Leontief decomposition (default) derives the value added origin of exports by country and industry, see Leontief (1937).

Additional tools for GVC analysis are available in the [gvc package](https://cran.r-project.org/package=gvc).


Installation
------------
You can install the latest **stable** version from [CRAN](https://cran.r-project.org/package=decompr).

```r
install.packages('decompr')
```

The **development** version, to be used **at your peril**, can be installed from [GitHub](https://github.com/bquast/decompr) using the `devtools` package.

```r
if (!require('remotes')) install.packages('remotes')
remotes::install_github('bquast/decompr')
```


Usage
-------------

Following installation, the package can be loaded using:

```r
library(decompr)
```

For general information on using the package, please refer to the help files.

```r
help('decompr')
help(package='decompr')
```

For examples of usage, see the function specific help pages, in particular the `decomp()` function.

```r
help('decomp')
help('leontief')
help('wwz')
help('load_tables_vectors')
```

In addition to the help files we provide a long form example in a vignette:

```r
vignette('decompr')
```


Additional Information
-----------------------

An overview of the changes is available in the NEWS file.

```r
news(package='decompr')
```

There is a dedicated website with information hosted on my [personal website](https://qua.st/).

https://qua.st/decompr/


Development
-------------
Development takes place on the GitHub page.

https://github.com/bquast/decompr

Bugs can be filed on the issues page on GitHub.

https://github.com/bquast/decompr/issues


Credit
---------

The Wang-Wei-Zhu algorithm (`wwz()`)is based on R code written by Fei Wang
(not to be confused with the author of the algorithm, with the same last name),
which implemented this algorithm.
