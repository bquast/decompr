#' Runs the WWZ decomposition
#' 
#' This function runs the decomposition
#' 
#' @param input.file the file which is
#'  created by the load.demand function
#' @param return.totals logical as to whether totals should be included in the output
#' @return the decomposed table
#' @author Bastiaan Quast
#' @details Adapted from code by Fei Wang.
#' @export

wwz <- function( input.object, return.totals=FALSE ) {
  
  # Part 1: loading data A,L,Vc, X, Y, E,ESR, etc.
  attach( input.object )
  
  # Part 2: Decomposing Export into VA( 16 items )
  # defining ALL to contain all decomposed results
  ALL  <- array( 0,dim=c( GN, G, 19 ) )
  
  # the order of 16 items and exp, expint, expfd
  decomp19 <- c(  "DVA_FIN",
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
                  "texpfd"
  )
  
  
  ALL[ ,,17 ] <- ESR
  ALL[ ,,18 ] <- Eint
  ALL[ ,,19 ] <- Efd
  
  
  ### find out why this returns an error
  # rm( Eint, Efd )
  gc(  )
  
  # Part 2-1 == H10-(1): DVA_FIN=[ VsBss#Ysr ]
  # OK
  for ( r in 1: G ) {
    z1 <- array(Ym[,r ], dim=c( GN, GN))
    ALL[ ,r,1 ]  <- colSums( diag(Vc)%*%Bd*t(z1) )
  }
  
  rm( z1 )
  gc(  )
  
  # View( ALL[ ,,1 ] )   # DVA_FIN
  
  # Part 2-2 == H10-(2): DVA_INT
  
  # OK
  VsLss <- diag( Vc )%*%L
  z1 <- Am%*%Bd%*%Yd
  for ( r in 1: G ) {
    # r=2
    ALL[ ,r,2 ] <- colSums(VsLss)*t(z1[ ,r ])
  }
  
  rm( z1 )
  gc(  )
  
  # View( ALL[ ,,2 ] )   #  DVA_INT
  
  # Part 2-3: H10-(3): DVA_INTrexI1
  # OK
  z1 <- array(rowSums( Yd), dim=c( GN,GN))
  for ( tt in 1: G ) {
    m=1+( tt-1 )*N; n=N+(tt-1)*N
    z1[ m:n,m:n ] <- 0
  }
  z2 <- Bm%*%z1
  for ( tt in 1: G ) {
    m=1+( tt-1 )*N; n=N+(tt-1)*N
    z2[ m:n,m:n ] <- 0
  }
  z3 <- Am*t( z2 )
  for ( r in 1: G ) {
    m=1+( r-1 )*N
    
    n=N+(r-1)*N
    ALL[ ,r,3 ] <- colSums(VsLss)*(rowSums(z3[ ,m:n ]))
  }
  rm( z1,z2,z3 )
  gc()
  # View( ALL[ ,,3 ] )  #  DVA_INTrexI1
  
  # Part 2-4: H10-(4): DVA_INTrexF
  # OK
  z <- array( 0, dim=c( GN,GN ) )
  z1 <- rowSums( Ym )
  for ( tt in 1:G ){
    m <- 1+( tt-1 )*N; n <-N+(tt-1)*N
    z[,m:n] <- z1 - Ym[ ,tt ]
    z[ m:n,m:n ] <- 0
  }
  
  z2 <- Am*t( Bd%*%z )
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    ALL[ ,r,4 ] <- colSums(VsLss)*(rowSums(z2[ ,m:n ]))
  }
  rm( z1,z2 )
  gc()
  
  # Part 2-5: H10-(5): DVA_INTrexI2
  # OK !
  z1 <- t(Bm%*%z)
  for ( tt in 1:G ){
    m <- 1+( tt-1 )*N; n <-N+(tt-1)*N
    z1[ m:n,m:n ] <- 0
  }
  z2 <- Am*z1
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    ALL[ ,r,5 ] <- colSums(VsLss)*(rowSums(z2[ ,m:n ]))
  }
  rm( z,z1,z2 )
  gc()
  #  View( ALL[ ,,5 ] )  #  DVA_INTrexI2
  
  # Part 2-6: H10-(6): RDV_FIN
  # OK !
  z <- array( 0, dim=c( GN,GN ) )
  for ( tt in 1:G ){
    m <- 1+( tt-1 )*N; n <-N+(tt-1)*N
    z[,m:n] <-  Ym[ ,tt ]
  }
  z1 <- Am*t( Bd%*%z )
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    ALL[ ,r,7 ] <- colSums(VsLss)*(rowSums(z1[ ,m:n ]))
  }
  rm( z1 )
  gc()
  # View( ALL[ ,,7 ] )  #  RDV_FIN
  
  # Part 2-7 == H10-(7): RDV_FIN2
  # OK !
  z1 <- Bm%*%z
  for ( tt in 1:G ){
    m <- 1+( tt-1 )*N; n <-N+(tt-1)*N
    z1[ m:n,m:n ] <- 0
  }
  z2 <- Am*t( z1 )
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    ALL[ ,r,8 ] <- colSums(VsLss)*(rowSums(z2[ ,m:n ]))
  }
  rm( z,z1,z2 )
  gc()
  
  # View( ALL[ ,,8 ] )  #  RDV_FIN2
  
  # Part 2-8 == H10-(8): RDV_INT
  # OK !
  z <- array( 0, dim=c( GN,GN ) )
  for ( tt in 1:G ){
    m <- 1+( tt-1 )*N; n <-N+(tt-1)*N
    z[,m:n] <-  Yd[ ,tt ]
  }
  z1 <- Am*t( Bm%*%z )
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    ALL[ ,r,6 ] <- colSums(VsLss)*(rowSums(z1[ ,m:n ]))
  }
  rm( z,z1 )
  gc()
  
  # View( ALL[ ,,6 ] )  #  RDV_INT
  # Part 2-9 == H10-(9): DDC_FIN
  # OK !
  z <- array( 0, dim=c( GN,GN ) )
  for ( tt in 1:G ){
    m <- 1+( tt-1 )*N; n <-N+(tt-1)*N
    z[m:n,m:n] <-  rowSums( Ym[ m:n, ] )
  }
  z1 <- Am*t( Bm%*%z )
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    ALL[ ,r,13 ] <- colSums(VsLss)*(rowSums(z1[ ,m:n ]))
  }
  rm( z,z1 )
  gc()
  
  # View( ALL[ ,,13 ] )  #   DDC_FIN
  
  # Part 2-10 == H10-(10): DDC_INT
  # OK !
  z <- Am%*%diag(X)
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    ALL[ ,r,14 ] <- colSums(diag(Vc)%*%Bd-VsLss)*(rowSums(z[ ,m:n ]))
  }
  rm( z )
  gc()
  
  # View( ALL[ ,,14 ] )  # DDC_INT
  
  # Part 2-11 == H10-(11): MVA_FIN  =[ VrBrs#Ysr ]
  #    H10-(14): OVA_FIN  =[ Sum(VtBts)#rYsr ]
  # OK !
  VrBrs <-  diag(Vc)%*%Bm
  YYsr <- array(0, dim=c( GN, GN))
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    YYsr[ ,1:GN ] <- Ym[ ,r ]
    z <- VrBrs*t( YYsr )
    ALL[ ,r,10 ] <- colSums( z[ m:n, ] ) # MVA_FIN[ ,r ]
    ALL[ ,r,9 ] <- colSums( z[ -c( m:n ), ] ) # OVA_FIN[ ,r ]
  }
  rm( YYsr,z )
  gc(  )
  
  # View( ALL[ ,,9 ] ) # OVA_FIN
  # View( ALL[ ,,10 ] ) # MVA_FIN
  
  # Part 2-12 == H10-(12): MVA_INT  =[ VrBrs#AsrLrrYrr ]
  #     H10-(15): OVA_INT  =[ Sum(VtBts)#AsrLrrYrr ]
  # OK !
  YYrr <- array(0, dim=c( GN, GN))
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    YYrr[ ,1:GN] <- Yd[ ,r ]
    z <- VrBrs*t(Am%*%L%*%YYrr)
    ALL[ ,r,12 ] <- colSums( z[ m:n, ] )   #  MVA_INT[ ,r ]
    ALL[ ,r,11 ] <-  colSums( z[ -c( m:n ) , ] )  #   OVA_INT[ ,r ]
  }
  rm( YYrr,z )
  gc()
  
  # View( ALL[ ,,11 ] )  #  OVA_INT
  # View( ALL[ ,,12 ] )  #  MVA_INT
  
  # Part 2-13 == H10-(13): MDC  =[ VrBrs#AsrLrrEr* ]
  # ==  H10-(16): ODC  =[ Sum(VtBts)#AsrLrrEr* ]
  # OK !
  for ( r in 1: G ) {
    m <- 1+( r-1 )*N; n <- N+(r-1)*N
    EEr <- array(0, dim=c( GN, GN))
    EEr[ m:n,1:GN] <- E[ m:n,1 ]
    z <- VrBrs*t(Am%*%L%*%EEr )
    ALL[ ,r,16 ] <- colSums( z[ m:n, ] )   # MDC[ ,r ]
    ALL[ ,r,15 ] <-  colSums( z[ -c( m:n ) , ] )   # ODC[ ,r ]
  }
  rm( EEr,z )
  gc(  )
  
  dimnames( ALL )  <-  list( rownam, regnam, decomp19)
  
  # Part 3 saving the variables
  
  if (return.totals==FALSE) {
    out <- ALL
  } else {
    # Part 4 Putting all results in one sheet
    for ( u in 1: GN ){
      if ( u==1 ){
        if( exists( "ALLandTotal" ) ==TRUE )    rm( ALLandTotal )
        ALLandTotal <- rbind( ALL[ u,, ], colSums( ALL[ u,, ] ))
      }
      else {
        ALLandTotal <- rbind( ALLandTotal, ALL[ u,, ], colSums( ALL[ u,, ] ))
      }
    } # the end of for ( u in 1:GN ){......
    
    rownames( ALLandTotal ) <- bigrownam
    
    # Part 5  checking the differences resulted in texp, texpfd, texpintdiff
    texpdiff  <-   rowSums( ALLandTotal[ ,1:16 ]) - ALLandTotal[ ,17 ]
    
    texpfddiff <- ALLandTotal[ ,1]+ALLandTotal[ ,9 ] +
      ALLandTotal[ ,10 ] - ALLandTotal[ ,19 ]
    
    texpintdiff <- rowSums( ALLandTotal[ ,2:8 ] ) +
      rowSums( ALLandTotal[ ,11:16 ] ) - ALLandTotal[ ,18 ]
    
    texpdiffpercent <-  texpdiff/ALLandTotal[ ,17 ]*100
    texpdiffpercent[ is.na(texpdiffpercent) ] <- 0
    texpfddiffpercent <-  texpfddiff/ALLandTotal[ ,19 ]*100
    texpfddiffpercent[ is.na(texpfddiffpercent) ] <- 0
    texpintdiffpercent <-  texpintdiff/ALLandTotal[ ,18 ]*100
    texpintdiffpercent[ is.na(texpintdiffpercent) ] <- 0
    texpdiff <- round( texpdiff, 4)
    texpfddiff <- round( texpfddiff,4)
    texpintdiff <-  round( texpintdiff, 4)
    texpdiffpercent <- round( texpdiffpercent, 4)
    texpfddiffpercent <- round( texpfddiffpercent,4)
    texpintdiffpercent <-  round( texpintdiffpercent, 4)
    
    ALLandTotal <-   cbind( ALLandTotal,texpdiff, texpfddiff, texpintdiff,
                            texpdiffpercent,texpfddiffpercent,texpintdiffpercent )
    dim( ALLandTotal )
    
    # save(ALLandTotal, file=output.file )
    out <- ALLandTotal
  }
  
  detach(input.object)
  
  return(out)
  
}