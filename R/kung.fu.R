#' Kung Fu Export Source Decomposition
#' 
#' This function runs the Kung Fu decomposition
#' 
#' @param x ane object of class decompr
#' @return a data frame containing the square matrix and labelled column and rows
#' @author Bastiaan Quast
#' @references No. w19677. National Bureau of Economic Research, 2013.
#' Mehrotra, Rajiv, Fu K. Kung, and William I. Grosky.
#' Industrial part recognition using a component-index.
#' Image and Vision Computing 8, no. 3 (1990): 225-232.
#' @export


kung.fu <- function( x ) {
  
  # Part 1 == loading data A,L,Vc, X, Y, E,ESR, etc.
  
  # decompose
  out <- x$Vhat %*% x$B %*% x$Exp
  
  # add row and column names
  out <- as.data.frame(out)
  names(out) <- x$rownam
  row.names(out) <- x$rownam
  
  # return result
  return( out )
  
}