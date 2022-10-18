## loading list of errors & package ============================================
list_package <- c("shiny", "sf", "polyclip", "terra")

invisible(lapply(list_package, library, character.only = TRUE))

source("erreur_topo.R")

## Shiny app ===================================================================

# vectors used in selectInput
names_errors <- names(errors)
function_option <- c("sf::st_make_valid()", 
                     "sf::st_buffer(x, 0)",
                     "terra::makeValid()",
                     "polyclip::polyclip()",
                     "prepr::st_prepair()")
# client part ==================================================================
ui <- fluidPage(
    titlePanel(
        "Correcting geometries"
    ),
    sidebarLayout(
        sidebarPanel(
            # input of type of erros
            # TODO Hierarchical select boxes
            selectInput("errors", "Errors", choices = names_errors),
            textOutput("errors1"),
            
            # input select function
            selectInput("select_func", "Pick a function:", choices = function_option),
            textOutput("errors2")
            ),
        mainPanel(
            plotOutput("plot_errors"),
            plotOutput("plot_corrected"),
            )
    )
    
)

# server part ==================================================================
server <- function(input, output, session) {
    
    selected <- reactive(errors[[input$errors]])
    
    corrected<- reactive({
        switch(req(input$select_func),
                "sf::st_make_valid()" = sf::st_make_valid(selected()),
                "sf::st_buffer(x, 0)" = sf::st_buffer(selected(), 0),
                "terra::makeValid()" = testing_terra_makevalid(selected()),
                "polyclip::polyclip()" = testing_polyclip_polyclip(selected()),
                "prepr::st_prepair()" = prepr::st_prepair(selected())
               )
    })
   
    
    output$plot_errors <- renderPlot({
        plot_my_result(selected(), title = "errors")
    })
    
    output$errors1 <- renderText({
        paste0("Reason:  ", sf::st_is_valid(selected(), reason = TRUE))        
    }
    )
    
    output$plot_corrected <- renderPlot({
        plot_my_result(corrected(), title = "corrected")
    })
    
    output$errors2 <- renderText({
        paste0("Is is valid ? ", sf::st_is_valid(corrected()), "!")
    })
}

shinyApp(ui, server)