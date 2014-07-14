#' Interface function for decompositions
#' 
#' This function runs the decomposition
#' 
#' @param intermediate.demand the intermediate demand table
#' @param final.demand the final demand table
#' @param method user specifies the decomposition method
#' @return the decomposition table
#' @author Bastiaan Quast
#' @export

decomp <- function( intermediate.demand, final.demand, method="wwz" ) {
  
  if (method == 'wwz') {
    out <- wwz( load.demand(intermediate.demand, final.demand) )
  } else if (method == 'kung.fu') {
    out <- kung.fu(load.demand(intermediate.demand, final.demand) )
  } else {
    stop('not a valid method')
  }
  return(out)
}