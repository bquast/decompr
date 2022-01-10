#' @name decompr-package
#' @docType package
#' @title Global Value Chain Decomposition
#' @author
#' Bastiaan Quast \email{bquast@@gmail.com}\cr
#' Fei Wang\cr
#' Victor Stolzenburg\cr
#' Sebastian Krantz
#' @description Three global value chain (GVC) decompositions are implemented. The Leontief decomposition 
#' derives the value added origin of exports by country and industry as in Hummels, Ishii and Yi (2001). 
#' The Koopman, Wang and Wei (2014) decomposition splits country-level exports into 9 value added components, 
#' and the Wang, Wei and Zhu (2013) decomposition splits bilateral exports into 16 value added components. 
#' Various GVC indicators based on these decompositions are computed in the complimentary 'gvc' package. 
#' 
#' @section Contents:
#' Interface function for quick analysis
#'
#' \code{\link[=decomp]{decomp()}}
#'
#' Function to load ICIO table and create a 'decompr' object
#'
#' \code{\link[=load_tables_vectors]{load_tables_vectors()}}
#'
#' Functions to perform GVC decompositions on a 'decompr' object
#'
#' \code{\link[=leontief]{leontief()}}\cr
#' \code{\link[=kww]{kww()}}\cr
#' \code{\link[=wwz]{wwz()}}
#'
#' Function to obtain KWW decomposition from WWZ decomposition
#'
#' \code{\link[=wwz2kww]{wwz2kww()}}
#'
#' Example ICIO data
#'
#' \code{\link[=leather]{data("leather")}}
#'
#' @seealso https://qua.st/decompr/
#' @references 
#' Hummels, D., Ishii, J., & Yi, K. M. (2001). The nature and growth of vertical specialization in world trade. \emph{Journal of international Economics, 54}(1), 75-96.
#' 
#' Koopman, R., Wang, Z., & Wei, S. J. (2014). Tracing value-added and double counting in gross exports. \emph{American Economic Review, 104}(2), 459-94.
#' 
#' Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu (2013). Quantifying international production sharing at the bilateral and sector levels (No. w19677). \emph{National Bureau of Economic Research}.
#' @importFrom stats setNames
#' @importFrom matrixStats rowSums2 colSums2 x_OP_y
#' @useDynLib decompr, .registration = TRUE
NULL

#' @name leather
#' @docType data
#' @title Leather Example ICIO Data
#' @description An example 3 x 3 ICIO table describing a GVC for leather products with industries 'Agriculture', 'Textile and Leather' and 'Transport Equipment'
#' for the countries 'Argentina', 'Turkey' and 'Germany'. 
#' @usage data("leather")
#'  
#' @format A list of class 'iot' with the following elements:
#' \describe{
#'  \item{\code{inter}}{9 x 9 input output matrix where each column gives the value of inputs supplied to the corresponding country-industry by each row country-industry.}
#'  \item{\code{final}}{9 x 3 final demand matrix showing the final demand in each country (column) for each country-industry's (rows) produce.}
#'  \item{\code{countries}}{character vector of country names (matching columns of \code{final}).}
#'  \item{\code{industries}}{character vector of industries, such that \code{as.vector(t(outer(countries, industries, FUN = paste, sep = ".")))} generates the row- and column-names of \code{inter} and the rownames of \code{final}.}
#'  \item{\code{out}}{A vector of gross country-industry output. In a complete productive system it should be equal to \code{rowSums(inter) + rowSums(final)}.}
#' }
#' @seealso \code{\link{decompr-package}}
NULL
.onAttach <- function(...) {
  packageStartupMessage("Please consider citing R and decompr,
using citation()
citation('decompr')
")}
