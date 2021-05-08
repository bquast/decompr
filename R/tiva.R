#' Load TiVA data
#' @name tiva
#' @export
#' @import OECD utils
#' 

tiva <- function() {
  
  # check if OECD package is installed, if not, prompt install
  if(!requireNamespace("OECD", quietly = TRUE)) {
    fun <- function() {
      ANSWER <- readline("Would you like to install the OECD package? (y/n)")
      ## a better version would check the answer less cursorily, and
      ## perhaps re-prompt
      if(tolower(substr(ANSWER, 1L, 1L)) == "y")
        utils::install.packages("OECD") else
        return("The tiva function cannot be used without an installed version of the OECD package.")
    }
    fun()
  }
}