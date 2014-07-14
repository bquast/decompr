#' Interface function for decompositions
#' 
#' This function runs the decomposition
#' 
#' @param input.file the file which is
#'  created by the load.demand function
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