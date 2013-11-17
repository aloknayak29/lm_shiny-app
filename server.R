library(shiny)

shinyServer(function(input, output) {
  dbool <- FALSE
  df <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    dbool <<- TRUE
    df <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
  })
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    head(df(),10)
  })
  output$cnames <- renderPrint({
    names(df())
  })
  
  output$lm_output <- renderPrint({
    t1 <- input$xvars
    t2 <- input$yvar
    if(dbool == TRUE) {
      x <- df()
      xnamesall <- names(x)
      xnames <- xnamesall[as.integer(t1)]
      yvariable <- xnamesall[as.integer(t2)]
      ytext <- paste(yvariable,"~")
      fmla <- as.formula(paste(ytext, paste(xnames, collapse= "+")))
      fit <- lm(fmla, x, na.action=na.omit)
      print(summary(fit))
    }
    else
      print('LINEAR REGRESSION ANALYSIS WILL APPEAR HERE')
  })
})
