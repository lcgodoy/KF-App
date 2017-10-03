library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  st <- rep(c(1,2,0,-3, -1, 0, 4), rep(10,7))
  dt <- st + rnorm(length(st))
  mut = rep(0, length(st))
  mut[1] = dt[1]
  for(i in 2:length(st)) mut[i] =  mut[i-1] + dt[i]
  yt = rnorm(length(st), mean=mut, sd=10)
  ene = length(yt)
  aux <- range(yt, mut)
  kt = rep(0, ene); mut.hat = rep(0, ene); var.hat = rep(0, ene)
  
  Mu_t <- function(mu0, tau_mu, tau_d, tau_y)
  {
    kt = rep(0, ene); mut.hat = rep(0, ene); var.hat = rep(0, ene)
    
    # primeira iteracao
    kt[1] <- (tau_mu + 1/tau_d)/(tau_mu + 1/tau_d + 1/tau_y)
    mut.hat[1] = kt[1]*yt[1] + (1-kt[1])*(mu0 + st[1])
    var.hat[1] = (1-kt[1])*(tau_mu + 1/tau_d)
    
    for(i in 2:ene){
      kt[i] <- (var.hat[i-1] + 1/tau_d)/(var.hat[i-1] + 1/tau_d + 1/tau_y)
      mut.hat[i] = kt[i]*yt[i] + (1-kt[i])*(mut.hat[i-1] + st[i])
      var.hat[i] = (1-kt[i])*(var.hat[i-1] + 1/tau_d)
    }
    return(mut.hat)
  }
  
  Mu_Plot <- reactive({
    Mu_t(input$m0, input$tau_mu, input$tau_d, input$tau_y)
  })
  
  output$distPlot <- renderPlot({ 
    plot(1:ene, mut, type="l", ylim=aux, xlab="tempo", ylab="")
    points(1:ene, yt, col="red")
    lines(1:ene, Mu_Plot(), col="blue")
  })
  
})
