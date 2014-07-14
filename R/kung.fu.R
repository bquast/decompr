#' Kung Fu Export Source Decomposition
#' 
#' This function runs the decomposition
#' 
#' @param x ane object of class decompr
#' @return a data frame containing the square matrix and labelled column and rows
#' @author Bastiaan Quast
#' @details The Kung Fu algorithm
#' @export


kung.fu <- function( x ) {
  
  # Part 1 == loading data A,L,Vc, X, Y, E,ESR, etc.
  attach( x )
  
  # define Vhat
  Vhat <- diag(GN)
  diag(Vhat) <- Vc
  
  # decompose
  out <- Vhat %*% B %*% Exp
  
  # add row and column names
  out <- as.data.frame(out)
  names(out) <- rownam
  row.names(out) <- rownam
  
  # detach object
  detach(x)
  
  # return result
  return( out )
  
}