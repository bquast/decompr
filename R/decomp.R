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
#' @param method user specifies the decomposition method
#' @return The output when using the WWZ algorithm is a matrix with dimensions GNG*19.
#'  Whereby 19 is the 16 objects the WWZ algorithm decomposes exports into, plus three checksums.
#'  GNG represents source country, using industry and using country.
#' @author Bastiaan Quast
#' @references Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu.
#'  Quantifying international production sharing at the bilateral and sector levels. 
#'  No. w19677. National Bureau of Economic Research, 2013.
#' @export
#' @examples
#' # load World Input-Output Database for 2011
#' data(wiod)
#' 
#' # explore the data
#' dim(intermediate_demand) # (2 + GN + totals) x (2 + GN)
#' dim(final_demand)        # (2 + GN + totals) x (2 + G*5)
#' intermediate_demand[1:40,1:40]
#' final_demand[1:40,1:10]
#' 
#' # use the direct approach
#' # run the WWZ decomposition
#' wwz <- decomp(intermediate_demand, final_demand, method='wwz')
#' wwz[1:5,1:5]
#' 
#' # run the source decomposition
#' source  <- decomp(intermediate_demand, final_demand, method='source')
#' source[1:5,1:5]


decomp <- function( x, y, method="wwz" ) {
  
  if (method == 'wwz') {
    out <- wwz( load_tables(x, y) )
  } else if (method == 'source' | method == 'kung_fu') {
    out <- kung_fu(load_tables(x, y) )
  } else {
    stop('not a valid method')
  }
  return(out)
}