#' Leontief Decomposition
#' 
#' This function runs the Leontief decomposition.
#' 
#' @param x ane object of class decompr
#' @param long transform the output data into a long (tidy) data set or not, default it TRUE.
#' @return a data frame containing the square matrix and labelled column and rows
#' @author Bastiaan Quast
#' @references Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu.
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
#' 
#' # run the Leontief decomposition on the decompr object
#' leontief(decompr_object, long=FALSE )


leontief <- function( x, long=TRUE ) {
  
  # Part 1 == loading data A,L,Vc, X, Y, E,ESR, etc.
  
  # decompose
  out <- x$Vhat %*% x$B %*% x$Exp
  
  
  if (long == TRUE) {
    
    out <- as.vector(t(out))
    out <- data.frame( rep(x$k,                  each = x$GN*x$N ),
                       rep(x$i, times = x$G,     each = x$GN),
                       rep(x$k, times = x$GN,    each = x$N),
                       rep(x$i, times = x$GN*x$G ),
                       out)
    names(out) <- c("Source_Country", "Source_Industry", "Using_Country", "Using_Industry", "FVAX")
    
    # set long attribute to TRUE
    attr(out, "long") <- TRUE
    
  } else {
    
    # add row and column names
    out <- as.data.frame(out)
    names(out) <- x$rownam
    row.names(out) <- x$rownam
    
    # set long attribute to FALSE
    attr(out, "long") <- FALSE
    
  }
  
  
  
  # create attributes
  attr(out, "k")      <- x$k
  attr(out, "i")      <- x$i
  # attr(out, "rownam") <- x$rownam
  
  # return result
  return( out )
  
}
