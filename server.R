#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rsconnect)
library(NLP)
library(tm)
library(RWeka)
library(data.table)
library(dplyr)
source('~/skydrive/1000-Capacitacion/2015-Coursera/11-Capstone/Word Pred.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$inputValue <- renderText({input$Tcir})
    output$prediction <- renderText({proc(input$Tcir)})
}
)

 
