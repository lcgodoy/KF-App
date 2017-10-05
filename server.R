library(shiny)
library(highcharter)

Mu_t_hat <- function(mu0, tau_mu, tau_d, tau_y, n, yt, st)
{
  kt = rep(0, n); mut.hat = rep(0, n); var.hat = rep(0, n)
  
  # primeira iteracao
  kt[1] <- (tau_mu + 1/tau_d)/(tau_mu + 1/tau_d + 1/tau_y)
  mut.hat[1] = kt[1]*yt[1] + (1-kt[1])*(mu0 + st[1])
  var.hat[1] = (1-kt[1])*(tau_mu + 1/tau_d)
  
  for(i in 2:n){
    kt[i] <- (var.hat[i-1] + 1/tau_d)/(var.hat[i-1] + 1/tau_d + 1/tau_y)
    mut.hat[i] = kt[i]*yt[i] + (1-kt[i])*(mut.hat[i-1] + st[i])
    var.hat[i] = (1-kt[i])*(var.hat[i-1] + 1/tau_d)
  }
  return(mut.hat)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  generate1 <- eventReactive(input$run1, {
    st <- rnorm(input$n, input$mu_st, input$tau_st)
    
    dt <- st + rnorm(length(st))
    out <- list(st = st, dt = dt)
    return(out)
  })
  
  
  mut = reactive({
    mut <- rep(0, input$n)
    dados_sim <- generate1()
    dt <- dados_sim$dt
    mut[1] = dt[1]
    for(i in 2:input$n) {
      mut[i] =  mut[i-1] + dt[i]
    }
    return(mut)
  })
  
  generate2 <- eventReactive(input$run2, {
    yt <- rnorm(input$n, mean = mut(), sd = (1/input$tau_y))
    return(yt)
  })
  
  Mu_Plot <- reactive({
    St <- generate1()
    Mu_t_hat(input$m0, input$tau_mu, 1, input$tau_y, input$n, generate2(), St$st)
  })
  
  output$distPlot <- highcharter::renderHighchart({ 
    
    hc <- highcharter::highchart() %>% 
      highcharter::hc_xAxis(1:length(yt)) %>%  
      highcharter::hc_add_series(name = "Y_t", data = generate2(), type = "scatter") %>%
      highcharter::hc_add_series(name = "mu_t", data = mut(), marker = list(enabled = F)) %>% 
      highcharter::hc_add_series(name = "mu_t_hat", data = Mu_Plot(), marker = list(enabled = F)) %>%
      highcharter::hc_tooltip(crosshairs = TRUE, shared = TRUE, borderWidth = 5) %>% 
      highcharter::hc_exporting(enabled = TRUE)
    
    hc
    # 
    # plot(1:length(generate2()), mut(), type="l", ylim = range(c(generate2(), mut(), Mu_Plot())), xlab="tempo", ylab="")
    # points(1:length(generate2()), generate2(), col="red")
    # lines(1:length(generate2()), Mu_Plot(), col="blue")
    
  })
  
})
