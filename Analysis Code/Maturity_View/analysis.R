# Load necessary libraries
library(tidyverse)
library(igraph)

# Load the dataset
# Assuming edges.csv contains edge data (source, target)
# Assuming nodes.csv contains node data (e.g., view_count, explicit/maturity_rating)
edges <- read.csv("large_twitch_edges.csv") # Replace with actual file path
nodes <- read.csv("large_twitch_features.csv") # Replace with actual file path

# Create graph from edge list
g <- graph_from_data_frame(d = edges, vertices = nodes, directed = FALSE) #not working

# Compute Centrality Measures
nodes <- nodes %>%
  mutate(
    degree_centrality = degree(g, mode = "all"),
    eigenvector_centrality = eigen_centrality(g)$vector,
    closeness_centrality = closeness(g, normalized = TRUE),
    betweenness_centrality = betweenness(g, normalized = TRUE)
  )

# Merge Centrality Metrics with Node Attributes
data <- nodes %>%
  mutate(
    maturity_rating = as.factor(mature), # Assuming maturity_rating column is binary
    degree_centrality = as.numeric(degree_centrality), 
    eigenvector_centrality = as.numeric(eigenvector_centrality),
    closeness_centrality = as.numeric(closeness_centrality)
  ) %>%
  filter(!is.na(view_count) & !is.na(maturity_rating)) # Remove missing values

# Exploratory Data Analysis
# Summary statistics and basic distributions
summary(data)
summary(data$view_count)
table(data$maturity_rating)

# Hypothesis Testing
# T-test for view counts by maturity rating
t_test_result <- t.test(view_count ~ maturity_rating, data = data)
print(t_test_result)

# Regression Analysis 1: Basic model
# Control for follower count and eigenvector centrality
basic_model <- lm(view_count ~ maturity_rating + follower_count + eigenvector_centrality, data = data)
summary(basic_model)

# Regression Analysis 2: Interaction model with centrality measures
interaction_model <- lm(
  view_count ~ maturity_rating * (degree_centrality + eigenvector_centrality + closeness_centrality + betweenness_centrality), 
  data = data
)
summary(interaction_model)

# Visualize the results: Boxplot for maturity rating and view count
ggplot(data, aes(x = maturity_rating, y = view_count)) +
  geom_boxplot() +
  labs(
    title = "View Count by Maturity Rating", 
    x = "Maturity Rating", 
    y = "View Count"
  ) +
  theme_minimal()

# Visualize Interaction Effects: Degree Centrality and Maturity Rating
ggplot(data, aes(x = degree_centrality, y = view_count, color = maturity_rating)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "View Count vs Degree Centrality by Maturity Rating",
    x = "Degree Centrality",
    y = "View Count",
    color = "Maturity Rating"
  ) +
  theme_minimal()

# Additional Model Diagnostics
par(mfrow = c(2, 2)) # Plot grid
plot(interaction_model)
