#' Interface function for decompositions
#' 
#' This function runs the decomposition
#' 
#' @param x the intermediate demand table, it has dimensions GN x GN (G = no. of country, N = no. of industries),
#'  excluding the first row and the first column which contains the country names,
#'  and the second row and second column which contain the industry names for each country.
#'  In addition, an extra row at the end should contain final demand.
#' @param y the final demand table it has dimensions GN x MN,
#'  excluding the first row and the first column which contains the country names,
#'  the second column which contains the industry names for each country,
#'  and second row which contains the five decomposed final demands (M).
#'  #' @param k is a vector of country of region names
#' @param i is a vector of sector or industry names
#' @param o is a vecotr of final outputs
#' @param method user specifies the decomposition method
#' @return The output when using the WWZ algorithm is a matrix with dimensions GNG*19.
#'  Whereby 19 is the 16 objects the WWZ algorithm decomposes exports into, plus three checksums.
#'  GNG represents source country, using industry and using country.
#' @author Bastiaan Quast
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods", WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
#' 
#' {Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. Quantifying international production sharing at the bilateral and sector levels. No. w19677. National Bureau of Economic Research, 2013.}
#' @export
#' @examples
#' # load World Input-Output Database for 2011
#' data(wiod)
#' 
#' # explore the data
#' dim(intermediate_demand) # (GN + totals) x (GN)
#' dim(final_demand)        # (GN + totals) x (G*5)
#' 
#' # use the direct approach
#' # run the WWZ decomposition
#' wwz <- decomp(intermediate_demand,
#'              final_demand,
#'              region_names,
#'              industry_names,
#'              output,
#'              method = "wwz"        )
#' wwz[1:5,1:5]
#' 
#' # run the Leontief decomposition
#' leontief  <- decomp(intermediate_demand,
#'                     final_demand,
#'                     region_names,
#'                     industry_names,
#'                     output,
#'                     method = "leontief"    )
#' leontief[1:5,1:5]


decomp <- function( x, y, k, i, o,  method=c("wwz", "leontief", "source" ) ) {
  
  method <- match.arg(method)
  
  if ( missing(k) ) {
    warning('argument k is missing, switching to the old "load_tables" function, which is DEPRECATED! Please see "help(decomp) and "http://qua.st/decompr/decompr-v2/" for more information on this.')
    decompr_obj <- load_tables(x, y)
  }  else {
    decompr_obj <- load_tables_vectors(x, y, k, i, o)
  }
  
  if (method == "wwz" ) {
    out <- wwz(     decompr_obj )
  } else if ( method == "leontief" ) {
    out <- leontief( decompr_obj )
  } else if ( method == "source" ) {
    warning('The "source" method has been renamed to "leontief" please use this method, "source" is now deprecated')
    out <- leontief( decompr_obj )
  } else {
    stop('not a valid method')
  }
  
  return(out)
  
}