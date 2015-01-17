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
#' # run the Leontief decomposition on the decompr object
#' lt  <- leontief(decompr_object)
#' lt


# example code for blocks
# i <- 1:p; j <- 1:q + p                         # Indexes of the blocks
# a[i,i, drop=FALSE]


vertical_specialisation <- function ( x ) {
  
  
  lt <- leontief( x )
  
  for (i in 1:k) {
    p <- seq( ((i-1)*k + 1),
              i*k         )
    
    f[p] <- colSums(lt[-p,p])
  }
  
  out(f)
  
}