[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.12810.png)](http://dx.doi.org/10.5281/zenodo.12810)

decompr
=======

Bastiaan Quast, <bquast@gmail.com>
----------------------------------

The R package 'decompr' implements two export decomposition algorithms.
Firstly, the Wang-Wei-Zhu (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components.
Secondly, the Source decomposition algorithm derives the value added origin of exports by country and industry, which is also based on Wang, Wei, and Zhu (2013).


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
You can install the latest **stable** version from CRAN.

```r
install.packages("decompr")
```

You can install the latest **development** version from GitHub using the `devtools` package.

```r
library(devtools)
install_github("decompr", "bquast")
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
