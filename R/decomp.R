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
#'  
#'  Mehrotra, Rajiv, Fu K. Kung, and William I. Grosky.
#'  "Industrial part recognition using a component-index."
#'  Image and Vision Computing 8, no. 3 (1990): 225-232.
#' @export


decomp <- function( x, y, method="wwz" ) {
  
  if (method == 'wwz') {
    out <- wwz( load.tables(x, y) )
  } else if (method == 'kung.fu') {
    out <- kung.fu(load.tables(x, y) )
  } else {
    stop('not a valid method')
  }
  return(out)
}