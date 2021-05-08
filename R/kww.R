#' Koopman-Wang-Wei Decomposition of Gross Exports
#' 
#' This function performs the Koopman-Wang-Wei (2014) decomposition of a countries gross exports into 9 separate value added components.
#' 
#' @param x an object of the class 'decompr' obtained from \code{\link{load_tables_vectors}}.
#' @author Sebastian Krantz
#' @return A data frame where a countries gross exports is decomposed into 9 components (columns), as detailed in Figure 1 of the AER paper:
#'  \tabular{llll}{
#'  \emph{Term} \tab\tab\tab \emph{Description} \cr\cr\cr
#'  DVA_FIN \tab\tab\tab Domestic VA in final goods exports. \cr\cr\cr
#'  DVA_INT \tab\tab\tab Domestic VA in intermediate exports absorbed by direct importers (used to produce a locally consumed final good). \cr\cr\cr
#'  DVA_INTrex \tab\tab\tab Domestic VA in intermediate exports reexported to third countries and absorbed there. \cr\cr\cr
#'  RDV_FIN \tab\tab\tab Domestic VA in intermediate exports that returns home via final imports. \cr\cr\cr
#'  RDV_INT \tab\tab\tab Domestic VA in intermediate exports that returns home via intermediate imports (used to produce a domestically consumed final good). \cr\cr\cr
#'  DDC \tab\tab\tab Double counted DVA in intermediate exports (arising from 2-way trade in intermediate goods). \cr\cr\cr % (VA already captured in RDV_FIN and RDV_INT). -> Not strictly correct.
#'  FVA_FIN \tab\tab\tab Foreign VA in final goods exports.  \cr\cr\cr
#'  FVA_INT \tab\tab\tab Foreign VA in intermediate exports. \cr\cr\cr
#'  FDC \tab\tab\tab Double counted FVA in intermediate exports (arising from 2-way trade in intermediate goods). \cr % (VA already captured in FVA_INT). -> Not strictly correct.
#'  }
#' @references Koopman, R., Wang, Z., & Wei, S. J. (2014). Tracing value-added and double counting in gross exports. \emph{American Economic Review, 104}(2), 459-94.
#' @export
#' @seealso \code{\link{wwz}}, \code{\link{wwz2kww}}, \code{\link{decompr-package}}
#' @examples
#' # Load example data
#' data(leather)
#'
#' # Create intermediate object (class 'decompr')
#' decompr_object <- load_tables_vectors(leather)
#'  
#' # Perform the KWW decomposition
#' kww(decompr_object)
#' 



# Note: Sector level is false, only aggregated is correct !!
kww <- function(x) {
  
  if(!inherits(x, "decompr")) stop("x must be an object of class 'decompr' created by the load_tables_vectors() function.")
  
  B <- Y <- Vc <- N <- G <- GN <- Bd <- Ym <- Bm <- Yd <- Am <- L <- E <- k <- NULL # First need to initialize as NULL to avoid R CMD check error. 
  list2env(x, environment())
  
  # breaking up gross output according to where it is ultimately absorbed...
  Xc <- B %*% Y                  # Xc = 'Gross output decomposition matrix'
  VB <- Vc * B
  # Value added by destination of final absorption (domestic and exported VA)
  VBY <- Vc * Xc   # VBY = value-added production matrix (same as diag(Vc) %*% Xc)
  # Elements in the diagonal columns give each country’s production of value added absorbed at home. 
  # Exports of value added can be defined as the elements in the off-diagonal columns of this GN × G matrix
  i1 <- rep(1:N, G)
  i2 <- rep(0:(G-1L), each = N)
  idiag <- i1 + (N * i2) + (GN * i2)
  VBY[idiag] <- 0
  # Obviously it excludes value added produced by the home country that returns home after being processed abroad.
  
  # Terms 1-3: VA Exports
  vae <- rowSums(VBY)               # Total VA exports, which are broken down as follows: 
  T1 <- Vc * rowSums(Bd %*% Ym)     # VA in the country’s (direct) final goods exports to different importers.
  T2 <- Vc * drop(Bm %*% Yd[idiag]) # VA in the country’s intermediate exports used by the direct importer to produce final goods consumed by the direct importer.
  T3 <- vae - (T1 + T2)             # VA in the country’s intermediate exports used by the direct importer to produce final goods absorbed in third countries.

  # Now we consider the FVA and double counted terms (eventually absorbed at home) in gross exports. 
  
  # Terms 4-6: Domestic content in intermediate exports that finally returns home
  T4 <- Vc * (Bm %*% Ym)[idiag]     # DVA that is initially embodied in its intermediate exports but is returned home as part of imports of the final good.
  tmp <- Bm %*% Am %*% L
  T5 <- Vc * (tmp %*% Yd)[idiag]  # DVA that is initially embodied in intermediate goods exports but then returned home via intermediate imports to produce final goods that are absorbed at home.  
      # T4 and T5 are parts of the source country’s GDP but represent a double-counted portion in official gross export statistics (counted at least twice in trade statistics as they first leave Country 1 for Country 2, and then leave Country 2 for Country 1 and stay in country 1).
  Ediag <- Yd
  Ediag[idiag] <- E
  T6 <- Vc * (tmp %*% Ediag)[idiag] # Pure double-counted DVA in intermediate exports that return home and are already captured in T4 and T5 (exists only if two-way trade in intermediate goods, not part of countries GDP) we cannot directly see where they are absorbed.

  # Terms 7-9: Foreign VA
  T7 <- T8 <- T9 <- E
  ifac <- as.factor(i1[-(1:N)])
  Yms <- rowSums(Ym)                 # needed for T7
  AmLYds <- rowSums(Am %*% L %*% Yd) # Needed for T8
  for(s in 1:G) {
    is <- 1L + (s - 1L) * N
    is <- is:(is + N - 1L)
    tmp <- rowsum(x_OP_y(B, Vc, "*", -is, is, -is), ifac, reorder = FALSE) # x_OP_y statement same as Vc[-is] * B[-is, is] but faster # rowsum is the r sum, -is is the t sum...
    T7[is] <- tmp %*% Yms[is]        # FVA in final goods exports
    T8[is] <- tmp %*% AmLYds[is]     # FVA in intermediate goods exports
  }
  T9 <- E - (vae + T4 + T5 + T6 + T7 + T8)  # double counted intermediate exports produced abroad
  out <- list(T1, T2, T3, T4, T5, T6, T7, T8, T9)
  names(out) <- c("DVA_FIN", "DVA_INT", "DVA_INTrex", "RDV_FIN", "RDV_INT", "DDC", "FVA_FIN", "FVA_INT", "FDC")
  attr(out, "row.names") <- .set_row_names(GN)
  class(out) <- "data.frame"
  # Aggregating: Necessary, other wise not correct... (as seen in some negative values in T9 at sector level)
  out <- cbind(Country = structure(seq_along(k), levels = k, class = "factor"), 
               rowsum(out, rep(k, each = N), reorder = FALSE))
  attr(out, "row.names") <- .set_row_names(G)
  attr(out, "decomposition") <- "kww"
  out
}


#' Koopman-Wang-Wei from Wang-Wei-Zhu Decomposition
#' 
#' This function by default returns a disaggregated version of the the Koopman-Wang-Wei (KWW) decomposition breaking up sector-level gross exports into 9 value added terms,
#' from an already computed and more detailed (16 term) Wang-Wei-Zhu decomposition of sector-level gross exports. An aggregation option also allows obtaining the aggregate KWW decomposition. 
#' 
#' @param x a data frame with the WWZ decomposition obtained from \code{\link{wwz}}. Alternatively a 'decompr' class object from \code{\link{load_tables_vectors}} can be supplied, which will toggle calling \code{wwz()} first. 
#' @param aggregate logical. \code{TRUE} aggregates the KWW decomposition to the country level, giving exactly the same output as \code{\link{kww}}. \code{FALSE} maintains the sector level decomposition in KWW format. 
#' @details The mapping of the 16 terms in the WWZ decomposition to the 9 terms in the KWW decomposition is provided in table E2 in the appendix of the WWZ (2013) paper. The table is reproduced here using the term naming 
#' conventions followed in this package.
#'
#' \tabular{lllllll}{
#'  \emph{WWZ Terms} \tab\tab\tab \emph{KWW Term} \tab\tab\tab \emph{Description} \cr\cr\cr
#'  DVA_FIN \tab\tab\tab DVA_FIN \tab\tab\tab Domestic VA in final goods exports. \cr\cr\cr
#'  DVA_INT, DVA_INTrexI1 \tab\tab\tab DVA_INT \tab\tab\tab Domestic VA in intermediate exports absorbed by direct importers. 
#'  WWZ separates VA in final goods produced and consumed by direct importer from VA used by direct importer to produce intermediate exports for production of domestically consumed final goods 
#'  in third countries (i.e. the VA is absorbed by the direct importer, but it may be exported to third countries as intermediates first before returning to direct importer as final goods). \cr\cr\cr
#'  DVA_INTrexF, DVA_INTrexI2 \tab\tab\tab DVA_INTrex \tab\tab\tab Domestic VA in intermediate exports reexported to third countries and absorbed there. WWZ separates VA in final goods exports 
#'  of direct importer to third countries from VA in intermediate exports from direct importers to third countries (that is ultimately absorbed in third countries). \cr\cr\cr
#'  RDV_FIN, RDV_FIN2 \tab\tab\tab RDV_FIN \tab\tab\tab Domestic VA in intermediate exports that returns home via final imports. WWZ separates final imports from the direct importer and third countries. \cr\cr\cr
#'  RDV_INT \tab\tab\tab RDV_INT \tab\tab\tab Domestic VA in intermediate exports that returns via intermediate imports (i.e. is used to produce a locally consumed final good). \cr\cr\cr
#'  DDC_FIN, DDC_INT \tab\tab\tab DDC \tab\tab\tab Double counted Domestic Value Added in gross exports. WWZ separates double counting due to final and intermediate exports production. \cr\cr\cr
#'  MVA_FIN, OVA_FIN \tab\tab\tab FVA_FIN \tab\tab\tab Foreign VA in final goods exports. WWZ separates FVA from direct importer and from third countries.  \cr\cr\cr
#'  MVA_INT,  OVA_INT \tab\tab\tab FVA_INT \tab\tab\tab Foreign VA in intermediate exports. WWZ separates FVA from direct importer and from third countries. \cr\cr\cr
#'  MDC, ODC \tab\tab\tab FDC \tab\tab\tab Double counted Foreign Value Added in gross exports. WWZ separates FDC from direct importer and from third countries. \cr
#'  }
#'  
#' @author Sebastian Krantz
#' @return A data frame with exports decomposed into 9 components (columns), see the table above and \code{\link{kww}} for a shorter description of the 9 terms.
#' @note If both WWZ and KWW decompositions are required, it is computationally more efficient to call \code{wwz2kww(x, aggregate = TRUE)} on an already computed WWZ decomposition, than to call \code{\link{kww}} on a 'decompr' object. 
#' @references Koopman, R., Wang, Z., & Wei, S. J. (2014). Tracing value-added and double counting in gross exports. \emph{American Economic Review, 104}(2), 459-94.
#' 
#' Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu (2013). Quantifying international production sharing at the bilateral and sector levels (No. w19677). \emph{National Bureau of Economic Research}.
#' @export
#' @seealso \code{\link{wwz}}, \code{\link{kww}}, \code{\link{decompr-package}}
#' @examples
#' 
#' # Load example data
#' data(leather)
#'
#' # Create intermediate object (class 'decompr')
#' decompr_object <- load_tables_vectors(leather)
#'  
#' # Perform the WWZ decomposition
#' WWZ <- wwz(decompr_object)
#' 
#' # Obtain a disaggregated KWW decomposition
#' KWW <- wwz2kww(WWZ)
#' 
#' # Aggregate KWW 
#' wwz2kww(WWZ, aggregate = TRUE)
#' 
#' # Same as running KWW directly, but the former is more efficient 
#' # if we already have the WWZ
#' kww(decompr_object)

# This is correct, I checked it !!
wwz2kww <- function(x, aggregate = FALSE) {
  d <- attr(x, "decomposition")
  if(!is.data.frame(x) || is.null(d) || d != "wwz") {
    if(!inherits(x, "decompr")) stop("x must be a WWZ decomposition obtained from wwz(), or an object of class 'decompr' created by the load_tables_vectors() function.")
    x <- wwz(x)
  }
  y <- x[, 1:3]
  oldClass(x) <- NULL # Some extra $ subsetting speed
  y$DVA_FIN <- x$DVA_FIN
  y$DVA_INT <- x$DVA_INT + x$DVA_INTrexI1
  y$DVA_INTrex <- x$DVA_INTrexF + x$DVA_INTrexI2
  y$RDV_FIN <- x$RDV_FIN + x$RDV_FIN2
  y$RDV_INT <- x$RDV_INT
  y$DDC <- x$DDC_FIN + x$DDC_INT
  y$FVA_FIN <- x$OVA_FIN + x$MVA_FIN
  y$FVA_INT <- x$OVA_INT + x$MVA_INT
  y$FDC <- x$ODC + x$MDC
  if(!aggregate) return(`attr<-`(y, "decomposition", "kww"))
  out <- cbind(Country = unique(x$Exporting_Country), 
               rowsum(y[, -(1:3)], x$Exporting_Country, reorder = FALSE))
  row.names(out) <- NULL
  attr(out, "decomposition") <- "kww"
  out
}


# Attempt to calculate KWW faster from aggregating intermediate input matrices and inverting... not finished 
# kww0 <- function(x, inter) {
#   list2env(x, environment())
#   kvec <- factor(rep(k, each = N), levels = k)
#   Yc <- rowsum(Y, kvec)
#   IOc <- t(rowsum(t(rowsum(inter, kvec)), kvec))
#   o <- drop(rowsum(X, kvec))
#   
#   A <- IOc / outer(rep.int(1L, G), o) # Significantly faster than:  t(t(x) / o)
#   A[!is.finite(A)] <- 0
#   
#   II <- diag(G)
#   Bc <- solve(II - A)
#   # t(rowsum(t(rowsum(B, kvec)), kvec))  # Not the same as BC, unfortunately...
#   
#   # breaking up gross output according to where it is ultimately absorbed...
#   Xc <- Bc %*% Yc # Xc = 'Gross output decomposition matrix'
#   Vc <- drop(rowsum(Vc * X, kvec) / o)
#   VBc <- diag(Vc) %*% Bc
#   dimnames(VBc) <- dimnames(Bc)
#   # Value added by destination of final absorption (domestic and exported VA)
#   VAc <- Xc * Vc
#   # ...  
# }
