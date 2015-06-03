## Test environments

- Windows 7 R-3.2.0-x64
- OSX 10.10.3 R-3.2.0-x64
- Linux (Arch) R-3.1.3-x64
- Ubuntu (Travic-CI) R-3.2.0-x64
- Win-Builder  (devel and R-3.2.0-x64)

## R CMD check results
There were no ERRORs or WARNINGs. 

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Bastiaan Quast <bquast@gmail.com>'

Possibly mis-spelled words in DESCRIPTION:
  Leontief (3:60, 6:59)
  Zhu (3:52, 5:27, 5:47, 8:53)
  decompositions (4:38)

* checking package dependencies ... NOTE
  No repository set, so cyclic dependency check skipped

Regarding the spelling, the first two are names, the last one is the plural of decomposition.

All three are already present in the version currently on CRAN.
