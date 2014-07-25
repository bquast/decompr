#' @name decompr
#' @docType package
#' @title Export Decomposition using the Wang-Wei-Zhu and Kung-Fu algorithms.
#' @author
#' Bastiaan Quast \email{bquast@@gmail.com}
#' @references {Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. Quantifying international production sharing at the bilateral and sector levels. No. w19677. National Bureau of Economic Research, 2013.
#' 
#' Mehrotra, Rajiv, Fu K. Kung, and William I. Grosky. Industrial part recognition using a component-index. Image and Vision Computing 8, no. 3 (1990): 225-232.}
#' @examples
#' # load World Input-Output Database for 2011
#' data(wiod)
#' 
#' # explore the data
#' dim(intermediate.demand) # (2 + GN + totals) x (2 + GN)
#' dim(final.demand)        # (2 + GN + totals) x (2 + G*5)
#' intermediate.demand[1:40,1:40]
#' final.demand[1:40,1:10]
#' 
#' # use the direct approach
#' # run the WWZ decomposition
#' wwz <- decomp(intermediate.demand, final.demand, method='wwz')
#' wwz[1:5,1:5]
#' 
#' # run the Kung Fu decomposition
#' kf  <- decomp(intermediate.demand, final.demand, method='kung.fu')
#' kf[1:5,1:5]
NULL
#' @name final.demand
#' @docType data
#' @title World Input-Output Database 2011
#' @description the final demand data
#' @references {Marcel P. Timmer (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods",
#' WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
NULL
#' @name intermediate.demand
#' @docType data
#' @title World Input-Output Database 2011
#' @description the intermediate demand data
#' @references {Marcel P. Timmer (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods",
#' WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
NULL