decompr
=======
[![License](http://img.shields.io/badge/license-GPLv3-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)
[![CRAN Version](http://www.r-pkg.org/badges/version/decompr)](https://cran.r-project.org/package=decompr)
[![Total RStudio Cloud Downloads](http://cranlogs.r-pkg.org/badges/grand-total/decompr?color=brightgreen)](https://cran.r-project.org/package=decompr)
[![Monthly RStudio Cloud Downloads](http://cranlogs.r-pkg.org/badges/decompr?color=brightgreen)](https://cran.r-project.org/package=decompr)
[![Travis-CI Build Status](https://travis-ci.org/bquast/decompr.png?branch=master)](https://travis-ci.org/bquast/decompr)
[![Coverage Status](https://coveralls.io/repos/bquast/decompr/badge.svg?branch=master)](https://coveralls.io/r/bquast/decompr?branch=master)

Bastiaan Quast, <bquast@gmail.com>
----------------------------------
Two Global Value Chains decompositions are implemented.
Firstly, the Wang, Wei, and Zhu (2013) <DOI:10.3386/w19677> algorithm splits bilateral gross exports into 16 value added components.
Secondly, the Leontief decomposition (default) derives the value added origin of exports by country and industry, see Leontief (1937) <DOI:10.2307/1927837>.

Additional tools for GVC analysis are available in the [gvc package](http://cran.r-project.org/package=gvc).


Installation
------------
You can install the latest **stable** version from [CRAN](http://cran.r-project.org/package=decompr).

```r
install.packages("decompr")
```

The **development** version, to be used **at your peril**, can be installed from [GitHub](http://github.com/bquast/decompr) using the `devtools` package.

```r
if (!require('devtools')) install.packages('devtools')
devtools::install_github("bquast/decompr")
```


Usage
-------------

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

There is a dedicated website with information hosted on my [personal website](http://qua.st/).

http://qua.st/decompr


Development
-------------
Development takes place on the GitHub page.

http://github.com/bquast/decompr

Bugs can be filed on the issues page on GitHub.

https://github.com/bquast/decompr/issues


Credit
---------

The Wang-Wei-Zhu algorithm (`wwz()`)is based on R code written by Fei Wang
(not to be confused with the author of the algorithm, with the same last name),
which implemented this algorithm.
