


library(shiny)
library(rsconnect)
library(NLP)
library(tm)
library(RWeka)
library(data.table)
library(dplyr)
source('./Word Pred.R')

# Define server logic
shinyServer(function(input, output) {
    output$inputValue <- renderText({input$Tcir})
    output$prediction <- renderText({proc(input$Tcir)})
}
)

 
