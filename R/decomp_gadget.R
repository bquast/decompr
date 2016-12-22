#' decomp user interface
#'
#' @name decomp_gadget
#' @export
#' @import shiny miniUI

decomp_gadget <- function(inputValue1, inputValue2) {
  
  ui <- miniPage(
    miniTitleBar("decomp", right = miniTitleBarButton("done", "Accept", primary = TRUE)),
    miniContentPanel(
      # Define layout, inputs, outputs
      radioButtons("dataselect", 
                   "Select dataset:",
                   choices = c('Example dataset "leather"' = "leather",
                               "Manual" = "globalenv",
                               "WIOD" = "wiod",
                               "TiVa" = "tiva")
                   ),
      conditionalPanel( condition = 'input.dataselect == "wiod"',
                        selectInput("wiodselect", "Choose year for WIOD:",
                                    choices = c("WIOD 1995" = "95",
                                                "WIOD 2000" = "00",
                                                "WIOD 2005" = "05",
                                                "WIOD 2008" = "08",
                                                "WIOD 2009" = "09",
                                                "WIOD 2010" = "10",
                                                "WIOD 2011" = "11") )
      ),
      
      conditionalPanel( condition = 'input.dataselect == "tiva"',
                        selectInput("tivaselect", "Choose year for TiVa:",
                                    choices = c("TiVa 1995" = "tiva95",
                                                "TiVa 2000" = "tiva00",
                                                "TiVa 2005" = "tiva05",
                                                "TiVa 2008" = "tiva08",
                                                "TiVa 2009" = "tiva09",
                                                "TiVa 2010" = "tiva10",
                                                "TiVa 2011" = "tiva11") )
      ),
      
      conditionalPanel( condition = 'input.dataselect == "globalenv"',
                        selectInput("countries", "Countries list:", choices = ls(.GlobalEnv),
                                    selected = grep("^[cCrR][oOeE][nNgG]", ls(.GlobalEnv), perl = TRUE, value = TRUE) )
      ),
      
      conditionalPanel( condition = 'input.dataselect == "globalenv"',
                        selectInput("industries", "Industries / Sectors list:", choices = ls(.GlobalEnv),
                                    selected = grep("^[iIsS][nNeC][dDcC]", ls(.GlobalEnv), perl = TRUE, value = TRUE) )
      ),
      
      conditionalPanel( condition = 'input.dataselect == "globalenv"',
                        selectInput("intermediate", "Intermediate Demand matrix:", choices = ls(.GlobalEnv),
                                    selected = grep("^[iI][nN][tT]", ls(.GlobalEnv), perl = TRUE, value = TRUE) )
      ),
      
      conditionalPanel( condition = 'input.dataselect == "globalenv"',
                        selectInput("intermediate", "Intermediate Demand matrix:", choices = ls(.GlobalEnv),
                                    selected = grep("^[iI][nN][tT]", ls(.GlobalEnv), perl = TRUE, value = TRUE) )
      ),
      
      conditionalPanel( condition = 'input.dataselect == "globalenv"',
                        selectInput("final", "Final Demand matrix:", choices = ls(.GlobalEnv),
                                    selected = grep("^[fF][iI][nN]", ls(.GlobalEnv), perl = TRUE, value = TRUE) )
      ),
      
      conditionalPanel( condition = 'input.dataselect == "globalenv"',
                        selectInput("output", "Output vector:", choices = ls(.GlobalEnv),
                                    selected = grep("^[oO][uU][tT]", ls(.GlobalEnv), perl = TRUE, value = TRUE) )
      ),
      
      radioButtons("method", 
                   "Decomposition method:",
                   choices = c("Leontief" = "leontief", "Wang-Wei-Zhu" = "wwz")),
      
      conditionalPanel( condition = 'input.method == "leontief"',
                        radioButtons("post", 
                                     "Post-multiplication (Leontief only):",
                                     choices = c("exports", "output", "final_demand", "none"))
      ),
      
      textInput('outputobj', label = 'Save as:', value = 'decompr_object'),
      
      checkboxInput("showoutput", "Show output", value=TRUE)
      
    ),
    
    miniButtonBlock(

      a("Built using decompr, ", href="http://qua.st/decompr/", target="_blank"),
      a("please cite: Quast & Kummritz 2015", href="https://ideas.repec.org/p/gii/cteiwp/ctei-2015-01.html", target="_blank")
    )
  )
  
  server <- function(input, output, session) {
    # Define reactive expressions, outputs, etc.
    
    # When the Done button is clicked, return a value
    observeEvent(input$done, {
      if (input$dataselect == "upload") {
        .decomposed <<- decomp(x = .GlobalEnv[[input$intermediate]],
                               y = .GlobalEnv[[input$final]],
                               k = .GlobalEnv[[input$countries]],
                               i = .GlobalEnv[[input$industries]],
                               o = .GlobalEnv[[input$output]],
                               method = input$method,
                               post = input$post)
      } else if (input$dataselect == "wiod") {
        data(list=paste('wiod', input$wiodselect, sep = ''))
        inter <- get(grep("^[iI][nN][tT]", ls(.GlobalEnv), value=TRUE))
        final <- get(grep("^[fF][iI][nN]", ls(.GlobalEnv), value=TRUE))
        output <- get(grep("^[oO][uU][tT]", ls(.GlobalEnv), value=TRUE))
        .decomposed <<- decomp(x = inter,
                               y = final,
                               k = countries,
                               i = industries,
                               o = output,
                               method = input$method,
                               post = input$post)
      } else {
        data(leather)
        .decomposed <<- decomp(x = inter,
                               y = final,
                               k = countries,
                               i = industries,
                               o = out,
                               method = input$method,
                               post = input$post)
      }
      outputobj <- input$outputobj
      assign(paste(outputobj), .decomposed, envir = .GlobalEnv)
      if(input$showoutput == TRUE)
        View(.decomposed, outputobj)
      stopApp()
    })
  }
  
  runGadget(ui, server, viewer = dialogViewer("decompr"))
}