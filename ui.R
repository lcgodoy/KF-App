library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("paper"),
  
  # Application title
  titlePanel("Filtro de Kalman"),
  h4("Exemplo do robo"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("n",
                   "Número de comandos para o robo a serem gerados para o robo",
                   value = 40,
                   min = 1,
                   max = 300),
      numericInput("mu_st",
                   "Média (st)",
                   value = 0),
      numericInput("tau_st",
                   "Precisão (st)",
                   value = 0.001,
                   min = 0.00000000000000000000000001, 
                   step = 0.0000001),
      actionButton("run1", "Simular st", icon = icon("refresh")),
      numericInput("tau_y",
                   "Precisão das medições (Conhecida):",
                   value = 1/10^2,
                   min = 0.00000000000000000000000001,
                   step = 0.0000001),
      actionButton("run2", "Simular yt", icon = icon("refresh")),
      numericInput("m0",
                   "Chute inicial para a média:",
                   value = 50),
      numericInput("tau_mu",
                   "Chute inicial para a precisão da média:",
                   value = 0.001,
                   min = 0.00000000000000000000000001, 
                   step = 0.0000001),
      
      # HTML("<footer>
      #       <p> <a href='https://lcgodoy.github.io'>Lucas Godoy</a> </p>
      #       <p>Contato: <a href='mailto:lucasdac.godoy@gmail.com'>
      #         lucasdac.godoy@gmail.com</a>.</p>
      #     </footer>")
      HTML(
        '<footer>
            <a href = "https://lcgodoy.github.io"> Lucas Godoy </a> </br>
            <a href="https://www.facebook.com/lucasbod" class="fa fa-facebook"></a>
            <a href="https://twitter.com/bod_godoy" class="fa fa-twitter"></a>
            <a href="https://github.com/lcgodoy" class="fa fa-github"></a>
            <a href="https://www.linkedin.com/in/godoy-lucas/" class="fa fa-linkedin"></a>
        </footer>'
      )
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      highcharter::highchartOutput("distPlot")
    )
  )
))
