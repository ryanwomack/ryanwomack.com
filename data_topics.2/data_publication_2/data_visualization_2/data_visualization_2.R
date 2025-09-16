
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(root.dir = "/home/ryan/R/data_topics/data_visualization_2/")


## 
## install.packages("pak", dependencies=TRUE)
## library(pak)
## pkg_install("shiny")
## pkg_install("rsconnect")
## 


library(tidyverse)
library(shiny)
library(rsconnect)



library(shiny)

ui <- basicPage(
  plotOutput("plot1", click = "plot_click"),
  verbatimTextOutput("info")
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  })
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
}

shinyApp(ui, server)



function(input, output, session) {
  
  my_input <- reactive(input$bins)
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = my_input() + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times',
         ylab = paste(my_input(), ' bins'))
    
  })
  
}

