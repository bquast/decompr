[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.11431.png)](http://dx.doi.org/10.5281/zenodo.11431)

decompr
=======

Bastiaan Quast, <bquast@gmail.com>
----------------------------------

An R package that implements Export Decomposition using the Wang-Wei-Zhu (Wang, Wei, and Zhu 2013) and Kung-Fu (Mehrotra, Kung, and Grosky 1990) algorithms.


Inputs
------

The package uses Inter-Country Input-Output (ICIO) tables, such as World Input Outpt Database (Timmer et al. 2012).

The **x** argument is intermediate demand table, where the first row and the first column list the country names, the second row and second column list the insdustry names for each country. The matrix is presumed to be of dimensions **GxN** where **G** represents the country and **N** the industry. No extra columns should be there. Extra rows at the bottom which list adjustments such as taxes as well are disregarded, with the exception that the very last row is presumed to contain the total output.

The **y** argument is the final demand table it has dimensions **GNxGM** ( where **M** is the number of objects final demand is decomposed in, e.g. household consumption, here this is five decompositions).


Output
------

The output when using the WWZ algorithm is a matrix with dimensions **GNGx19**. Whereby **19** is the **16** objects the WWZ algorithm decomposes exports into, plus three checksums. **GNG** represents source country, using industry and using country.


Installation
------------
You can install the latest development version from GitHub using the `devtools` package.

```r
# install.packages("devtools")
devtools::install_github("bquast/decompr")
```


Usage
------
Please read the included documentation, specifically of the `decomp` function.

```r
library(decompr)
?decomp
```


Credit
------

This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.


References
----------

Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. “The World Input-Output Database (WIOD): Contents, Sources and Methods.” *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”
