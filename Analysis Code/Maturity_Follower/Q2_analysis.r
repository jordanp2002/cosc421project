install.packages("igraph")
library(igraph)

# Load data
nodes <- read.csv("twitch_gamers/large_twitch_features.csv")
edges <- read.csv("twitch_gamers/large_twitch_edges.csv")

# Set a seed for reproducibility
set.seed(42)

# Sample 10,000 edges
sampled_edges <- edges[sample(nrow(edges), 10000), ]

# Extract unique nodes from the sampled edges
sampled_nodes <- unique(c(sampled_edges$numeric_id_1, sampled_edges$numeric_id_2))

# Filter nodes data to match the sampled nodes
nodes <- nodes[nodes$numeric_id %in% sampled_nodes, ]

# Create a color vector based on maturity (1 = mature, 0 = non-mature)
node_colors <- ifelse(nodes$mature == 1, "red", "blue")
#
#
#



# Degree Centrality Analysis
# Step 1: Create the Graph
g <- graph_from_data_frame(d = sampled_edges, vertices = sampled_nodes, directed = FALSE)

# Step 2: Calculate the Degree for All Nodes
degree_all <- degree(g)

# Step 3: Separate the nodes by color (red = mature, blue = non-mature)
# Create a logical vector for red and blue nodes
red_nodes <- V(g)$name[node_colors == "red"]
blue_nodes <- V(g)$name[node_colors == "blue"]

# Step 4: Get degree values for red and blue nodes separately
degree_red <- degree_all[red_nodes]
degree_blue <- degree_all[blue_nodes]

# Step 5: Create data frames for the top 10 nodes with highest degree for red and blue nodes
# Mature content
top_red_nodes <- head(sort(degree_red, decreasing = TRUE), 10)
top_red_nodes_df <- data.frame(Node = names(top_red_nodes), Degree = top_red_nodes)

# Non-mature content
top_blue_nodes <- head(sort(degree_blue, decreasing = TRUE), 10)
top_blue_nodes_df <- data.frame(Node = names(top_blue_nodes), Degree = top_blue_nodes)

# Step 6: Display the top 10 red nodes and blue nodes
cat("Top 10 Red (Mature Content) Nodes by Degree:\n")
print(top_red_nodes_df)

cat("\nTop 10 Blue (Non-Mature Content) Nodes by Degree:\n")
print(top_blue_nodes_df)

# Calculate average degree centrality for red and blue nodes
avg_degree_red <- mean(degree_centrality[red_nodes])
avg_degree_blue <- mean(degree_centrality[blue_nodes])

# Print the results
cat("Average Degree Centrality for Red (Mature) Nodes: ", avg_degree_red, "\n")
cat("Average Degree Centrality for Blue (Non-Mature) Nodes: ", avg_degree_blue, "\n")
#
#
#



# Cliques Analysis
# Step 1: Find the maximal cliques in the graph
cliques_list <- max_cliques(g)

# Step 2: Analyze the size of each clique
clique_sizes <- sapply(cliques_list, length)

# Step 3: Identify cliques containing red or blue nodes
red_cliques <- list()
blue_cliques <- list()

# Loop through cliques and separate those containing red or blue nodes
for (clique in cliques_list) {
  red_nodes_in_clique <- intersect(clique, red_nodes)
  blue_nodes_in_clique <- intersect(clique, blue_nodes)
  
  if (length(red_nodes_in_clique) > 0) {
    red_cliques <- append(red_cliques, list(clique))
  }
  
  if (length(blue_nodes_in_clique) > 0) {
    blue_cliques <- append(blue_cliques, list(clique))
  }
}

# Step 4: Display the number of cliques containing red and blue nodes
cat("Number of cliques containing red (mature content) nodes:", length(red_cliques), "\n")
cat("Number of cliques containing blue (non-mature content) nodes:", length(blue_cliques), "\n")
#
#
#



# Modularity Analysis
# Perform community detection using Louvain method
community_louvain <- cluster_louvain(g)

# Get modularity score
modularity_score <- modularity(community_louvain)

# Print modularity score
cat("Modularity Score:", modularity_score, "\n")

# Assign community membership to each node
V(g)$community <- membership(community_louvain)

# Examine how many communities there are
length(unique(membership(community_louvain)))

# Count how many red (mature) and blue (non-mature) nodes belong to each community
table(V(g)$community, V(g)$color)

# Optionally, get a table of nodes with their respective community labels
community_table <- data.frame(node = V(g)$name, community = V(g)$community, color = V(g)$color)
head(community_table)
#
#
#



# Eigenvector Centrality Analysis



