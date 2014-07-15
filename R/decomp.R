#' Interface function for decompositions
#' 
#' This function runs the decomposition
#' 
#' @param x the intermediate demand table, where the first row and the first column list the country names, the second row and second column list the insdustry names for each country. The matrix is presumed to be of dimensions G*N where G represents the country and N the industry. No extra columns should be there. Extra rows at the bottom which list adjustments such as taxes as well are disregarded, with the exception that the very last row is presumed to contain the total output.
#' @param y the final demand table it has dimensions GN*GM ( where M is the number of objects final demand is decomposed in, e.g. household consumption, here this is five decompositions).
#' @param method user specifies the decomposition method
#' @return The output when using the WWZ algorithm is a matrix with dimensions GNG*19. Whereby 19 is the 16 objects the WWZ algorithm decomposes exports into, plus three checksums. GNG represents source country, using industry and using country.
#' @author Bastiaan Quast
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