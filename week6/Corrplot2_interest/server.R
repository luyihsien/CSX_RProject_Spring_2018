
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(corrplot)
library(ggplot2)
source("corTest.R", local = TRUE)

shinyServer(function(input, output, session) {
  collegetype <- read.csv("college4.csv",
                   header = TRUE)
  interest <- read.csv("college5.csv",
                   header = TRUE)
  group <- read.csv("college6.csv",
                   header = TRUE)
  choice.type <-
  
    ## Data Input and Pre-processing ###################
  dataset <- reactive({
    datasource <- input$dataset
    if(datasource == "upload my own") {
      inFile <- input$datafile
      if(is.null(inFile)) {
        NULL
      } else {
        #TODO: Better way to unescape e.g. \\t
        read.delim(inFile$datapath, sep = gsub("\\t", "\t", input$datafile_sep, fixed = TRUE))
      }
    } else {
      eval(parse(text = datasource))
    }
  })
  
 
  numericColumns <- reactive({
    df <- dataset()
    colnames(df)[sapply(df, is.numeric)]
  })
  
  correlation <- reactive({
    data <- dataset()
    variables <- input$variables
    if(is.null(data) || !length(intersect(variables, colnames(data)))) {
      NULL
    } else {
      cor(dataset()[,input$variables], use = input$corUse, method = input$corMethod)
    }
  })
  
  sigConfMat <- reactive({
    val <- correlation()
    if(!is.null(val))
      corTest(val, input$confLevel)
  })
  
  ## Data and Correlation Validation and UI Updates ##########
  
  #Update hclust rect max
  observe({
    val <- correlation()
    if(!is.null(val))
      updateNumericInput(session, "plotHclustAddrect", max = nrow(val))
  })
  
  #Update variable selection
  observe({
    updateCheckboxGroupInput(session, "variablesCheckbox", choices = numericColumns(), selected = numericColumns())
    
    updateSelectInput(session, "variables", choices = numericColumns(), selected = numericColumns())
  })
  
  #Link Variable Selection
  observe({
    if(input$variablesStyle == "Checkbox") {
      updateCheckboxGroupInput(session, "variablesCheckbox", selected = isolate(input$vairables))
    }
  })
  observe({
    updateSelectInput(session, "variables", selected = input$variablesCheckbox)
  })
  
  output$warning <- renderUI({
    val <- correlation()
    if(is.null(val)) {
      tags$i("Waiting for data input...")
    } else {
      isNA <- is.na(val)
      if(sum(isNA)) {
      tags$div(
        tags$h4("Warning: The following pairs in calculated correlation have been converted to zero because they produced NAs!"),
        helpText("Consider using an approriate NA Action to exclude missing data"),
        renderTable(expand.grid(attr(val, "dimnames"))[isNA,]))
      }
    }
  })
  
  ## Correlation Plot ####################################

  output$corrPlot <- renderPlot({
    val <- correlation()
    if(is.null(val)) return(NULL)

    val[is.na(val)] <- 0
    args <- list(val,
                 order = if(input$plotOrder == "manual") "original" else input$plotOrder, 
                 hclust.method = input$plotHclustMethod, 
                 addrect = input$plotHclustAddrect,
                 
                 p.mat = sigConfMat()[[1]],
                 sig.level = if(input$sigTest) input$sigLevel else NULL,
                 insig = if(input$sigTest) input$sigAction else NULL,
                 
                 lowCI.mat = sigConfMat()[[2]],
                 uppCI.mat = sigConfMat()[[3]],
                 plotCI = if(input$showConf) input$confPlot else "n")
    
    if(input$showConf) {
      do.call(corrplot, c(list(type = input$plotType), args))
    } else if(input$plotMethod == "mixed") {
      do.call(corrplot.mixed, c(list(lower = input$plotLower,
                                     upper = input$plotUpper),
                                args))
    } else {
      do.call(corrplot, c(list(method = input$plotMethod, type = input$plotType), args))
    }
  })
  
  ## Data Table ####################
  
  output$dataTable <- renderDataTable(dataset())

})
