# Load necessary libraries
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
      verbatimTextOutput("result"),
      plotOutput("histPlot")  # Added plot output for histogram
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  simulate_stock_path <- function(current_price, volatility, days_to_expiration, short_leg, loss_at_short_leg, expected_profit, dt = 1/365, n_simulations = 10000) {
    touches_target <- 0
    gain_or_loss_vector <- numeric(n_simulations)
    
    for (i in 1:n_simulations) {
      S <- current_price
      touched <- FALSE
      direction <- ifelse(short_leg >= current_price, "up", "down")
      for (j in 1:days_to_expiration) {
        epsilon <- rnorm(1, 0, 1)
        delta_S <- S * (volatility * epsilon * sqrt(dt))
        S <- S + delta_S
        if (direction == "up" && S >= short_leg || direction == "down" && S <= short_leg) {
          touched <- TRUE
          break
        }
      }
      if (touched) {
        touches_target <- touches_target + 1
        gain_or_loss_vector[i] <- -loss_at_short_leg
      } else {
        gain_or_loss_vector[i] <- expected_profit
      }
    }
    
    probability <- touches_target / n_simulations
    avg_gain_or_loss <- sum(gain_or_loss_vector) / n_simulations
    return(list(probability, avg_gain_or_loss, gain_or_loss_vector))
  }
  
  observeEvent(input$simulate, {
    results <- simulate_stock_path(input$current_price, input$volatility, input$days_to_expiration, input$short_leg, input$loss_at_short_leg, input$expected_profit, n_simulations = input$n_simulations)
    probability <- results[[1]]
    avg_gain_or_loss <- results[[2]]
    gain_or_loss_vector <- results[[3]]
    
    median_gain_or_loss <- median(gain_or_loss_vector)
    mean_gain_or_loss <- mean(gain_or_loss_vector)
    
    output$result <- renderPrint({
      cat("Probability of stock touching the short leg of", input$short_leg, "in", input$days_to_expiration, "days is:", probability, "\n",
          "Loss Index:", input$loss_at_short_leg*probability, "\n",
          "Profit Index:", input$expected_profit*(1-probability), "\n",
          "Average Gain or Loss after simulation:", avg_gain_or_loss, "\n",
          "Mean Gain or Loss after simulation:", mean_gain_or_loss)
    })
    
    # Histogram for gain or loss vector
    output$histPlot <- renderPlot({
      hist(gain_or_loss_vector, 
           main = "Distribution of Gain or Loss from Simulations", 
           xlab = "Gain/Loss",
           col = "skyblue",
           border = "black")
    })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
