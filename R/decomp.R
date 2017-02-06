#' Interface function for decompositions
#'
#' This function runs the decomposition.
#' NOTE: the default method is now "leontief", please specify method="wwz" explicitly for Wang-Wei-Zhu.
#' See http://qua.st/decompr/decompr-v2/ for more information.
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
#' @param v vector of value added, optional. If this vector is not specified, value added will be calculated as gross output - intermediate consumption
#' @param method user specified the decomposition method
#' @param verbose logical, should timings of the calculation be displayed? Default is FALSE
#' @param ... arguments to pass on the respective decomposition method
#' @return The output when using the WWZ algorithm is a matrix with dimensions GNG*19.
#'  Whereby 19 is the 16 objects the WWZ algorithm decomposes exports into, plus three checksums.
#'  GNG represents source country, using industry and using country.
#' @details Version 2 introduces several important changes, the default method is now leontief, which means that wwz has to be specified explicitly.
#' Furthermore, the input object have a different structure, see the information below for details.
#' @author Bastiaan Quast
#' @references {Timmer, Marcel P. (ed) (2012), "The World Input-Output Database (WIOD): Contents Sources and Methods", WIOD Working Paper Number 10, downloadable at http://www.wiod.org/publications/papers/wiod10.pdf }
#'
#' {Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. Quantifying international production sharing at the bilateral and sector levels. No. w19677. National Bureau of Economic Research, 2013.}
#' @export
#' @examples
#' # load leather example data
#' data(leather)
#'
#' # explore the data set
#' ls()
#'
#' # explore each of the objects
#' inter
#' final
#' countries
#' industries
#' out
#'
#' # use the direct approach
#'
#' # run the Leontief decomposition
#' decomp(inter,
#'        final,
#'        countries,
#'        industries,
#'        out,
#'        method = "leontief")
#'
#' # run the WWZ decomposition
#' decomp(inter,
#'        final,
#'        countries,
#'        industries,
#'        out,
#'        method = "wwz")



decomp <- function(iot, x, y, k, i, o, v,
                   method=c("leontief", "wwz" ),
                   verbose = FALSE,
                   ... ) {

    method <- match.arg(method)

    if(missing(v)) {
        v <- NULL
    }

  if ( missing(x) ) {
      decompr_obj <- load_tables_vectors(iot = iot)
  }  else {
      decompr_obj <- load_tables_vectors(x = x, y = y, k = k, i = i, o = o, v = v)
  }

  if ( method == "leontief" ) {
      out <- leontief(decompr_obj, ... )
  } else if (method == "wwz" ) {
      out <- wwz(decompr_obj, verbose = verbose)
  } else {
    stop('not a valid method')
  }

  return(out)

}
