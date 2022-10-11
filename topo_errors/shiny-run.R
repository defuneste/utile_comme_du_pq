# This script is used to run the application defined in app.R in the background
# source : https://github.com/sol-eng/background-jobs/blob/main/shiny-job/shiny-run.R
options(shiny.autoreload = TRUE)
shiny::runApp()