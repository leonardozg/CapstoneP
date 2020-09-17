

library(shiny)

ui <- fluidPage(
    
    
    #titlePanel("Word Prediction"),
    
    sidebarLayout(
        
        sidebarPanel(
            h4("Directions", style="color:red"),
            p("1.Type al least 4 words into the text box"),
            p("2. The algorithm will predict the next word"),
            p("3. You can add the predicted word to your text and submit again"),
            p("4. Repeat")
        ),
            
        
        mainPanel(
            h3("Word Prediction Application"),
            h5("This application will suggest the next word in a sentence using an n-gram algorithm"),
            textInput("Tcir",label=h3("Enter your text here:")),
            submitButton('Submit'),
            h4('You entered : '),
            verbatimTextOutput("inputValue"),
            h4('Predicted word :'),
            verbatimTextOutput("prediction"),
            tags$img(src= "WC1.png", width="300px", height= "300px"),
            tags$img(src= "WC2.png", width="300px", height= "300px")
        )
    ))


