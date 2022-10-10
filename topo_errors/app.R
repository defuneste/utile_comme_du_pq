library(shiny)
library(sf)

#source("../erreur_topo.R")

names_errors <- names(errors)

ui <- fluidPage(
    fluidRow(
        column(6,
               selectInput("errors", "Errors", choices = names_errors)
        ),
    
    plotOutput("plot_errors"),
    plotOutput("plot_corrected"),
    textOutput("errors")
    )
)

server <- function(input, output, session) {
    
    selected <- reactive(errors[[input$errors]])
    corrected <- reactive(sf::st_make_valid(selected()))
    
    output$plot_errors <- renderPlot({
        plot_my_result(selected(), title = "errors")
    })
    
    output$plot_corrected <- renderPlot({
        plot_my_result(corrected(), title = "corrected")
    })
    
    output$errors <- renderText({
        paste0("Is is valid ? ", sf::st_is_valid(corrected()), "!")
    })
}

shinyApp(ui, server)