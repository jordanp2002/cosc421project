# Find the maximal cliques in the graph
cliques_list <- max_cliques(g)

# Analyze the size of each clique
clique_sizes <- sapply(cliques_list, length)

# Identify cliques containing red or blue nodes
red_cliques <- list()
blue_cliques <- list()

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

cat("Number of cliques containing red (mature content) nodes:", length(red_cliques), "\n")
cat("Number of cliques containing blue (non-mature content) nodes:", length(blue_cliques), "\n")

red_clique_sizes <- sapply(red_cliques, length)
blue_clique_sizes <- sapply(blue_cliques, length)

# Set up layout for side-by-side histograms
par(mfrow = c(1, 2))

# Histogram for cliques containing red nodes
hist(red_clique_sizes, 
     main = "Clique Sizes for Red Nodes", 
     xlab = "Clique Size", 
     col = "red", 
     breaks = 10, 
     xlim = range(c(red_clique_sizes, blue_clique_sizes)))

# Histogram for cliques containing blue nodes
hist(blue_clique_sizes, 
     main = "Clique Sizes for Blue Nodes", 
     xlab = "Clique Size", 
     col = "blue", 
     breaks = 10, 
     xlim = range(c(red_clique_sizes, blue_clique_sizes)))

# Reset layout to default
par(mfrow = c(1, 1))
