install.packages("igraph")
install.packages("statnet")
install.packages("dplyr")
install.packages("ggplot2")
library(igraph)
library(statnet)
library(dplyr)
library(ggplot2)

nodes <- read.csv("large_twitch_features.csv")
edges <- read.csv("large_twitch_edges.csv")
set.seed(1)
sampled_nodes <- sample(nodes$numeric_id, 100000, replace = FALSE)
filtered_edges_df <- edges %>% filter(edges$numeric_id_1 %in% sampled_nodes & edges$numeric_id_2 %in% sampled_nodes)
g <- graph_from_data_frame(d = filtered_edges_df, vertices = sampled_nodes, directed = FALSE)

# Apply Louvain community detection algorithm
louvain_communities <- cluster_louvain(g)

# Modularity score to assess the quality of the community structure
modularity_score <- modularity(louvain_communities)
print(paste("Modularity Score:", modularity_score))

# Plot the communities
plot(louvain_communities, g, main = "Twitch Streamer Communities")

# Degree Centrality
degree_centrality <- degree(g)
print("Degree Centrality:")
print(degree_centrality)

# Eigenvector Centrality
eigenvector_centrality <- eigen_centrality(g)$vector
print("Eigenvector Centrality:")
print(eigenvector_centrality)

# Identifying cliques (maximal cliques)
cliques <- cliques(g)
print("Cliques:")
print(cliques)

# Linear regression for degree centrality and views
lm_degree <- lm(view_count ~ degree_centrality, data = twitch_data)
summary(lm_degree)

# Linear regression for eigenvector centrality and views
lm_eigenvector <- lm(view_count ~ eigenvector_centrality, data = twitch_data)
summary(lm_eigenvector)

# Interaction model to test the effect of community on centrality and views
lm_interaction <- lm(view_count ~ degree_centrality * community + eigenvector_centrality * community, data = twitch_data)
summary(lm_interaction)

twitch_data$community <- membership(louvain_communities) # Assign community membership
twitch_data$degree_centrality <- degree_centrality
twitch_data$eigenvector_centrality <- eigenvector_centrality

# Plot relationship between centrality measures and view count
ggplot(twitch_data, aes(x = degree_centrality, y = view_count)) + 
  geom_point() + 
  labs(title = "Degree Centrality vs View Count")

ggplot(twitch_data, aes(x = eigenvector_centrality, y = view_count)) + 
  geom_point() + 
  labs(title = "Eigenvector Centrality vs View Count")

# Visualize network with communities and centrality measures
V(g)$size <- degree_centrality # Node size based on degree centrality
plot(g, vertex.size = V(g)$size, vertex.color = membership(louvain_communities), main = "Twitch Network with Communities")
