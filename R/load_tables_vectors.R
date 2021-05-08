#' Load the Input-Output and Final Demand Tables
#' 
#' This function loads the demand tables
#' and creates all matrices and variables required for the GVC decompositions.
#' 
#' @param iot a Input Output Table object - a list with elements 'inter' (= x), 'final' (= y), 'output' (= o), 'countries' (= k) and 'industries' (= i) of class 'iot'. 
#' Alternatively these objects can be passed directly to the function, at least x, y, k and i need to be supplied.
#' @param x intermediate demand table supplied as a numeric matrix of dimensions GN x GN (G = no. of country, N = no. of industries). 
#' Both rows and columns should be arranged first by country, then by industry (e.g. C1I1, C1I2, ..., C2I1, C2I2, ...) and should match (symmetry), 
#' such that rows and columns refer to the same country-industries.
#' @param y final demand table supplied as a numeric matrix of dimensions GN x MN (M = no. of final demand categories recorded for each country). 
#' The rows of y need to match the rows of x, and the columns should also be arranged first by country, then by final demand category (e.g. C1FD1, C1FD2, ..., C2FD1, C2FD2, ...) with the order of the 
#' countries the same as in x.
#' @param k character. A vector of country or region names of length G, arranged in the same order as they occur in the rows and columns of x, y.
#' @param i character. A vector of country or region names of length N, arranged in the same order as they occur in the rows and columns of x and rows of y.
#' @param o numeric. A vector of final outputs for each country-industry matching the rows of x and y. If not provided it will be computed as \code{rowSums(x) + rowSums(y)}.
#' @param v numeric. A vector of value added for each country-industry matching the columns of x. If not provided it will be computed as \code{o - colSums(x)}.
#' @param null_inventory logical. \code{TRUE} sets the inventory (last final demand category for each country) to zero.
#' @return A 'decompr' class object - a list with the following elements:
#'  \tabular{rrrl}{
#'  Am \tab\tab\tab Imported / Exported goods IO shares matrix (\code{x} column-normalized by output \code{o}, with domestic entries set to 0). \cr
#'  B  \tab\tab\tab Leontief Inverse matrix \eqn{(I - A)^{-1}} where \eqn{A} is \code{x} column-normalized by output \code{o}. \cr               
#'  Bd \tab\tab\tab Domestic part of Leontief Inverse matrix (inter-country elements of \eqn{B} set to 0, needed for WWZ decomposition). \cr                 
#'  Bm \tab\tab\tab Imported / Exported part of Leontief Inverse matrix (domestic elements of \eqn{B} set to 0, needed for WWZ decomposition). \cr              
#'  L  \tab\tab\tab Domestic economy Leontief Inverse matrix \eqn{(I - Ad)^{-1}} where \eqn{Ad} is \eqn{A} with all inter-country elements set to 0. \cr
#'  E  \tab\tab\tab Total Exports (output of each country-industry servicing foreign production or foreign final demand). \cr
#'  ESR \tab\tab\tab Total Exports by destination country. \cr
#'  Eint \tab\tab\tab Exports for intermediate production by destination country. \cr
#'  Efd \tab\tab\tab Exports for final demand by destination country. \cr
#'  Vc \tab\tab\tab Value added content of output (\code{v / o}). \cr
#'  G \tab\tab\tab Number of countries. \cr
#'  N \tab\tab\tab Number of industries. \cr
#'  GN \tab\tab\tab Number of country-industries. \cr
#'  k \tab\tab\tab Vector of country names. \cr  
#'  i \tab\tab\tab Vector of industry names. \cr
#'  rownam \tab\tab\tab Unique country-industry names identifying the rows / columns of x and rows of y. \cr
#'  X \tab\tab\tab Total Output (\code{ = o}). \cr
#'  Y \tab\tab\tab Total Final Demand by destination country. \cr 
#'  Yd \tab\tab\tab Domestic Final Demand. \cr
#'  Ym \tab\tab\tab Foreign Final Demand. \cr
#'  }
#' @author Bastiaan Quast
#' @details Adapted from code by Fei Wang.
#' @export
#' @seealso \code{\link{leontief}}, \code{\link{kww}}, \code{\link{wwz}}, \code{\link{decompr-package}}
#' @examples
#' # Load example data
#' data(leather)
#' 
#' # Create intermediate object (class 'decompr')
#' decompr_object <- load_tables_vectors(leather)
#' 
#' # Examine the object                                    
#' str(decompr_object)


load_tables_vectors <- function(iot, x, y, k, i, o = NULL, v = NULL,
                                null_inventory = FALSE) {
  
    ## extract objects from iot object
    if(!missing(iot) && inherits(iot, 'iot')) {
      x <- iot$inter
      y <- iot$final
      k <- iot$countries
      i <- iot$industries
      o <- iot$output
    }
    
    # Some extra checks at little cost: sometimes IO data is wrongly imported or pre-processed
    if(!is.numeric(x) || anyNA(x)) warning("x is not numeric or contains missing values")
    if(!is.numeric(y) || anyNA(y)) warning("y is not numeric or contains missing values")
    if(!is.character(k) || anyNA(k)) warning("k is not character or contains missing values")
    if(!is.character(i) || anyNA(i)) warning("i is not character or contains missing values")
  
    ## find number of sections and regions compute combination
    G <- length(k)
    N <- length(i)
    GN <- G * N
    dx <- dim(x)
    dy <- dim(y)
    
    # Some dimension checking
    if(!all(dx == GN)) stop("x of dimension ", paste(dx, collapse = " * "), " does not match length(k) * length(i) = ", GN)
    if(dy[1L] != GN) stop("nrow(y) = ", dy[1L], " does not match length(k) * length(i) = ", GN)
    if(dy[2L] %% G) stop("The number of final demand categories ncol(y) = ", dy[2L], " is not a multiple of the number of countries length(k) = ", G)
                              
    ## create vector of unique combinations of regions and sectors
    rownam <- as.vector(t(outer(k, i, paste, sep = ".")))
    
    ## making the big rownames: bigrownam
    ## z01 <- t(matrix(rownam, nrow = GN, ncol = G))
    ## dim(z01) <- c((G) * GN, 1)
    ## z02 <- rep(k, times = GN)
    ## bigrownam <- paste(z01, z02, sep = ".")
    
    ## contruct final demand components
    fdc <- dy[2L] / G
    
    ## null inventory if needed
    if (isTRUE(null_inventory)) y[, fdc * (1:G)] <- 0
    
    ## define dimensions
    ## -> only needed for matrices that will be "manually"
    ## (e.g. in a for-loop) filled
    ## For matrix copies, no need for setting the dimensions,
    ## only increases the memory burden
    Bd <- Ad <- matrix(0, nrow = GN, ncol = GN)
    Yd <- ESR <- Eint <- Efd <- Y <- matrix(0, nrow = GN, ncol = G)
    
    # o can be computed...
    if (is.null(o)) {
      o <- rowSums(x) + rowSums(y)
    } else {
      if(!is.numeric(o) || anyNA(o)) warning("o is not numeric or contains missing values")
      if(length(o) != GN) stop("length(o) = ", length(o), " does not match length(k) * length(i) = ", GN)
      if(is.character(m <- all.equal(rowSums(x) + rowSums(y), o))) 
        message("o supplied is different from rowSums(x) + rowSums(y). ", m)
    }
    
    ## this might not be the best way to construct V
    if (is.null(v)) {
      v <- o - colSums(x)
    } else {
      if(!is.numeric(v) || anyNA(v)) warning("v is not numeric or contains missing values")
      if(length(v) != GN) stop("length(v) = ", length(v), " does not match length(k) * length(i) = ", GN)
      if(is.character(m <- all.equal(o - colSums(x), v))) 
        message("v supplied is different from o - colSums(x). ", m)
    }
    
    # A <- x / outer(rep.int(1L, GN), o) # Significantly faster than:  t(t(x) / o)
    A <- .Call(C_rowmult, x, 1 / o)
    A[!is.finite(A)] <- 0
    Am <- A

    II <- diag(GN)
    Bm <- B <- solve(II - A)
    
    for (j in 1:G) {
        m = 1L + (j - 1L) * N
        n = N + (j - 1L) * N

        ## set diagonal
        Ad[m:n, m:n] <- A[m:n, m:n]
        Bd[m:n, m:n] <- B[m:n, m:n]

        ## delete diagonal
        Bm[m:n, m:n] <- 0
        Am[m:n, m:n] <- 0
    }
    
    L <- solve(II - Ad)
    Vc <- v / o
    Vc[!is.finite(Vc)] <- 0
    ## Vhat <- diag(Vc)
    
    ## Part 2: computing final demand: Y
    if(fdc > 1L) {
        for (j in 1:G) {
            m <- 1L + (j - 1L) * fdc
            n <- fdc + (j - 1L) * fdc

            Y[, j] <- rowSums2(y, cols = m:n)
        }
    } else if(fdc == 1L) {
        Y <- y
    }

    ## domestic final demand
    Ym <- Y
    
    
    ## Part 3: computing export: E, Esr
    E <- cbind(x, y) # This is also expensive with large matrices. Would be nice if it could be avoided
    for (j in 1:G) {
        m <- 1L + (j - 1L) * N
        n <- N + (j - 1L) * N
        
        s <- GN + 1L + (j - 1L) * fdc
        r <- GN + fdc + (j - 1L) * fdc
        
        E[m:n, m:n] <- 0  ## intermediate demand for domestic goods
        E[m:n, s:r] <- 0  ## final demand for domestic goods

        Yd[m:n, j] <- Y[m:n, j]
        Ym[m:n, j] <- 0
    }
    
    z <- E
    E <- rowSums(E) # Not necessary to have a matrix here, I changed the code in wwz.R

    for (j in 1:G) {
        m <- 1L + (j - 1L) * N
        n <- N + (j - 1L) * N
        s <- GN + 1L + (j - 1L) * fdc
        r <- GN + fdc + (j - 1L) * fdc

        ## Final goods exports
        Efd[, j] <- if (s == r) z[, s] else rowSums2(z, cols = s:r)

        ## intermediate exports
        Eint[, j] <- rowSums2(z, cols = m:n)

        ## Total exports
        ESR[, j] <- Eint[, j] + Efd[, j]
    }
    
    
    ## Part 4: naming the rows and columns in variables
    names(Vc) <- rownam
    names(o) <- rownam
    names(E) <- rownam
    dny <- list(rownam, k)
    dimnames(Y) <- dny
    dimnames(Yd) <- dny
    dimnames(Ym) <- dny
    dimnames(ESR) <- dny
    dimnames(Eint) <- dny
    dimnames(Efd) <- dny
    dnx <- list(rownam, rownam) 
    dimnames(Am) <- dnx
    ## dimnames(Ad) <- dnx
    ## dimnames(A) <- dnx
    dimnames(B) <- dnx
    dimnames(Bd) <- dnx
    dimnames(Bm) <- dnx
    dimnames(L) <- dnx
    
    ## Part 5: creating decompr object
    out <- list(Am = Am,
                ## Ad = Ad, ## never used
                ## A = A, ## never used
                B = B,                  # leontief
                Bd = Bd,                # wwz
                Bm = Bm,                # wwz
                L = L,
                E = E,
                ESR = ESR,
                Eint = Eint,
                Efd = Efd,
                Vc = Vc,
                ## fdc = fdc, ## never used

                ## country/industry parameter
                G = G,
                N = N,
                GN = GN,
                k = k,
                i = i, 
                
                rownam = rownam,
                ## bigrownam = bigrownam,
                ## Vhat = Vhat,
                X = o,                  # leontief
                Y = Y,                  # leontief
                Yd = Yd,
                Ym = Ym)
    ## z = z,
    ## z01 = z01, z02 = z02)
    
    class(out) <- "decompr"
    
    ## Part 6: returning object
    return(out)
    
}
