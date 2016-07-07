#' Runs the Wang-Wei-Zhu decomposition
#' 
#' This function runs the Wang-Wei-Zhu decomposition.
#' 
#' @param x an object of the class decompr
#' @return the decomposed table
#' @author Bastiaan Quast
#' @details Adapted from code by Fei Wang.
#' @references Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu.
#' Quantifying international production sharing at the bilateral and sector levels. 
#' No. w19677. National Bureau of Economic Research, 2013.
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
#'                                       out        )
#' 
#' # run the WWZ decomposition on the decompr object
#' wwz(decompr_object)

library(haven)
library(decompr)
library(microbenchmark)
## path <- "W:/00_POOL/02 PROJECT PIPELINE/UNIDO - Global Value Chains and International Cooperation/data/OECD_ICIO/IOtables"

## setwd(path)
## (file <- list.files(pattern = "STATA12.dta$")[1])
## tab <- as.data.table(read_dta(file))

## Amat <- as.matrix(tab[grepl("^v", column_names), .SD, .SDcols = colnames(tab)[grepl("^v", 
##     colnames(tab))]])
## FD <- as.matrix(tab[grepl("^v", column_names), .SD, .SDcols = colnames(tab)[grepl("^zfd.+hc$", 
##     colnames(tab))]])
## countries <- unique(substring(colnames(FD), 5, 7))
## industries <- unique(substring(colnames(Amat)[1:100], 7, 100))
## output <- unlist(tab[column_names == "zzz_OUT", .SD, .SDcols = colnames(tab)[grepl("^v", 
##     colnames(tab))], drop = TRUE])

## x <- load_tables_vectors(Amat, FD, countries, industries, output)

x <- load_tables_vectors(Amat, FD, as.vector(countries),
                         1:64, as.vector(go))
res <- wwz(x)

hd <- function(x) x[1:10, 1:10]
test <- function(x1, x2) {
    dimnames(x1) <- NULL
    dimnames(x2) <- NULL
    identical(x1, x2)
}

wwz <- function(x) {
    
    ## Part 1: Decomposing Export into VA( 16 items ) defining ALL to
    ## contain all decomposed results
    ALL <- array(0, dim = c(x$GN, x$G, 19))
    
    ## the order of 16 items and exp, expint, expfd
    decomp19 <- c("DVA_FIN",
                  "DVA_INT",
                  "DVA_INTrexI1",
                  "DVA_INTrexF",
                  "DVA_INTrexI2",
                  "RDV_INT",
                  "RDV_FIN",
                  "RDV_FIN2",
                  "OVA_FIN",
                  "MVA_FIN",
                  "OVA_INT",
                  "MVA_INT",
                  "DDC_FIN",
                  "DDC_INT",
                  "ODC",
                  "MDC",
                  "texp",
                  "texpint",
                  "texpfd")
    
    ALL[, , 17] <- x$ESR
    ALL[, , 18] <- x$Eint
    ALL[, , 19] <- x$Efd
    x$Eint <- NULL
    x$Efd <- NULL

    
    ##
    ## all Terms are numbered as in Table A2 in the Appendix of WWZ
    ## 

    
    ## 
    ## DVA_FIN
    ##

    ## Term 1
    Vhat.diag <- diag(x$Vhat)
    Bd_Vhat <- x$Bd * Vhat.diag
    for (r in 1:x$G) {
        Ym.country <- x$Ym[, r]
        ALL[, r, 1] <- colSums(sweep(Bd_Vhat, 2, Ym.country, `*`))
    }


    
    ## 
    ## DVA_INT
    ## 

    ## Term 2
    VsLss <- Vhat.diag * x$L
    VsLss.colSums <- colSums(VsLss)
    Am_Bd_Yd <- x$Am %*% x$Bd %*% x$Yd
    
    for (r in 1:x$G) {
        ALL[, r, 2] <- VsLss.colSums * t(Am_Bd_Yd[, r])
    }




    ##
    ## DVA_INTrex
    ## 

    ## Term 3
    z1 <- matrix(rowSums(x$Yd), nrow = x$GN, ncol = x$GN)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z1[m:n, m:n] <- 0
    }

    z2 <- (x$Bm %*% z1)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z2[m:n, m:n] <- 0
    }

    
    z3 <- x$Am * t(z2)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 3] <- VsLss.colSums * (rowSums(z3[, m:n]))
    }
    
    
    ## Term 4
    z <- matrix(0, nrow = x$GN, ncol = x$GN)
    z1 <- rowSums(x$Ym)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z[, m:n] <- z1 - x$Ym[, r]
        z[m:n, m:n] <- 0
    }
    
    z2 <- x$Am * t(x$Bd %*% z)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 4] <- VsLss.colSums * (rowSums(z2[, m:n]))
    }
    
    
    ## Term 5
    z1 <- t(x$Bm %*% z)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z1[m:n, m:n] <- 0
    }
    
    z2 <- x$Am * z1
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 5] <- VsLss.colSums * (rowSums(z2[, m:n]))
    }

    

    ##
    ## RDV_G
    ## 

    
    
    ## Term 6
    z <- matrix(0, nrow = x$GN, ncol = x$GN)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z[, m:n] <- x$Yd[, r]
    }
    
    z1 <- x$Am * t(x$Bm %*% z)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 6] <- VsLss.colSums * (rowSums(z1[, m:n]))
    }
    
    ## Term 7
    z <- matrix(0, nrow = x$GN, ncol = x$GN)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z[, m:n] <- x$Ym[, r]
    }
    
    z1 <- x$Am * t(x$Bd %*% z)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 7] <- VsLss.colSums * (rowSums(z1[, m:n]))
    }
    
    
    ## Term 8
    z1 <- x$Bm %*% z
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z1[m:n, m:n] <- 0
    }
    
    z2 <- x$Am * t(z1)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 8] <- VsLss.colSums * (rowSums(z2[, m:n]))
    }
    
    

    ##
    ## DDC
    ## 

    ## Part 2-9 == H10-(9): DDC_FIN OK !
    z <- matrix(0, nrow = x$GN, ncol = x$GN)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        z[m:n, m:n] <- rowSums(x$Ym[m:n, ])
    }
    
    z1 <- x$Am * t(x$Bm %*% z)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 13] <- VsLss.colSums * (rowSums(z1[, m:n]))
    }

    
    ## Part 2-10 == H10-(10): DDC_INT

    ## z.1 <- x$Am %*% diag(x$X)
    Am_X <- t(t(x$Am) * x$X)
    Vc_Bd_VsLss.colsums <- colSums((x$Vc * x$Bd) - VsLss)    
    
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        ALL[, r, 14] <- Vc_Bd_VsLss.colsums * (rowSums(Am_X[, m:n]))
    }
    
    ## Part 2-11 == H10-(11): MVA_FIN =[ VrBrs#Ysr ] H10-(14): OVA_FIN =[
    ## Sum(VtBts)#rYsr ] OK !
    VrBrs <- x$Vhat %*% x$Bm
    YYsr <- matrix(0, nrow = x$GN, ncol = x$GN)
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        YYsr[, 1:x$GN] <- x$Ym[, r]
        z <- VrBrs * t(YYsr)
        ALL[, r, 10] <- colSums(z[m:n, ])  # MVA_FIN[ ,r ]
        ALL[, r, 9] <- colSums(z[-c(m:n), ])  # OVA_FIN[ ,r ]
    }

    ## 
    ## MVA_FIN
    ## 
    
    ## Part 2-12 == H10-(12):
    ## MVA_INT =[ VrBrs#AsrLrrYrr ] H10-(15): OVA_INT =[
    ## Sum(VtBts)#AsrLrrYrr ] OK !
    YYrr <- matrix(0, nrow = x$GN, ncol = x$GN)
    Am_L <- x$Am %*% x$L
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        YYrr[, 1:x$GN] <- x$Yd[, r]
        z <- VrBrs * t(Am_L %*% YYrr)        
        ALL[, r, 12] <- colSums(z[m:n, ])  #  MVA_INT[ ,r ]
        ALL[, r, 11] <- colSums(z[-c(m:n), ])  #   OVA_INT[ ,r ]
    }
    
    ## Part 2-13 == H10-(13): MDC
    ## =[ VrBrs#AsrLrrEr* ] == H10-(16): ODC =[ Sum(VtBts)#AsrLrrEr* ] OK !
    for (r in 1:x$G) {
        m <- 1 + (r - 1) * x$N
        n <- x$N + (r - 1) * x$N
        EEr <- matrix(0, nrow = x$GN, ncol = x$GN)
        EEr[m:n, 1:x$GN] <- x$E[m:n, 1]
        z <- VrBrs * t(Am_L %*% EEr)
        ALL[, r, 16] <- colSums(z[m:n, ])  # MDC[ ,r ]
        ALL[, r, 15] <- colSums(z[-c(m:n), ])  # ODC[ ,r ]
    }
    ## rm( EEr, z, VrBrs )
    
    
    ###### try to calculate DViX_Fsr
    DViX_Fsr <- VsLss %*% x$ESR
    DViX_Fsr <- t(DViX_Fsr)
    dim(DViX_Fsr) <- c(x$GN * x$G, 1)
    
    dimnames(ALL) <- list(x$rownam, x$k, decomp19)
    
    
    ## Part 3
    ## Putting all results in one sheet

    ALLandTotal <- NULL
    for (u in 1:x$GN) {
        ALLandTotal <- rbind(ALLandTotal, ALL[u, , ])
    }
    
    ## rm(ALL)
    rownames(ALLandTotal) <- NULL  #x$bigrownam

    ## 
    ## Part 4
    ## checking the differences resulted in texp, texpfd, texpintdiff
    
    texpdiff <- rowSums(ALLandTotal[, 1:16]) - ALLandTotal[, 17]
    
    texpfddiff <- ALLandTotal[, 1] + ALLandTotal[, 9] + ALLandTotal[, 10] - 
        ALLandTotal[, 19]
    
    texpintdiff <- rowSums(ALLandTotal[, 2:8]) + rowSums(ALLandTotal[, 
        11:16]) - ALLandTotal[, 18]
    
    texpdiffpercent <- texpdiff/ALLandTotal[, 17] * 100
    texpdiffpercent[is.na(texpdiffpercent)] <- 0
    texpfddiffpercent <- texpfddiff/ALLandTotal[, 19] * 100
    texpfddiffpercent[is.na(texpfddiffpercent)] <- 0
    texpintdiffpercent <- texpintdiff/ALLandTotal[, 18] * 100
    texpintdiffpercent[is.na(texpintdiffpercent)] <- 0
    texpdiff <- round(texpdiff, 4)
    texpfddiff <- round(texpfddiff, 4)
    texpintdiff <- round(texpintdiff, 4)
    texpdiffpercent <- round(texpdiffpercent, 4)
    texpfddiffpercent <- round(texpfddiffpercent, 4)
    texpintdiffpercent <- round(texpintdiffpercent, 4)
    
    ALLandTotal <- data.frame(rep(x$k, each = length(x$k) * length(x$i)),
                              rep(x$i, times = length(x$k),
                                  each = length(x$k)),
                              rep(x$k, times = length(x$k) * length(x$i)),
                              ALLandTotal,
                              texpdiff,
                              texpfddiff,
                              texpintdiff,
                              texpdiffpercent,
                              texpfddiffpercent,
                              texpintdiffpercent,
                              DViX_Fsr)
    
    names(ALLandTotal)[1:3] <- c("Exporting_Country",
                                 "Exporting_Industry",
                                 "Importing_Country")
    
    attr(ALLandTotal, "decomposition") <- "wwz"
    
    return(ALLandTotal)
    
}
