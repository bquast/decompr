#' Wang-Wei-Zhu Decomposition of Gross Exports
#' 
#' This function performs the Wang-Wei-Zhu decomposition of country-sector level gross exports into 16 value added components by importing country.
#' 
#' @param x an object of the class 'decompr' obtained from \code{\link{load_tables_vectors}}.
#' @param verbose logical, should timings of the calculation be displayed? Default is FALSE
#' @author Bastiaan Quast
#' @details Adapted from code by Fei Wang.
#' @return A data frame with exports decomposed into 16 components (columns), as detailed in Table E1 in the appendix of the paper, and additional diagnostic items:
#'  \tabular{llll}{
#'  \emph{Term} \tab\tab\tab \emph{Description} \cr\cr\cr
#'  DVA_FIN \tab\tab\tab Domestic VA in final goods exports. \cr\cr\cr
#'  DVA_INT \tab\tab\tab Domestic VA in intermediate exports used by direct importer to produce domestic final goods consumed at home. \cr\cr\cr
#'  DVA_INTrexI1 \tab\tab\tab Domestic VA in intermediate exports used by the direct importer to produce intermediate exports for production of final goods in third countries that are then imported and consumed by the direct importer. \cr\cr\cr
#'  DVA_INTrexF \tab\tab\tab Domestic VA in intermediate exports used by the direct importer to produce final goods exports to third countries. \cr\cr\cr
#'  DVA_INTrexI2 \tab\tab\tab Domestic VA in Intermediate exports used by the direct importer to produce intermediate exports to third countries. \cr\cr\cr
#'  RDV_INT \tab\tab\tab Domestic VA in intermediate exports that returns via intermediate imports (i.e. is used to produce a locally consumed final good). \cr\cr\cr
#'  RDV_FIN \tab\tab\tab Domestic VA in intermediate exports that returns home via final goods imports from the direct importer. \cr\cr\cr
#'  RDV_FIN2 \tab\tab\tab Domestic VA in intermediate exports that returns home via in final goods imports from third countries. \cr\cr\cr
#'  OVA_FIN \tab\tab\tab Third countries’ VA in final goods exports. \cr\cr\cr
#'  MVA_FIN \tab\tab\tab Direct importer’s VA in final goods exports. \cr\cr\cr
#'  OVA_INT \tab\tab\tab Third countries’ VA in intermediate exports. \cr\cr\cr
#'  MVA_INT \tab\tab\tab Direct importer’s VA in intermediate exports. \cr\cr\cr
#'  DDC_FIN \tab\tab\tab Double counted Domestic VA used to produce final goods exports. \cr\cr\cr
#'  DDC_INT \tab\tab\tab Double counted Domestic VA used to produce intermediate exports. \cr\cr\cr
#'  ODC \tab\tab\tab Double counted third countries’ VA in home country’s exports production. \cr\cr\cr
#'  MDC \tab\tab\tab Double counted direct importer’s VA in home country’s exports production. \cr\cr\cr\cr\cr\cr\cr
#'  \emph{Diagnostic Item} \tab\tab\tab \emph{Description} \cr\cr\cr
#'  texp \tab\tab\tab Total Exports (matrix 'ESR' from \code{\link{load_tables_vectors}}). \cr\cr\cr
#'  texpint \tab\tab\tab Exports for intermediate production (matrix 'Eint' from \code{\link{load_tables_vectors}}). \cr\cr\cr
#'  texpfd \tab\tab\tab Exports for final demand (matrix 'Efd' from \code{\link{load_tables_vectors}}). \cr\cr\cr
#'  texpdiff \tab\tab\tab Difference between Total Exports and the sum of the 16 terms. \cr\cr\cr
#'  texpdiffpercent \tab\tab\tab ... in percent of total exports. \cr\cr\cr
#'  texpfddiff \tab\tab\tab Difference between Final Exports and the sum of terms DVA_FIN, OVA_FIN and MVA_FIN. \cr\cr\cr
#'  texpfddiffpercent \tab\tab\tab ... in percent of final exports. \cr\cr\cr
#'  texpintdiff \tab\tab\tab Difference between Intermediate Exports and the sum of all the remaining terms (except DVA_FIN, OVA_FIN and MVA_FIN). \cr\cr\cr
#'  texpintdiffpercent \tab\tab\tab ... in percent of intermediate exports. \cr\cr\cr
#'  DViX_Fsr \tab\tab\tab DVA embodied in gross exports based on forward linkage. \cr
#'  }
#' @references Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu (2013). Quantifying international production sharing at the bilateral and sector levels (No. w19677). \emph{National Bureau of Economic Research}.
#' @export
#' @seealso \code{\link{kww}}, \code{\link{wwz2kww}}, \code{\link{decompr-package}}
#' @examples
#' # Load example data
#' data(leather)
#' 
#' # Create intermediate object (class 'decompr')
#' decompr_object <- load_tables_vectors(leather)
#' 
#' # Perform the WWZ decomposition
#' wwz(decompr_object)

wwz <- function(x, verbose = FALSE) {
    
    if(!inherits(x, "decompr")) stop("x must be an object of class 'decompr' created by the load_tables_vectors() function.")
    
    # This loads all the elements into the current function namespace, and avoids 165 calls to x$... some of which are done inside loops.
    GN <- G <- ESR <- Eint <- Efd <- Bd <- Vc <- Ym <- L <- Am <- Yd <- N <- Bm <- X <- E <- k <- i <- NULL # First need to initialize as NULL to avoid R CMD check error. 
    list2env(x, environment())
    
    ## Part 1: Decomposing Export into VA (16 items) defining ALL to
    ## contain all decomposed results
    ALL <- array(0, dim = c(GN, G, 19L))
    
    ## the order of 16 items and exp, expint, expfd
    decomp19 <- c("DVA_FIN",            # term #01 in equation (19)
                  "DVA_INT",            # term #02 in equation (19)
                  "DVA_INTrexI1",       # term #03 in equation (19)
                  "DVA_INTrexF",        # term #04 in equation (19)
                  "DVA_INTrexI2",       # term #05 in equation (19)
                  "RDV_INT",            # term #06 in equation (19)
                  "RDV_FIN",            # term #07 in equation (19)
                  "RDV_FIN2",           # term #08 in equation (19)
                  "OVA_FIN",            # term #09 in equation (19)
                  "MVA_FIN",            # term #10 in equation (19)
                  "OVA_INT",            # term #11 in equation (19)
                  "MVA_INT",            # term #12 in equation (19)
                  "DDC_FIN",            # term #13 in equation (19)
                  "DDC_INT",            # term #14 in equation (19)
                  "ODC",                # term #15 in equation (19)
                  "MDC",                # term #16 in equation (19)
                  "texp",               
                  "texpint",
                  "texpfd")
    
    ALL[, , 17L] <- ESR
    ALL[, , 18L] <- Eint
    ALL[, , 19L] <- Efd
    ## Eint <- NULL
    ## Efd <- NULL
    
    # Unit vector will come in handy in several places
    # u <- rep.int(1L, GN)
    
    ##
    ## all Terms are numbered as in Table A2 in the Appendix of WWZ
    ## 

    if(verbose) {
        message("Starting decomposing the trade flow ...")
        start <- Sys.time()
    }
    ## 
    ## DVA_FIN: DVA embodied in final exports (foreign final demand)
    ##

    ## Term 1
    Bd_Vhat_sum <- colSums(Bd * Vc)
    ALL[, , 1L] <- Ym * Bd_Vhat_sum
    # for (r in 1:G) ALL[, r, 1L] <- colSums(Bd_Vhat * outer(u, Ym[, r]))
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("1/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }
    
    ## 
    ## DVA_INT: DVA in intermediate exports used by direct importer (r) to produce local final products
    ## 

    VsLss <- Vc * L
    ## try to calculate DViX_Fsr
    DViX_Fsr <- t(VsLss %*% ESR)
    dim(DViX_Fsr) <- NULL
    
    ## Term 2
    VsLss_colSums <- colSums(VsLss)
    rm(VsLss)
    
    ALL[, , 2L] <- Am %*% Bd %*% Yd * VsLss_colSums

    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("2/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }



    ##
    ## DVA_INTrex: 
    ## 

    ## Term 3: DVA in intermediate exports used to produce intermediates that are re-exported to third countries for production of local final products
    z1 <- matrix(rowSums(Yd), nrow = GN, ncol = GN)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z1[mn, mn] <- 0
    }

    z2 <- Bm %*% z1
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z2[mn, mn] <- 0
    }

    z3 <- Am * t(z2)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 3L] <- VsLss_colSums * rowSums2(z3, cols = mn)
    }
    rm(z3)
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("3/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }    
    
    ## Term 4: DVA in intermediate exports used by r to produce final products that are re-exported to third countries.
    z <- matrix(0, nrow = GN, ncol = GN)
    z1 <- rowSums(Ym)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z[, mn] <- z1 - Ym[, r]
        z[mn, mn] <- 0
    }
    
    z2 <- Am * t(Bd %*% z)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 4L] <- VsLss_colSums * rowSums2(z2, cols = mn)
    }
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("4/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }    
    
    ## Term 5: DVA in intermediate exports used by r to produce intermediates that are re-exported to t for the latter’s production of final exports that are shipped to other countries except Country s
    z1 <- t(Bm %*% z)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z1[mn, mn] <- 0
    }
    
    z2 <- Am * z1
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 5L] <- VsLss_colSums * rowSums2(z2, cols = mn)
    }
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("5/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }
    

    ##
    ## RDV_G
    ## 

    
    
    ## Term 6: DVA that returns home via its final imports from r
    z <- matrix(0, nrow = GN, ncol = GN)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z[, mn] <- Yd[, r]
    }
    
    z1 <- Am * t(Bm %*% z)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 6L] <- VsLss_colSums * rowSums2(z1, cols = mn)
    }
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("6/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }    
    
    ## Term 7: DVA that returns home via final imports from third countries
    z <- matrix(0, nrow = GN, ncol = GN)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z[, mn] <- Ym[, r]
    }
    
    z1 <- Am * t(Bd %*% z)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 7L] <- VsLss_colSums * rowSums2(z1, cols = mn)
    }
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("7/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }
    
    
    ## Term 8: DVA that returns home via its intermediate imports and used to produce domestic final products
    z1 <- Bm %*% z
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z1[mn, mn] <- 0
    }
    
    z2 <- Am * t(z1)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 8L] <- VsLss_colSums * rowSums2(z2, cols = mn)
    }
    rm(z2)
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("8/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }    
    

    ##
    ## DDC
    ## 

    ## Part 2-9 == H10-(9): DDC_FIN OK ! : DVA embodied in its intermediate exports to Country r but returns home as its intermediate imports, and used for production of its final exports
    z <- matrix(0, nrow = GN, ncol = GN)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        z[mn, mn] <- rowSums2(Ym, rows = mn)
    }
    
    z1 <- Am * t(Bm %*% z)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 13L] <- VsLss_colSums * rowSums2(z1, cols = mn)
    }
    rm(z1)
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("9/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }
    
    ## Part 2-10 == H10-(10): DDC_INT
    Am_X <- .Call(C_rowmult, Am, X) # Am * outer(u, X)
    Vc_Bd_VsLss_colsums <- Bd_Vhat_sum - VsLss_colSums
    
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ALL[, r, 14L] <- Vc_Bd_VsLss_colsums * rowSums2(Am_X, cols = mn)
    }
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("10/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }    
    ## Part 2-11 == H10-(11): MVA_FIN =[ VrBrs#Ysr ] H10-(14): OVA_FIN =[
    ## Sum(VtBts)#rYsr ] OK !
    ## VrBrs <- Vhat %*% Bm            # TODO
    VrBrs <- Vc * Bm
    # YYsr <- matrix(0, nrow = GN, ncol = GN)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 
        ## YYsr[, 1:GN] <- Ym[, r]
        ## z <- VrBrs * t(YYsr)
        ## just as fast, but more memory efficient
        z <- .Call(C_rowmult, VrBrs, Ym[, r]) # VrBrs * outer(u, Ym[, r])
        ALL[, r, 9L] <- colSums2(z, rows = -mn)  # OVA_FIN[ ,r ]
        ALL[, r, 10L] <- colSums2(z, rows = mn)  # MVA_FIN[ ,r ]
    }
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("12/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }
    ## 
    ## MVA_FIN
    ## 
    
    ## Part 2-12 == H10-(12):
    ## MVA_INT =[ VrBrs#AsrLrrYrr ] H10-(15): OVA_INT =[
    ## Sum(VtBts)#AsrLrrYrr ] OK !

    # YYrr <- matrix(0, nrow = GN, ncol = GN)
    Am_L_t <- t(Am %*% L)
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q) 

        ## message("r: ", r, "  --> m: ", m, "  n: ", n)
        ## YYrr[, 1:GN] <- Yd[, r]
        ## z <- VrBrs * t(Am_L %*% YYrr)
        
        ## better is:
        zz <- colSums(Am_L_t * Yd[, r])
        z <- .Call(C_rowmult, VrBrs, zz) # VrBrs * outer(u, zz)
                
        ALL[, r, 11L] <- colSums2(z, rows = -mn)  #   OVA_INT[ ,r ]
        ALL[, r, 12L] <- colSums2(z, rows = mn)  #  MVA_INT[ ,r ]
    }
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("14/16, elapsed time: ", elapsed, " seconds")
        start <- Sys.time()
    }    
    ## Part 2-13 == H10-(13): MDC
    ## =[ VrBrs#AsrLrrEr* ] == H10-(16): ODC =[ Sum(VtBts)#AsrLrrEr* ] OK !
    # Er <- rep.int(0L, GN)
    Am_L_t <- Am_L_t * E
    for (r in 1:G) {
        q <- (r - 1L) * N
        mn <- (1L + q):(N + q)

        ## EEr <- matrix(0, nrow = GN, ncol = GN)
        ## EEr[m:n, 1:GN] <- E[m:n]
        ## z <- VrBrs * t(Am_L %*% EEr)
        # zz <- colSums(Am_L_t * `[<-`(Er, m:n, value = E[m:n]))
        zz <- colSums2(Am_L_t, rows = mn)
        z <- .Call(C_rowmult, VrBrs, zz) # VrBrs * outer(u, zz)

        ALL[, r, 15L] <- colSums2(z, rows = -mn)  # ODC[ ,r ]
        ALL[, r, 16L] <- colSums2(z, rows = mn)  # MDC[ ,r ]
    }
    rm(Am_L_t, VrBrs)
    
    if(verbose) {
        elapsed <- round(Sys.time() - start, digits = 3L)
        message("16/16, elapsed time: ", elapsed, " seconds")
    }
    
    

    
    # dimnames(ALL) <- list(rownam, k, decomp19)

    ## 
    ## Part 3
    ## Putting all results in one sheet

    ALLandTotal <- aperm(ALL, c(2L, 1L, 3L)) 
    dim(ALLandTotal) <- c(GN * G, 19L)
    dimnames(ALLandTotal)[[2L]] <- decomp19

    ## rm(ALL)
    # rownames(ALLandTotal) <- NULL  #bigrownam

    ## 
    ## Part 4
    ## checking the differences resulted in texp, texpfd, texpintdiff

    ## Total Export goods difference
    texpdiff <- rowSums2(ALLandTotal, cols = 1:16) - ALLandTotal[, 17L]
    texpdiffpercent <- texpdiff / ALLandTotal[, 17L] * 100
    texpdiffpercent[is.na(texpdiffpercent)] <- 0
    texpdiff <- round(texpdiff, 4L)
    texpdiffpercent <- round(texpdiffpercent, 4L)

    ## Total Export Final goods difference
    texpfddiff <- rowSums2(ALLandTotal, cols = c(1L, 9L, 10L)) - ALLandTotal[, 19L]
    texpfddiffpercent <- texpfddiff / ALLandTotal[, 19L] * 100
    texpfddiffpercent[is.na(texpfddiffpercent)] <- 0
    texpfddiff <- round(texpfddiff, 4L)
    texpfddiffpercent <- round(texpfddiffpercent, 4L)

    ## Total intermediate export goods difference
    texpintdiff <- rowSums2(ALLandTotal, cols = c(2:8, 11:16)) - ALLandTotal[, 18L]
    texpintdiffpercent <- texpintdiff/ALLandTotal[, 18L] * 100
    texpintdiffpercent[is.na(texpintdiffpercent)] <- 0
    texpintdiff <- round(texpintdiff, 4L)
    texpintdiffpercent <- round(texpintdiffpercent, 4L)
    
    sk <- seq_along(k)
    ALLandTotal <- c(list(Exporting_Country = structure(rep(sk, each = GN), levels = k, class = "factor"),
                          Exporting_Industry = structure(rep(seq_along(i), times = G, each = G), levels = i, class = "factor"),
                          Importing_Country = structure(rep(sk, times = GN), levels = k, class = "factor")),
                        setNames(lapply(1:ncol(ALLandTotal), function(i) ALLandTotal[, i]), colnames(ALLandTotal)),
                        list(texpdiff = texpdiff,
                        texpdiffpercent = texpdiffpercent,
                        texpfddiff = texpfddiff,
                        texpfddiffpercent = texpfddiffpercent,
                        texpintdiff = texpintdiff,
                        texpintdiffpercent = texpintdiffpercent,
                        DViX_Fsr = DViX_Fsr))
     
    attr(ALLandTotal, "row.names") <- .set_row_names(GN * G)    
    class(ALLandTotal) <- "data.frame"

    attr(ALLandTotal, "decomposition") <- "wwz"
    
    return(ALLandTotal)
}
