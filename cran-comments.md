## Test environments

- Local Arch Linux R 3.6.3
- Ubuntu (Travic-CI) R-3.6.3
- Win-Builder devel and release

## R CMD check results
There were no ERRORs or WARNINGs. 

    * checking R code for possible problems ... [7s] NOTE
    decomp_gadget : server: no visible binding for '<<-' assignment to
    '.decomposed'
    
    Found the following assignments to the global environment:
    File 'decompr/R/decomp_gadget.R':
    
    Found the following calls to data() loading into the global environment:
    File ‘decompr/R/decomp_gadget.R’:
      data(list = paste("wiod", input$wiodselect, sep = ""))
      data(leather, package = "decompr")
    See section ‘Good practice’ in ‘?data’.
   
Please note that this is not new behaviour, it is also present in the version currently on CRAN.

I have tried my best to remove any notes, but this one seems impossible to avoid.

This update solves a long list of problems and errors in the version currently on CRAN.
