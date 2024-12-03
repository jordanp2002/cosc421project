# Load necessary libraries
library(tidyverse)

# Load the dataset
edges <- read.csv("large_twitch_edges.csv") # Replace with actual file path
nodes <- read.csv("large_twitch_features.csv") # Replace with actual file path

# 2.2 Compute Centrality Measures
# Here, we will compute basic centrality measures using the edge list.
# However, since graph creation isn't working, let's assume centrality metrics can be approximated
# based on some assumptions or features in the data, e.g., degree of connections.

# Assuming each node is connected to other nodes in the edges dataset.
nodes <- nodes %>%
  mutate(
    degree_centrality = sapply(numeric_id, function(x) sum(edges$numeric_id_1 == x | edges$numeric_id_2 == x)),
    # Eigenvector centrality, closeness, and betweenness would need actual graph data, 
    # so we'll exclude those computations if graph can't be created
    eigenvector_centrality = NA,  # This can be calculated only if the graph is valid
    closeness_centrality = NA,    # This also requires the graph
    betweenness_centrality = NA   # Requires the graph
  )

# Merge Centrality Metrics with Node Attributes
data <- nodes %>%
  mutate(
    maturity_rating = as.factor(mature), # Assuming maturity_rating column is binary
    degree_centrality = as.numeric(degree_centrality), 
    eigenvector_centrality = as.numeric(eigenvector_centrality),
    closeness_centrality = as.numeric(closeness_centrality)
  ) %>%
  filter(!is.na(views) & !is.na(maturity_rating)) # Remove missing values

# 2.3 Exploratory Data Analysis
# Summary statistics and basic distributions
summary(data)
summary(data$views)
table(data$maturity_rating)

# Hypothesis Testing
# T-test for views by maturity rating
t_test_result <- t.test(views ~ maturity_rating, data = data)
print(t_test_result)

# Regression Analysis 1: Basic model
# Control for life_time and eigenvector_centrality
basic_model <- lm(views ~ maturity_rating + life_time + eigenvector_centrality, data = data)
summary(basic_model)

# Regression Analysis 2: Interaction model with centrality measures
interaction_model <- lm(
  views ~ maturity_rating * (degree_centrality + eigenvector_centrality + closeness_centrality + betweenness_centrality), 
  data = data
)
summary(interaction_model)

# Additional Model Diagnostics
# Check residuals and other diagnostic plots for the regression model
par(mfrow = c(2, 2)) # Plot grid for model diagnostics
plot(interaction_model)

