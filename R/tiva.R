#' Load TiVA data
#' @name tiva
#' @export
#' @import OECD
#' 

tiva <- function() {
  
  # check if OECD package is installed, if not, prompt install
  if('OECD' %in% installed.packages()[,'Package']) {
    inst <- winDialog('yesno', "The OECD package is not yet installed, do you want to install it now?")
    if(inst == 'YES')
      install.packages('OECD')
    else
      return("The tiva function cannot be used without an installed version of the OECD package.")
  }
  
  
}