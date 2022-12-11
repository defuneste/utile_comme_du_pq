## loading list of errors & package ============================================
list_package <- c("shiny", "sf", "polyclip", "terra")

invisible(lapply(list_package, library, character.only = TRUE))

# To be sure we are going to use GEOS
sf::sf_use_s2(FALSE)

source("src/functions.R")
errors <- readRDS("data/errors")
filter_data <- readRDS("data/filter_data")

## Shiny app ===================================================================

# vectors used in selectInput

types_errors <- unique(filter_data$features)

names_errors <- names(errors)

function_option <- c("sf::st_make_valid()", 
                     "terra::makeValid()",
                     "geos::geos_make_valid()",
                     "sf::st_buffer(x, 0)",
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
            
            radioButtons("type", "1. Select a type of features:", choices = types_errors), 
            
            selectInput("errors", "2. Select an associated error", choices = names_errors),
            
            textOutput("errors1"),
            
            # input select function
            selectInput("select_func", "3. Pick a function to correct it:", choices = function_option),
            
            textOutput("errors2")
            ),
        mainPanel(
            plotOutput("plot_errors"),
            plotOutput("plot_corrected"),
            )
    )
    
)

# server part ==================================================================
server <- function(input, output, sesion) {
    
    types <- reactive({
        base::subset(filter_data, features == input$type)
    })

    observeEvent(types(), {
        choices <- types()$errors
        updateSelectInput(inputId = "errors", choices = choices) 
    })
    
    selected <- reactive({errors[[input$errors]]})
    
    corrected<- reactive({
        switch(req(input$select_func),
                "sf::st_make_valid()" = sf::st_make_valid(selected()),
                "sf::st_buffer(x, 0)" = sf::st_buffer(selected(), 0),
                "terra::makeValid()" = testing_terra_makevalid(selected()),
                "polyclip::polyclip()" = testing_polyclip_polyclip(selected()),
                "prepr::st_prepair()" = prepr::st_prepair(selected()),
                "geos::geos_make_valid()" = testing_geos_make_valid(selected())
               )
    })
   
    
    output$plot_errors <- renderPlot({
        plot_my_result(selected(), title = "errors")
    })
    
    output$errors1 <- renderText({
        paste0("Reason:  ", sf::st_is_valid(selected(), reason = TRUE), "\n")        
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