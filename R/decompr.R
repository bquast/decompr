#' @name decompr
#' @docType package
#' @title Export Decomposition using the Wang-Wei-Zhu and source decompositions algorithms.
#' @author
#' Bastiaan Quast \email{bquast@@gmail.com}
#' Fei Wang
#' Victor Kummritz
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods", WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
#' 
#' {Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. Quantifying international production sharing at the bilateral and sector levels. No. w19677. National Bureau of Economic Research, 2013.}
NULL
#' @name final_demand
#' @docType data
#' @title World Input-Output Database 2011
#' @description the final demand data
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods",
#' WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
NULL
#' @name intermediate_demand
#' @docType data
#' @title World Input-Output Database 2011
#' @description the intermediate demand data
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods",
#' WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
NULL
#' @name region_names
#' @docType data
#' @title World Input-Output Database 2011
#' @description the names of the regions data
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods",
#' WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
NULL
#' @name industry_names
#' @docType data
#' @title World Input-Output Database 2011
#' @description the names of the industries data
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods",
#' WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
NULL
#' @name output
#' @docType data
#' @title World Input-Output Database 2011
#' @description final output
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods",
#' WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
NULL
#' @name final
#' @docType data
#' @title Leather Example
#' @description the final demand data
NULL
#' @name inter
#' @docType data
#' @title Leather Example
#' @description the intermediate demand data
NULL
#' @name countries
#' @docType data
#' @title Leather Example
#' @description the names of the countries data
NULL
#' @name industries
#' @docType data
#' @title Leather Example
#' @description the names of the industries data
NULL
#' @name out
#' @docType data
#' @title Leather Example
#' @description final output
NULL
.onAttach <- function(...) {
  packageStartupMessage('If you use decompr for data analysis,
please cite both R and decompr,
using citation() and citation("decompr") respectively.
                        
IMPORTANT changes to the decomp function defaults,
see help("decomp") and http://qua.st/decompr/decompr-v2/
')}
