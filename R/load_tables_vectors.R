#' Load the Input-Output and Final demand tables
#' 
#' This function loads the demand tables
#' and defines all variables for the decomposition
#' 
#' @param iot Input Output Table object, contains x, y, k, i, and o
#' @param x intermediate demand table, it has dimensions GN x GN (G = no. of country, N = no. of industries),
#'  excluding the first row and the first column which contains the country names,
#'  and the second row and second column which contain the industry names for each country.
#'  In addition, an extra row at the end should contain final demand.
#' @param y final demand table it has dimensions GN x MN,
#'  excluding the first row and the first column which contains the country names,
#'  the second column which contains the industry names for each country,
#'  and second row which contains the five decomposed final demands (M).
#'  #' @param k is a vector of country of region names
#' @param k vector or country or region names
#' @param i vector of sector or industry names
#' @param o vector of final outputs
#' @param v vector of value added
#' @param null_inventory when the inventory (last FDC) should be set to zero
#' @return a decompr class object
#' @author Bastiaan Quast
#' @details Adapted from code by Fei Wang.
#' @export
#' @examples
#' # load example data
#' data(leather)
#' 
#' # create intermediate object (class decompr)
#' decompr_object <- load_tables_vectors(inter,
#'                                       final,
#'                                       countries,
#'                                       industries,
#'                                       out)
#' 
#' # examine output object                                    
#' str(decompr_object)


load_tables_vectors <- function(iot, x, y, k, i, o, v = NULL,
                                null_inventory = FALSE) {
  
    ## extract objects from iot object
    if(hasArg(iot) && class(iot)=='iot') {
      x <- iot$inter
      y <- iot$final
      o <- iot$output
      k <- iot$countries
      i <- iot$industries
    }
    
    ## find number of sections and regions compute combination
    G <- length(k)
    N <- length(i)
    GN <- G * N
    
    ## create vector of unique combinations of regions and sectors
    rownam <- as.vector(t(outer(k, i, paste, sep = ".")))
    
    ## making the big rownames: bigrownam
    ## z01 <- t(matrix(rownam, nrow = GN, ncol = G))
    ## dim(z01) <- c((G) * GN, 1)
    ## z02 <- rep(k, times = GN)
    ## bigrownam <- paste(z01, z02, sep = ".")
    
    ## contruct final demand components
    fdc <- dim(y)[2]/G
    
    ## null inventory if needed
    if (null_inventory == TRUE) {
        y[, fdc * (1:G)] <- 0
    }
    
    ## define dimensions
    ## -> only needed for matrizes that will be "manually"
    ## (e.g. in a for-loop) filled
    ## For matrix copies, no need for setting the dimensions,
    ## only increases the memory burden
    Bd <- Ad <- matrix(0, nrow = GN, ncol = GN)
    Yd <- ESR <- Eint <- Efd <- Y <- matrix(0, nrow = GN, ncol = G)

    
    ## this might not be the best way to construct V
    if (is.null(v)) {
        v <- o - colSums(x)
    }
    
    A <- t(t(x) / o)
    A[!is.finite(A)] <- 0
    Am <- A

    II <- diag(GN)
    Bm <- B <- solve(II - A)
    
    for (j in 1:G) {
        m = 1 + (j - 1) * N
        n = N + (j - 1) * N

        ## set diagonal
        Ad[m:n, m:n] <- A[m:n, m:n]
        Bd[m:n, m:n] <- B[m:n, m:n]

        ## delete diagonal
        Bm[m:n, m:n] <- 0
        Am[m:n, m:n] <- 0
    }
    
    L <- solve(II - Ad)
    Vc <- v/o
    Vc[!is.finite(Vc)] <- 0
    ## Vhat <- diag(Vc)
    
    ## Part 2: computing final demand: Y
    if(fdc > 1) {
        for (j in 1:G) {
            m <- 1 + (j - 1) * fdc
            n <- fdc + (j - 1) * fdc

            Y[, j] <- rowSums(y[, m:n])
        }
    } else if(fdc == 1) {
        Y <- y
    }

    ## domestic final demand
    Ym <- Y
    
    
    ## Part 3: computing export: E, Esr
    E <- cbind(x, y)
    for (j in 1:G) {
        m <- 1 + (j - 1) * N
        n <- N + (j - 1) * N
        
        s <- GN + 1 + (j - 1) * fdc
        r <- GN + fdc + (j - 1) * fdc
        
        E[m:n, m:n] <- 0  ## intermediate demand for domestic goods
        E[m:n, s:r] <- 0  ## final demand for domestic goods

        Yd[m:n, j] <- Y[m:n, j]
        Ym[m:n, j] <- 0
    }
    
    z <- E
    E <- as.matrix(rowSums(E))

    for (j in 1:G) {
        m <- 1 + (j - 1) * N
        n <- N + (j - 1) * N
        s <- GN + 1 + (j - 1) * fdc
        r <- GN + fdc + (j - 1) * fdc

        ## Final goods exports
        if (s == r) {
            Efd[, j] <- z[, s:r]
        } else {
            Efd[, j] <- rowSums(z[, s:r])
        }

        ## Total exports
        ESR[, j] <- rowSums(z[, m:n]) + Efd[, j]

        ## intermediate exports
        Eint[, j] <- rowSums(z[, m:n])
    }
    
    
    ## Part 4: naming the rows and columns in variables
    ## colnames(A) <- rownam
    ## rownames(A) <- rownam
    names(Vc) <- rownam
    names(o) <- rownam
    rownames(Y) <- rownam
    rownames(ESR) <- rownam
    names(E) <- rownam

    dimnames(B) <- dimnames(A)
    dimnames(Bm) <- dimnames(A)
    dimnames(Bd) <- dimnames(A)
    ## dimnames(Ad) <- dimnames(A)
    dimnames(Am) <- dimnames(A)
    dimnames(L) <- dimnames(A)
    
    colnames(ESR) <- k
    colnames(Y) <- k
    
    dimnames(Ym) <- dimnames(Y)
    
    dimnames(Eint) <- dimnames(ESR)
    dimnames(Efd) <- dimnames(ESR)

    
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
                GN = GN,
                i = i, 
                k = k,
                N = N,
                
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
