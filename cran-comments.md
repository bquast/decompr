## Test environments

- Windows 7 R-3.2.0-x64
- OSX 10.10.3 R-3.2.0-x64
- Linux (Arch) R-3.1.3-x64
- Ubuntu (Travic-CI) R-3.2.0-x64
- Win-Builder  (devel and R-3.2.0-x64)


## Explanation early release

This release comes very quickly after the release of decompr v. 4.0.0.
There was a critical error in the new post-multiplication "final_demand" of the leontief() function.
I apologise for the inconvenience this causes the CRAN maintainers.


## R CMD check results
There were no ERRORs or WARNINGs. 

Status: 1 NOTE

Possibly mis-spelled words in DESCRIPTION:
  Leontief (6:59)
  Zhu (5:27, 5:47, 8:53, 9:34)
  decompositions (4:37)


The former two are names, the later is the plural of the noun: "decomposition".

All three are already present in the version currently on CRAN.
