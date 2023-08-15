# Load the shiny package
library(shiny)

# Define the UI
ui <- fluidPage(
  titlePanel("Stock Path Simulator"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("current_price", label = "Current Price:", value = 100),
      numericInput("volatility", label = "Volatility:", value = 0.3875),
      numericInput("days_to_expiration", label = "Days to Expiration:", value = 10),
      numericInput("short_leg", label = "Short Leg:", value = 90),
      numericInput("loss_at_short_leg", label = "Loss at Short Leg:", value = 40),
      numericInput("expected_profit", label = "Expected Profit:", value = 20),
      numericInput("n_simulations", label = "Number of Simulations:", value = 10000),
      
      actionButton("simulate", "Simulate")
    ),
    
    mainPanel(
      verbatimTextOutput("result")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  simulate_stock_path <- function(current_price, volatility, days_to_expiration, short_leg, loss_at_short_leg, expected_profit, dt = 1/365, n_simulations = 10000) {
    touches_target <- 0
    total_gain_or_loss <- 0
    
    for (i in 1:n_simulations) {
      S <- current_price
      touched <- FALSE
      
      direction <- ifelse(short_leg >= current_price, "up", "down")
      
      for (j in 1:days_to_expiration) {
        epsilon <- rnorm(1, 0, 1)
        delta_S <- S * (volatility * epsilon * sqrt(dt))
        S <- S + delta_S
        
        if (direction == "up" && S >= short_leg) {
          touched <- TRUE
          break
        } else if (direction == "down" && S <= short_leg) {
          touched <- TRUE
          break
        }
      }
      
      if (touched) {
        touches_target <- touches_target + 1
        total_gain_or_loss <- total_gain_or_loss - loss_at_short_leg
      } else {
        total_gain_or_loss <- total_gain_or_loss + expected_profit
      }
    }
    
    probability <- touches_target / n_simulations
    avg_gain_or_loss <- total_gain_or_loss / n_simulations
    
    return(list(probability, avg_gain_or_loss))
  }
  
  observeEvent(input$simulate, {
    results <- simulate_stock_path(input$current_price, input$volatility, input$days_to_expiration, input$short_leg, input$loss_at_short_leg, input$expected_profit, n_simulations = input$n_simulations)
    probability <- results[[1]]
    avg_gain_or_loss <- results[[2]]
    
    output$result <- renderPrint({
      cat("Probability of stock touching the short leg of", input$short_leg, "in", input$days_to_expiration, "days is:", probability, "\n",
          "Loss Index:", input$loss_at_short_leg*probability, "\n",
          "Profit Index:", input$expected_profit*(1-probability), "\n",
          "Trade Continuation Index", input$expected_profit*(1-probability)/input$loss_at_short_leg*probability, "\n",
          "Average Gain or Loss after simulation:", avg_gain_or_loss)
      
    })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
