library(ggplot2)
library(igraph)
library(dplyr)
nodes <- read.csv("large_twitch_features.csv")
edges <- read.csv("large_twitch_edges.csv")
set.seed(1)
sampled_nodes <- sample(nodes$numeric_id, 100000, replace = FALSE)
filtered_edges_df <- edges %>% filter(edges$numeric_id_1 %in% sampled_nodes & edges$numeric_id_2 %in% sampled_nodes)
g <- graph_from_data_frame(d = filtered_edges_df, vertices = sampled_nodes, directed = FALSE)


# Compute Centrality Measures
# Compute the centrality measures
degree_centrality <- degree(g, mode = "all")
eigenvector_centrality <- eigen_centrality(g)$vector
closeness_centrality <- closeness(g, normalized = TRUE)
betweenness_centrality <- betweenness(g, normalized = TRUE)

# Add the centrality measures to the nodes data frame
nodes <- nodes %>%
  mutate(
    degree_centrality = ifelse(rownames(nodes) %in% sampled_nodes, degree_centrality[rownames(nodes) %in% sampled_nodes], NA),
    eigenvector_centrality = ifelse(rownames(nodes) %in% sampled_nodes, eigenvector_centrality[rownames(nodes) %in% sampled_nodes], NA),
    closeness_centrality = ifelse(rownames(nodes) %in% sampled_nodes, closeness_centrality[rownames(nodes) %in% sampled_nodes], NA),
    betweenness_centrality = ifelse(rownames(nodes) %in% sampled_nodes, betweenness_centrality[rownames(nodes) %in% sampled_nodes], NA)
  )

  filtered_nodes <- nodes %>%
  filter(
    degree_centrality != 0 &
      eigenvector_centrality != 0 &
      closeness_centrality != 0 &
      betweenness_centrality != 0
  )

# Merge centrality metrics with node attributes (e.g., views, maturity)
data <- filtered_nodes %>%
  mutate(
    maturity_rating = as.factor(mature),  # Assuming 'mature' column is binary
    degree_centrality = as.numeric(degree_centrality),
    eigenvector_centrality = as.numeric(eigenvector_centrality),
    closeness_centrality = as.numeric(closeness_centrality)
  ) %>%
  filter(!is.na(views) & !is.na(mature))  # Remove missing values

# Exploratory Data Analysis
# Summary statistics and basic distributions
summary(data)
summary(data$views)
table(data$maturity_rating)

# Hypothesis Testing
# T-test for view counts by maturity rating
t_test_result <- t.test(views ~ mature, data = data)
print(t_test_result)

# Regression Analysis 1: Basic model
# Control for follower count and eigenvector centrality
# Basic regression model without follower_count
basic_model <- lm(views ~ mature + degree_centrality + eigenvector_centrality + closeness_centrality + betweenness_centrality, data = data)

# Display the model summary
summary(basic_model)


# Regression Analysis 2: Interaction model with centrality measures
interaction_model <- lm(
  views ~ mature * (degree_centrality + eigenvector_centrality + closeness_centrality + betweenness_centrality), 
  data = data
)
summary(interaction_model)

# Enhanced Violin Plot for View Count by Maturity Rating
ggplot(data, aes(x = factor(mature), y = log1p(views), fill = factor(mature))) +
  geom_violin(trim = FALSE, color = "black", alpha = 0.6) +  # Violin plot with black borders and some transparency
  scale_fill_manual(values = c("#F0A1A1", "#8AC1D4")) +  # Custom fill colors for each maturity rating
  scale_y_continuous(
    limits = c(0, 10),  # Limit the y-axis for better visibility
    breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10),  # Set custom breaks for y-axis
    labels = scales::comma_format()  # Format y-axis labels
  ) +
  labs(
    title = "Log-transformed View Count Distribution by Maturity Rating", 
    x = "Maturity Rating", 
    y = "Log-transformed View Count"
  ) +
  theme_minimal(base_size = 15) +  # Minimal theme with increased font size
  theme(
    axis.text = element_text(size = 12, color = "black"),
    axis.title = element_text(size = 14, face = "bold"),
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    legend.position = "none",  # Remove legend since it's binary
    panel.grid.major = element_line(color = "grey90"),  # Light grid lines
    panel.grid.minor = element_blank()  # No minor grid lines
  )
# Additional Model Diagnostics
# Sort the data by views in descending order
sorted_data <- data %>%
  arrange(desc(views))

# View the top entries (e.g., top 10 highest view counts)
head(sorted_data, 10)

# Filter to show the entries with the highest view counts
top_viewers <- data %>%
  arrange(desc(views)) %>%
  head(10)  # Adjust the number as needed to see more or fewer top viewers

# View the result
top_viewers

# Summarize the top 10 highest view counts by maturity status
top_viewers_summary <- data %>%
  arrange(desc(views)) %>%
  head(10) %>%
  group_by(maturity_rating) %>%
  summarise(
    max_view_count = max(views),
    count = n()
  )

# View the result
top_viewers_summary


# View the top entries (e.g., top 10 highest view counts)
head(sorted_data, 50)

# Filter to show the entries with the highest view counts
top_viewers <- data %>%
  arrange(desc(views)) %>%
  head(50)  # Adjust the number as needed to see more or fewer top viewers

# View the result
top_viewers

# Summarize the top 10 highest view counts by maturity status
top_viewers_summary <- data %>%
  arrange(desc(views)) %>%
  head(50) %>%
  group_by(maturity_rating) %>%
  summarise(
    max_view_count = max(views),
    count = n()
  )

# View the result
top_viewers_summary


