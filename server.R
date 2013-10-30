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
    df()
  })
  output$lm_output <- renderPrint({
    #print('asdfsaf')
    #print(input$xvars)
    #print(dbool)
    if(dbool == TRUE) {
      x <- df()
      xnamesall <- names(x)
      xnames <- xnamesall[as.integer(input$xvars)]
      print(xnames)
      print(input$yvar)
      yvariable <- xnamesall[as.integer(input$yvar)]
      
      print(yvariable)
      ytext <- paste(yvariable,"~")
      fmla <- as.formula(paste(ytext, paste(xnames, collapse= "+")))
      #print(fmla)
      fit <- lm(fmla, x, na.action=na.omit)
      print(summary(fit))
    }
    else
      print('ANALYSIS WILL APPEAR HERE')
    #x <- df()
    #xnames <- names(x)
    #xnames <- xnames[input$xvars]
    #yvariable <- xnames[input$yvar]
    #fmla <- as.formula(paste(paste(yvariable," ~ ",sep=''), paste(xnames, collapse= "+")))
  })
})
