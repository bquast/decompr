#' Leontief Decomposition
#' 
#' The Leontief decomposition of gross flows (exports, final demand, output) into their value added origins. 
#'
#' @param x an object of class decompr.
#' @param post post-multiply the value added multiplier matrix [\eqn{VB = V(I-A)^{-1}}] with something to deduce the value added origins thereof.  
#' The default is \code{"exports"} \eqn{VAE = V(I-A)^{-1}E}, where \eqn{E} is a diagonal matrix with exports along the diagonal yielding the 
#' country-industry level sources of value added (rows) for each using (column) country-industry; similarly for \code{"output"}. 
#' Option \code{"final_demand"} computes value added origins of final demand by source country-industry and importing country, by computing 
#' \eqn{VAY = V(I-A)^{-1}Y} where \eqn{Y} is the corresponding GN x G matrix contained in \code{x}. Option \code{"none"} just returns \eqn{VB} which gives the value added shares.
#' @param long logical. Transform the output data into a long (tidy) data set or not, default is \code{TRUE}.
#' @return If \code{long = TRUE} a molten data frame containing the elements of the decomposed flows matrix in the final column, preceded by several identifier columns. 
#' If \code{long = FALSE} the decomposed flows matrix is simply returned.
#' @details The Leontief decomposition is obtained by pre-multiplying the flow measure (e.g. exports) with 
#' the value added multiplier matrix [\eqn{VB = V(I-A)^{-1}}], obtained by pre-multiplying the Leontief Inverse matrix [\eqn{B = (I-A)^{-1}}] with a diagonal matrix [\eqn{V}] containing the direct value added share in each industries output.
#' 
#' \eqn{V} is obtained as \code{diag(v / o)} where \code{o} is total industry output. \code{v} is either supplied to \code{\link{load_tables_vectors}} or computed as \code{o - colSums(x)} with \code{x} the raw IO matrix. 
#' If \code{o} is not supplied to \code{\link{load_tables_vectors}}, it is computed as \code{rowSums(x) + rowSums(y)} where \code{y} is the matrix of final demands. If both \code{o} and \code{v} are not supplied to \code{\link{load_tables_vectors}}, this is equivalent to computing \eqn{V} as \code{diag(1 - colSums(A))}, with \eqn{A} is the row-normalized IO matrix also used to compute the Leontief Inverse [\eqn{B}].
#' @author Bastiaan Quast
#' @references 
#' Leontief, W. (Ed.). (1986). Input-output economics. \emph{Oxford University Press}.
#' 
#' Hummels, D., Ishii, J., & Yi, K. M. (2001). The nature and growth of vertical specialization in world trade. \emph{Journal of international Economics, 54}(1), 75-96.
#' 
#' Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu (2013). Quantifying international production sharing at the bilateral and sector levels (No. w19677). \emph{National Bureau of Economic Research}.
#' @export
#' @seealso \code{\link{kww}}, \code{\link{wwz}}, \code{\link{decompr-package}}
#' @examples
#'# Load example data
#' data(leather)
#' 
#'# Create intermediate object (class 'decompr')
#' decompr_object <- load_tables_vectors(leather)
#'
#'# Perform the Leontief decomposition of each country-industries 
#'# exports into their value added origins by country-industry
#' leontief(decompr_object)


leontief <- function(x,
                     post = c("exports", "output", "final_demand", "none"),
                     long = TRUE) {
  
    if(!inherits(x, "decompr")) stop("x must be an object of class 'decompr' created by the load_tables_vectors() function.")
  
    post <- match.arg(post)
    
    # This loads all the elements into the current function namespace, and avoids 38 calls to x$...
    Vc <- B <- GN <- E <- X <- Y <- k <- i <- G <- N <- NULL # First need to initialize as NULL to avoid R CMD check error. 
    list2env(x, environment())
    
    ## compute Leontief inverse
    ## out <- Vhat %*% B
    V <- Vc * B

    ## post multiply
    out <- switch(post,
                  ## out.old <- V %*% diag(rowSums(ESR))
                  ## sweep(V, 2, rowSums(ESR), `*`)
                  ## sum(abs(out.old - out))
                  exports = .Call(C_rowmult, V, E), # V * outer(rep.int(1L, GN), E), 
                  ## out <- V %*% diag(X)
                  ## sweep(V, 2, X, `*`)
                  output = .Call(C_rowmult, V, X), # V * outer(rep.int(1L, GN), X),
                  ## out <- sweep(V, 2, Y, `*`)
                  final_demand = V %*% Y,
                  none = V)
    
    ## structure output format
    if (isTRUE(long)) {
      
      out <- as.vector(t(out))
      nr <- length(out)
      sk <- seq_along(k)
      si <- seq_along(i)
      out <- switch(post,
                    final_demand = list(Source_Country = structure(rep(sk, each = GN), levels = k, class = "factor"),
                                        Source_Industry = structure(rep(si, times = G, each = G), levels = i, class = "factor"),
                                        Importing_Country = structure(rep(sk, times = GN), levels = k, class = "factor"),
                                        Final_Demand = out),
                    list(Source_Country = structure(rep(sk, each = GN * N), levels = k, class = "factor"),
                         Source_Industry = structure(rep(si, times = G, each = GN), levels = i, class = "factor"),
                         Using_Country = structure(rep(sk, times = GN, each = N), levels = k, class = "factor"),
                         Using_Industry = structure(rep(si, times = GN * G), levels = i, class = "factor"),
                         FVAX = out))
      
      attr(out, "row.names") <- .set_row_names(nr)
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
