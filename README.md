decompr
======================================
Bastiaan Quast, bquast@gmail.com
--------------------------------------
An R package that implements Export Decomposition using the Wang-Wei-Zhu algorithm. 

Description
--------------------------------------
Export Decomposition using the Wang-Wei-Zhu algorithm

Inputs
--------------------------------------
The package uses Inter-Country Input-Output (ICIO) tables, such as World Input Outpt Database (WIOD).

The IOA object is intermediate demand table, where the first row and the first column list the country names, the second row and second column list the insdustry names for each country. The matrix is presumed to be of dimensions G*N where G represents the country and N the industry. No extra columns should be there. Extra rows at the bottom which list adjustments such as taxes as well are disregarded, with the exception that the very last row is presumed to contain the total output.

WFD is the final demand object it has dimensions GN*GM ( where M is the number of objects final demand is decomposed in, e.g. household consumption, here this is five decompositions).

Output
--------------------------------------
The output is a matrix with dimensions GNG*19. Whereby 19 is the 16 objects the WWZ algorithm decomposes exports into, plus three checksums. GNG represents source country, using industry and using country.


Installation
--------------------------------------
**WARNING**, ExDecompR is in an extremely early stage of development.

```R
# install.packages("devtools")
devtools::install_github("bquast/ExDecompR")
```


Usage
--------------------------------------
```R
# load the package
library(ExDecompR)

# read the csv files
inter <- read.csv('WID1995.csv')
final <- read.csv('WFD1995.csv')

# construct the intermediate file
inter.obj <- load.demand(inter, final)

# run the kung fu decomposition
kf <- kung.fu(inter.obj)

# run WWZ decomposition
wwz <- decomp(inter.obj)
```

TODO
--------------------------------------
The most import TODO items (in order of importance) are:

- [x] Remove use of windows-only **clipboard** function
- [x] Remove use of multi-year functionality (this should be user implemented)
- [x] Remove hard-coded dimensions
- [x] change inputs and outputs to R objects in stead of files
- [x] implement as a function for reading the matrices and a function for decomposing
- [x] minimalise inputs by computing final demand (and others?)
- [ ] add checks on data (intermediate demand sums)
- [ ] implement S4 class
- [ ] replace use of attacch()
- [ ] provide documentation and examples
- [ ] review linear algebra for efficiency

Credit
--------------------------------------
This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.
