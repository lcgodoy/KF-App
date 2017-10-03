library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("united"),
  
  # Application title
  titlePanel("Filtro de Kalman"),
  h4("Exemplo do robo"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       numericInput("m0",
                   "Chute inicial para a média:",
                   value = 50),
       numericInput("tau_mu",
                    "Chute inicial para a precisão da média:",
                    value = 0.001,
                    min = 0, 
                    step = 0.0000001),
       numericInput("tau_y",
                    "Precisão das medições (Conhecida):",
                    value = 1/10^2,
                    min = 0,
                    step = 0.0000001),
       numericInput("tau_d",
                    "Precisão 'd':",
                    value = 1,
                    min = 1,
                    max = 1)
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
