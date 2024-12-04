# Calculate the degree for all nodes
degree_centrality <- degree(g)

# Get degree values for red and blue nodes separately
degree_red <- degree_centrality[red_nodes]
degree_blue <- degree_centrality[blue_nodes]



# Mature content
top_red_nodes <- head(sort(degree_red, decreasing = TRUE), 10)
top_red_nodes_df <- data.frame(Node = names(top_red_nodes), Degree = top_red_nodes)

cat("Top 10 Red (Mature Content) Nodes by Degree:\n")
print(top_red_nodes_df)

avg_degree_red <- mean(degree_centrality[red_nodes])
cat("Average Degree Centrality for Red (Mature) Nodes: ", avg_degree_red, "\n")

# Non-mature content
top_blue_nodes <- head(sort(degree_blue, decreasing = TRUE), 10)
top_blue_nodes_df <- data.frame(Node = names(top_blue_nodes), Degree = top_blue_nodes)

cat("\nTop 10 Blue (Non-Mature Content) Nodes by Degree:\n")
print(top_blue_nodes_df)

avg_degree_blue <- mean(degree_centrality[blue_nodes])
cat("Average Degree Centrality for Blue (Non-Mature) Nodes: ", avg_degree_blue, "\n")



# Boxplot of degree centrality for red and blue nodes
boxplot(degree_red, degree_blue, 
        names = c("Red Nodes", "Blue Nodes"), 
        main = "Degree Centrality Comparison", 
        col = c("red", "blue"), 
        ylab = "Degree Centrality",
        border = "black")
