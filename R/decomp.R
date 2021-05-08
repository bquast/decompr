#' Interface Function for Decompositions
#'
#' This function loads an ICIO table and runs a specified decomposition. It provides a compact interface for quick analysis. 
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
#' @param method character. The decomposition method, either \code{"leontief"}, \code{"kww"} or \code{"wwz"}.
#' @param \dots further arguments passed to \code{\link{leontief}}, \code{\link{kww}} or \code{\link{wwz}}.
#' @return Depends on the decomposition, see \code{\link{leontief}}, \code{\link{kww}} or \code{\link{wwz}}.
#'  % The output when using the WWZ algorithm is a matrix with dimensions GNG*19.
#'  % Whereby 19 is the 16 objects the WWZ algorithm decomposes exports into, plus three checksums.
#'  % GNG represents source country, using industry and using country.
#' @details For more detailed analysis with multiple decompositions consider using 
#' \code{\link{load_tables_vectors}} to create a 'decompr' class object and then run the decomposition functions \code{\link{leontief}}, \code{\link{kww}} and \code{\link{wwz}} on the object. 
#' @author Bastiaan Quast
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods", \emph{WIOD Working Paper Number 10}, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
#'
#' {Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu (2013). Quantifying international production sharing at the bilateral and sector levels. \emph{No. w19677. National Bureau of Economic Research}.}
#' @export
#' @seealso \code{\link{decompr-package}}
#' @examples
#' # Load leather example data
#' data(leather)
#'
#' # Explore the data
#' str(leather)
#'
#' ## Decomposing gross exports:
#'
#' # Perform the Leontief decomposition
#' decomp(leather, method = "leontief")
#'
#' # Perform the KWW decomposition
#' decomp(leather, method = "kww")
#' 
#' # Perform the WWZ decomposition
#' decomp(leather, method = "wwz")
#' 



decomp <- function(iot, x, y, k, i, o = NULL, v = NULL,
                   method = c("leontief", "kww", "wwz"), ...) {

  method <- match.arg(method)

  if(missing(x)) {
    decompr_obj <- load_tables_vectors(iot = iot)
  } else {
    if(!missing(iot)) stop("Please either supply an 'iot' object or at least matrices 'x', 'y', 'k' and 'i'.")
    decompr_obj <- load_tables_vectors(x = x, y = y, k = k, i = i, o = o, v = v)
  }

  switch(method, 
         leontief = leontief(decompr_obj, ...),
         kww = kww(decompr_obj),
         wwz = wwz(decompr_obj, ...),
         stop('Not a valid method'))         
}
