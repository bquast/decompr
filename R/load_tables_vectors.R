#' Load the Input-Output and Final demand tables
#' 
#' This function loads the demand tables
#' and defines all variables for the decomposition
#' 
#' @param x the intermediate demand table, it has dimensions GN x GN (G = no. of country, N = no. of industries),
#'  excluding the first row and the first column which contains the country names,
#'  and the second row and second column which contain the industry names for each country.
#'  In addition, an extra row at the end should contain final demand.
#' @param y the final demand table it has dimensions GN x MN,
#'  excluding the first row and the first column which contains the country names,
#'  the second column which contains the industry names for each country,
#'  and second row which contains the five decomposed final demands (M).
#' @param k is a vector of country of region names
#' @param i is a vector of sector or industry names
#' @param o is a vecotr of final outputs
#' @return a decompr class object
#' @author Bastiaan Quast
#' @details Adapted from code by Fei Wang.
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


load_tables_vectors <- function(x, y, k, i, o) {

  # find number of sections and regions
  # compute combination
  G      <- length(k)
  N      <- length(i)
  GN     <- G * N
  
  # create vector of unique combinations of regions and sectors
  z <- t(outer(k, i, paste, sep="."))
  rownam <- as.vector(z)
  
  # making the big rownames: bigrownam
  z1 <-  t(matrix( rownam, nrow=GN, ncol=G ) )
  tot <- rep( "sub", times=GN )
  z01 <- rbind( z1,tot )
  dim(z01 ) <- c( (G+1)*GN,1 )
  
  z2 <-  c( k, "TOTAL" )
  z02 <- rep( z2,times=GN )
  
  bigrownam <- paste( z01, z02, sep="." )
  
  # define dimensions
  Ad   <- matrix( 0, nrow = GN, ncol = GN )
  Am   <- Ad
  Bd   <- Ad
  Bm   <- Ad
  Y    <- matrix( 0, nrow = GN, ncol = G )
  Yd   <- Y
  Ym   <- Y
  ESR  <- Y
  Eint <- Y
  Efd  <- Y
  
  X <- o
  
  #### this might not be the best way to construct V
  V <- o - colSums( x )
  
  A <- t(t(x)/o)
  A[ is.na( A ) ] <- 0
  A[ A==Inf ] <- 0
  II <- diag(GN)
  B <- solve( II-A )
  Bm <- B
  Am <- A
  
  for (j in 1:G )  {
    m=1+(j-1)*N
    n=N+(j-1)*N
    
    Ad[m:n,m:n]  <- A[m:n,m:n]
    Bd[m:n,m:n]  <- B[m:n,m:n]
    Bm[m:n,m:n]  <- 0
    Am[m:n,m:n]  <- 0
  }
  
  L                 <- solve( II-Ad )
  Vc                <- V/o
  Vc[ is.na( Vc ) ] <- 0
  Vc[ Vc==Inf ]     <- 0
  
  Vhat <- diag(Vc)
  
  
  # contruct final demand components
  fdc <- dim(y)[2] / G
  
  # Part 2: computing final demand: Y
  for ( j in 1:G ){
    m <- 1   + (j-1) * fdc
    n <- fdc + (j-1) * fdc
    
    if (m == n) {
      Y[ , j ] <- y[ , m:n ]
    } else {
      Y[ , j ] <- rowSums( y[ , m:n ] )
    }
  }
  
  Ym <- Y
  
  
  # Part 3: computing export: E, Esr
  E <- cbind( x, y )
  
  for (j in 1:G )  {
    m <- 1 +(j-1)*N
    n <- N +(j-1)*N
    
    E[m:n, m:n]  <- 0   # intermediate demand for domestic goods
  }
  
  for (j in 1:G)  {
    m <- 1 + (j-1) * N
    n <- N + (j-1) * N
    
    s <- GN + 1   + (j-1) * fdc
    r <- GN + fdc + (j-1) * fdc
    
    E[m:n,s:r]  <- 0 # final demand for domestic goods
    Yd[ m:n,j ] <- Y[m:n,j]
    Ym[ m:n,j ] <- 0
  }
  
  z <- E
  E <- rowSums( E )
  E <- as.matrix( E )
  
  for (j in 1:G)  {
    m <- 1        + (j-1) * N
    n <- N        + (j-1) * N
    s <- GN + 1   + (j-1) * fdc
    r <- GN + fdc + (j-1) * fdc
    if (s == r) {
      fge <- z[ ,s:r ]
    } else {
      fge <- rowSums( z[ ,s:r ] )
    }
    ESR[ ,j ]  <- rowSums( z[ , m:n ] ) + fge
    Eint[ ,j ] <- rowSums( z[ , m:n ] )
    Efd[ ,j ]  <- fge
  }
  
  Exp <- diag( rowSums(ESR) )
  
  
  # Part 4: naming the rows and columns in variables
  colnames(A)     <- rownam
  rownames(A)     <- rownam
  A_names         <- dimnames(A)
  dimnames(B)     <- A_names
  dimnames(Bm)    <- A_names
  dimnames(Bd)    <- A_names
  dimnames(Ad)    <- A_names
  dimnames(Am)    <- A_names
  dimnames(L)     <- A_names
  names(Vc)       <- rownam
  names(o)        <- rownam
  colnames(Y)     <- k
  rownames( Y )   <- rownam
  dimnames(Ym)    <- dimnames( Y )
  names(E)        <- rownam
  colnames(ESR)   <- k
  rownames( ESR ) <- rownam
  dimnames(Eint)  <- dimnames( ESR )
  dimnames(Efd)   <- dimnames( ESR )
  

  # Part 5: creating decompr object
  out <- list( Exp  = Exp,
               Vhat = Vhat,
               A    = A,
               B    = B,
               Ad   = Ad,
               Am   = Am,
               Bd   = Bd,
               Bm   = Bm,
               L    = L,
               Vc   = Vc,
               X    = o,
               Y    = Y,
               Yd   = Yd,
               Ym   = Ym,
               E    = E,
               ESR  = ESR,
               Eint = Eint,
               Efd  = Efd,
               G    = G,
               N    = N,
               GN   = GN,
               bigrownam = bigrownam,
               k    = k,
               rownam = rownam,
               tot  = tot,
               z    = z,
               z01  = z01,
               z02  = z02,
               z1   = z1,
               z2   = z2
               )
  
  class(out) <- "decompr"
  
  # Part 6: returning object
  return(out)
  
}