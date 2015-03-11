#' Leontief Decomposition
#' 
#' This function runs the Leontief decomposition.
#' 
#' @param x ane object of class decompr
#' @param tidy transform the output data into a tidy data set or not, default it TRUE.
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
#' leontief(decompr_object, tidy=FALSE )


leontief <- function( x, tidy=TRUE ) {
  
  # Part 1 == loading data A,L,Vc, X, Y, E,ESR, etc.
  
  # decompose
  out <- x$Vhat %*% x$B %*% x$Exp
  
  
  if (tidy == TRUE) {
    
    out <- as.vector(out)
    out <- data.frame( rep(x$k, times = x$GN, each = x$N),
                       rep(x$i, times = x$GN*x$G),
                       rep(x$k,               each = x$GN*x$N ),
                       rep(x$i, times = x$G,  each = x$GN),
                       out)
    names(out) <- c("Source_Country", "Source_Industry", "Using_Country", "Using_Industry", "FVAX")
    
  } else {
    
    # add row and column names
    out <- as.data.frame(out)
    names(out) <- x$rownam
    row.names(out) <- x$rownam
    
  }
  
  
  
  # create attributes
  attr(out, "k")      <- x$k
  attr(out, "i")      <- x$i
  # attr(out, "rownam") <- x$rownam
  
  # return result
  return( out )
  
}

#' Leontief Output Decomposition
#' 
#' This function runs the Leontief decomposition on output
#' 
#' @param x ane object of class decompr
#' @return a data frame containing the square matrix and labelled column and rows
#' @param tidy transform the output data into a tidy data set or not, default it TRUE.
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
#' leontief_output(decompr_object)


leontief_output <- function( x, tidy=TRUE ) {
  
  # Part 1 == loading data A,L,Vc, X, Y, E,ESR, etc.
  
  # decompose
  out <- x$Vhat %*% x$B %*% diag(x$X)
  
  # add row and column names
  out <- as.data.frame(out)
  names(out) <- x$rownam
  row.names(out) <- x$rownam
  
  # create attributes
  attr(out, "k")      <- x$i
  attr(out, "i")      <- x$k
  # attr(out, "rownam") <- x$rownam
  
  # return result
  return( out )
  
}



#' Source Decomposition (deprecated)
#' 
#' DEPRECATED: This function runs the source decomposition decomposition
#' 
#' @param x ane object of class decompr
#' @return a data frame containing the square matrix and labelled column and rows
#' @param tidy transform the output data into a tidy data set or not, default it TRUE.
#' @author Bastiaan Quast
#' @references Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu.
#' Quantifying international production sharing at the bilateral and sector levels. 
#' No. w19677. National Bureau of Economic Research, 2013.
#' @export

kung_fu <- leontief