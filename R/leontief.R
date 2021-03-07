#' Leontief Decomposition
#' 
#' The Leontief Decomposition of gross flows (output, exports, final demand) into their value-added origins is obtained by pre-multiplying the flow measure with 
#' the value added multiplier matrix [VB = V(I-A)^(-1)], obtained by pre-multiplying the Leontief Inverse matrix [B = (I-A)^(-1)] with a diagonal matrix [V] containing the direct value added share in each industries output.
#'
#' @param x an object of class decompr.
#' @param post post-multiply the value added multiplier matrix [VB = V(I-A)^(-1)] with something to deduce the value-added origins thereof.  
#' The default is "exports" [VAE = V(I-A)^(-1)E], where [E] is a diagonal matrix with exports along the diagonal yielding decomposed flows at 
#' the exporting (source) and importing (using) country-industry level; similarly for "output". 
#' Option "final_demand" computes value added origins of final demand by source country-industry and importing country, by computing 
#' [VAY = V(I-A)^(-1)Y] where [Y] is the corresponding GN x G matrix contained in \code{x}. Option "none" just returns [VB].
#' @param long logical. Transform the output data into a long (tidy) data set or not, default is \code{TRUE}.
#' @return If \code{long = TRUE} a molten data frame containing the elements of the decomposed matrix in the final column, preceeded by several identifier columns. 
#' If \code{long = FALSE} the matrix with the decomposed flows is simply returned.
#' @note [V] is obtained as \code{diag(v / o)} where \code{o} is total industry output. \code{v} is either supplied to \code{\link{load_tables_vectors}} or computed as \code{o - colSums(x)} with \code{x} the raw IO matrix. 
#' If \code{o} is not supplied to \code{\link{load_tables_vectors}}, it is computed as \code{rowSums(x) + rowSums(y)} where \code{y} is the matrix of final demands. If both \code{o} and \code{v} are not supplied to \code{\link{load_tables_vectors}}, this is equivalent to computing [V] as \code{diag(1 - colSums(A))}, with [A] is the row-normalized IO matrix also used to compute the Leontief Inverse [B].
#' @author Bastiaan Quast
#' @references Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu.
#' Quantifying international production sharing at the bilateral and sector levels.
#' No. w19677. National Bureau of Economic Research, 2013.
#' @export
#' @examples
#'## load example data
#' data(leather)
#' 
#'## create intermediate object (class decompr)
#' decompr_object <- load_tables_vectors(x = inter,
#'                                       y = final,
#'                                       k = countries,
#'                                       i = industries,
#'                                       o = out        )
#'
#'## run the decomposition of exports into their value added origins
#' leontief(decompr_object )


leontief <- function(x,
                     post = c("exports", "output", "final_demand", "none"),
                     long = TRUE) {
  
    if(!inherits(x, "decompr")) stop("x must be an object of class 'decompr' created by the load_tables_vectors() function.")
  
    post <- match.arg(post)
    
    # This loads all the elements into the current function namespace, and avoids 38 calls to x$...
    list2env(x, environment())
    
    ## compute Leontief inverse
    ## out <- Vhat %*% B
    V <- Vc * B

    ## post multiply
    out <- switch(post,
                  ## out.old <- V %*% diag(rowSums(ESR))
                  ## sweep(V, 2, rowSums(ESR), `*`)
                  ## sum(abs(out.old - out))
                  exports = V * outer(rep.int(1L, GN), E), 
                  ## out <- V %*% diag(X)
                  ## sweep(V, 2, X, `*`)
                  output = V * outer(rep.int(1L, GN), X),
                  ## out <- sweep(V, 2, Y, `*`)
                  final_demand = V %*% Y,
                  none = V)
    
    ## structure output format
    if (isTRUE(long)) {
      
      out <- as.vector(t(out))
      l <- length(out)
      
      out <- switch(post,
                    final_demand = list(Source_Country = factor(rep(k, each = GN), levels = k),
                                        Source_Industry = factor(rep(i, times = G, each = G), levels = i),
                                        Importing_Country = factor(rep(k, times = GN), levels = k),
                                        Final_Demand = out),
                    list(Source_Country = factor(rep(k, each = GN * N), levels = k),
                         Source_Industry = factor(rep(i, times = G, each = GN), levels = i),
                         Using_Country = factor(rep(k, times = GN, each = N), levels = k),
                         Using_Industry = factor(rep(i, times = GN * G), levels = i),
                         FVAX = out))
      
      attr(out, "row.names") <- .set_row_names(l)
      class(out) <- "data.frame"
      
      ## set long attribute to TRUE
      attr(out, "long") <- TRUE
      
    } else {
      
        # Why not return the matrix ? It's more convenient both for heatmap visualization and further analysis, and coercing to data frame has a cost.
        # ## add row and column names
        # out <- as.data.frame(out)
        # if (post != "final_demand") names(out) <- rownam 
        # row.names(out) <- rownam

        ## set long attribute to FALSE
        attr(out, "long") <- FALSE

    }

    ## create attributes
    attr(out, "k") <- k
    attr(out, "i") <- i
    attr(out, "decomposition") <- "leontief"
    attr(out, "post") <- post
    ## attr(out, "rownam") <- rownam

    ## return result
    return(out)

}
