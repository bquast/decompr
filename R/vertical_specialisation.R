#' Vertical Specialisation
#' 
#' This function runs the Leontief decomposition decomposition
#' 
#' @param x ane object of class decompr
#' @return a data frame containing the square matrix and labelled column and rows
#' @author Bastiaan Quast
#' Quantifying international production sharing at the bilateral and sector levels. 
#' No. w19677. National Bureau of Economic Research, 2013.
#' @export
#' @examples
#' # load leather example data
#' data(leather)
#' 
#' # create intermediate object (class decompr)
#' decompr_object <- load_tables_vectors(inter,
#'                                       final,
#'                                       countries,
#'                                       industries,
#'                                       out        )
#' str(decompr_object)
#' 
#' # run the Vertical Specialisation decomposition on the decompr object
#' vertical_specialisation(decompr_object)


# example code for blocks
# i <- 1:p; j <- 1:q + p                         # Indexes of the blocks
# a[i,i, drop=FALSE]


vertical_specialisation <- function ( x ) {
  
  
  lt <- leontief( x )
  
  # create output vector
  f <- vector()
  
  # sum columns excluding the moving block diagonal of width G (no. of sectors)
  for (j in 1:x$N) {
    p <- seq( ((j-1)*x$N + 1),
              j*x$N         )
    
    f[p] <- colSums(lt[-p,p])
  }
  
  f <- as.data.frame(t(f))
  names(f) <- x$rownam
  
  return(f)
  
}