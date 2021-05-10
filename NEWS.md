decompr 5.2.0
=======================

* documentation redone


decompr 4.5.0
=======================

* code refactoring\

* added v


decompr 4.1.0
=======================

* fix post multiplication "final_demand" of leontief()


decompr 4.0.0
=======================

* add post-multiplication argument to leontief method

* remove leontief_output(), functionality moved to leontief()

* use ellipsis for decomp function


decompr 3.0.0
=======================

* remove vertical_specialisation and vertical_specialization, will be included in gvc package

* add some attributes to output t.b. used by gvc package

* change the output format of leontief and leontief-output to long form (tidy data)

* add columns country and sectors names

* add DViX_Fsr to wwz

* add Vignette (decompr)

* add tests

* add Travis-CI support

* add coveralls.io support


decompr 2.1.0
=======================

* add a leontief_output decomposition method

* update the README.md file

* add warning when no method is specified in decomp (default is Leontief as of v.2)


decompr 2.0.0
=======================

* make load_tables_vectors default

* change notice to reflect new default

* update examples and data to reflect lt

* replace use of 2 dimensional arrays with matrices

* more efficient construction of rownam and z1

* replace use of length(k) with G

* replace use of various inefficient uses of diag() (e.g. with Vhat)

* improved spacing of code for legibility

* make leontief default method


decompr 1.3.2
=======================

* add notice


decompr 1.3.1
=======================

* fix citations etc.


decompr 1.3.0
=======================

* add load_tables_vectors to input in simple form


decompr 1.2.1
=======================

* update authors


decompr 1.2.0
=======================

* update citation code

* use " in stead of ' in examples and function arguments

* use match.arg for method in decomp function


decompr 1.1.0
=======================

* update references

* include more descriptive description


decompr 1.0.2
=======================

* update example data to regional tables for faster computations

* put back examples for non-decomp functions


decompr 1.0.1
=======================

* remove examples other than for **decomp** function, to pass CRAN test in time

* add cran-comments.md


decompr 1.0.0
=======================

* functions names use underscores in stead of periods

* method names use underscores in stead of periods

* examples reflect the above changes

* WIOD data set is now compressed using bzip2

* included this news file


decompr 0.7.0
=======================

* citation information is included


decompr 0.6.0
=======================

* example data set in included


decompr 0.5.0
=======================

* examples are included
