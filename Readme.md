# Trade Advisor
This is a shiny app that may be run at https://prof-newmiller.shinyapps.io/TradeAdvisor/.
## Disclaimer
If you use this program, you agree to hold the provide of the code blameless in consequences resulting from your use of the app. This code is for educational and entertainment purposes only.

## Purpose
This app provides an approach that applies a statistical approach that is applied to vertical spread option contracts.

## Concept
The app runs a Monte Carlo simulation to determine the probability of the underlying touching a certain price prior to contract expiration.Using that probability, the app then calculates and reports the likelihood of the vertical spread's profit or loss.

## Inputs
Inputs include values similar to those used in the Black-Shoals model for option pricing. Additional inputs provided by the user depend on the user's preferences for selecting and managing a trade. They include potential loss and desired profit.

## Caveats
Users should have a strong understanding of financial markets, option contracts, and an understanding of Monte Carlo simulation. Monte Carlo simulation is a widely used method in finance to model the probability of different outcomes in a process that cannot easily be predicted due to the intervention of random variables. When employing implied volatility and time to determine the possibility of touching a certain price level using Monte Carlo simulation, several accuracy concerns can arise:

### Model Assumptions: Monte Carlo simulations are based on the assumptions of the underlying model. If you assume stock price changes follow a geometric Brownian motion (as in the Black-Scholes model), then the results will be bounded by that assumption. If the real-world price dynamics differ, your simulation will be off.

### Static Implied Volatility: Implied volatility is dynamic and can change rapidly. If you use a single implied volatility value (like the current value) throughout the simulation until expiration, you're making an assumption that it remains constant, which is unlikely.

### Smile and Skew: Often, implied volatilities differ for options with the same expiration but different strike prices. This phenomenon is referred to as the volatility smile or skew. If you're not incorporating this variability, the simulation might not reflect market nuances.

### Granularity of the Simulation: The accuracy of a Monte Carlo simulation often depends on the number of paths or iterations. More paths usually mean better accuracy but at the cost of increased computational time. Too few paths can lead to misleading results.

### Non-Normal Distributions: Stock returns might not always follow a normal distribution. Events that are considered rare in a normal distribution (like market crashes) might occur more frequently in reality. If the simulation doesn't account for fat tails or non-normal distributions, it can underestimate extreme price moves.

### Overlooking External Factors: Economic news, company-specific events, geopolitical situations, interest rate changes, and many other factors can influence stock prices. These are hard to factor into a simulation based solely on implied volatility and time.

### Limitation of Historical Data: If you're calibrating your model based on historical data, remember that past performance doesn't guarantee future results. Market dynamics change over time, and what was true a decade ago might not hold now.

### Discretization Errors: Depending on the time-step size chosen for the simulation, discretization errors can creep in. Smaller time steps can reduce this error but increase computational burden.

### Path Dependency: If the option or derivative being modeled is path-dependent (i.e., its payoff depends on the entire price path rather than just the terminal or expiry price), modeling challenges increase significantly.

### Lack of Model Validation: It's crucial to validate the Monte Carlo model against known benchmarks or observed market prices to ensure it's producing realistic results.

### Given these concerns, while Monte Carlo simulations can be a powerful tool to understand potential price movements and associated probabilities, they should be used in conjunction with other tools and analysis methods. Always be aware of the model's assumptions and limitations when interpreting results.


