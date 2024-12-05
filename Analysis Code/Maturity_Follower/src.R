install.packages("igraph")
install.packages("ggplot2")
install.packages("dplyr")
library(igraph)
library(ggplot2)
library(dplyr)

# Load data
nodes <- read.csv("top_100000_nodes.csv", row.names = "numeric_id")
edges <- read.csv("top_300000_edges.csv")
set.seed(1)
sampled_nodes <- sample(rownames(nodes), 100000, replace = FALSE)
filtered_edges_df <- edges %>% filter(edges$numeric_id_1 %in% sampled_nodes & edges$numeric_id_2 %in% sampled_nodes)
g <- graph_from_data_frame(d = filtered_edges_df, vertices = sampled_nodes, directed = FALSE)

# Create a color vector based on maturity (1 = mature, 0 = non-mature)
node_colors <- ifelse(nodes$mature == 1, "red", "blue")

# Separate the nodes by color (red = mature, blue = non-mature)
# Create a logical vector for red and blue nodes
red_nodes <- V(g)$name[node_colors == "red"]
blue_nodes <- V(g)$name[node_colors == "blue"]



# CAUTION: RESET FUNCTION
rm(list = ls())
