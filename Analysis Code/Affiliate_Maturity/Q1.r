>library(ggplot2)
>library(igraph)
>library(dplyr)
>edges <- read.csv("large_twitch_edges.csv")
>nodes <- read.csv("large_twitch_features.csv")
>set.seed(1)
>sampled_nodes <- sample(nodes$numeric_id, 100000, replace = FALSE)
>filtered_edges_df <- edges %>% filter(edges$numeric_id_1 %in% sampled_nodes & edges$numeric_id_2 %in% sampled_nodes)
>g <- graph_from_data_frame(d = filtered_edges_df, vertices = sampled_nodes, directed = TRUE)
>graph_nodes <- nodes[nodes$numeric_id %in% sampled_nodes, ]
>V(g)$views <- graph_nodes$views
>V(g)$mature <- graph_nodes$mature
>V(g)$affiliate <- graph_nodes$affiliate

> analysis_data <- analysis_data %>%
+     mutate(
+         affiliate = factor(affiliate, levels = c(0, 1), labels = c("Non-Affiliate", "Affiliate")),
+         mature = factor(mature, levels = c(0, 1), labels = c("Non-Mature", "Mature"))
+     )
> ggplot(analysis_data, aes(x = affiliate, fill = mature)) +
+     geom_bar(position = "fill") +
+     scale_y_continuous(labels = scales::percent) +
+     labs(title = "Proportion of Maturity Ratings by Affiliate Status",
+          x = "Affiliate Status",
+          y = "Percentage",
+          fill = "Maturity Rating") +
+     theme_minimal()
> degree_centrality <- degree(g)
> degree_data <- data.frame(
+          degree = degree_centrality, 
+          mature = V(g)$mature,                   
+          affiliate = V(g)$affiliate
+         )
> avg_degree <- degree_data %>%
+              group_by(mature, affiliate) %>%
+              summarise(average_degree = mean(degree, na.rm = TRUE)) %>%  
+              arrange(mature, affiliate)
> print(avg_degree)
# A tibble: 4 × 3
# Groups:   mature [2]
  mature affiliate average_degree
   <int>     <int>          <dbl>
1      0         0           48.7
2      0         1           48.8
3      1         0           49.6
4      1         1           49.9
#Signficane test for avg degree centrality
> data <- data.frame(
+     group = c("Non-Mature, Non-Affiliate", "Non-Mature, Affiliate", 
+               "Mature, Non-Affiliate", "Mature, Affiliate"),
+     avg_degree = c(48.7, 48.8, 49.6, 49.9)
+ )
> kruskal_result <- kruskal.test(avg_degree ~ group, data = data)
> kruskal_result

	Kruskal-Wallis rank sum test

data:  avg_degree by group
Kruskal-Wallis chi-squared = 3, df = 3, p-value = 0.3916
#cluster coefficient based on maturity and affiliate status
> local_clustering_coefficients <- transitivity(g, type = "local")
> clustering_data <- data.frame(
+     numeric_id = V(g)$name,                              
+     clustering_coefficient = local_clustering_coefficients, 
+     maturity = factor(V(g)$mature, levels = c(0, 1), labels = c("Non-Mature", "Mature")),  
+     affiliate = factor(V(g)$affiliate, levels = c(0, 1), labels = c("Non-Affiliate", "Affiliate"))  
+ )
> clustering_summary <- clustering_data %>%
+     group_by(maturity, affiliate) %>%
+     summarise(
+         avg_clust = mean(clustering_coefficient, na.rm = TRUE),
+         max_clust = max(clustering_coefficient, na.rm = TRUE),
+         min_clust = min(clustering_coefficient, na.rm = TRUE)
+     )
.
> print(clustering_summary)
# A tibble: 4 × 5
# Groups:   maturity [2]
  maturity   affiliate     avg_clust max_clust min_clust
  <fct>      <fct>             <dbl>     <dbl>     <dbl>
1 Non-Mature Non-Affiliate     0.173         1         0
2 Non-Mature Affiliate         0.172         1         0
3 Mature     Non-Affiliate     0.174         1         0
4 Mature     Affiliate         0.174         1         0

#views based on maturity and affiliate status
> views_data <- data.frame(
+     numeric_id = V(g)$name,
+     views = V(g)$views,
+     mature = factor(V(g)$mature, levels = c(0, 1), labels = c("Non-Mature", "Mature")),
+     affiliate = factor(V(g)$affiliate, levels = c(0, 1), labels = c("Non-Affiliate", "Affiliate"))
+ )
> views_data <- views_data %>%
+     group_by(mature, affiliate) %>%
+     summarise(count = n(), 
+               avg_views = mean(views), 
+               max_views = max(views), 
+               .groups = "drop") %>%
+     arrange(desc(count))
> print(views_data)
# A tibble: 4 × 5
  mature     affiliate     count avg_views max_views
  <fct>      <fct>         <int>     <dbl>     <int>
1 Non-Mature Non-Affiliate 31814   436418. 384396587
2 Mature     Affiliate     27402    22892.   5461665
3 Non-Mature Affiliate     21064    22536.   4711774
4 Mature     Non-Affiliate 19720   243319. 240718261


#degree centrality of top 1000 nodes 
> degree_data <- data.frame(
+     numeric_id = V(g)$name,                              
+     degree = degree_centrality,                     
+     maturity = factor(V(g)$mature, levels = c(0, 1), labels = c("Non-Mature", "Mature")),  
+     affiliate = factor(V(g)$affiliate, levels = c(0, 1), labels = c("Non-Affiliate", "Affiliate"))  
+ )
> top_1000_nodes_degree <- degree_data %>%
+     arrange(desc(degree)) %>%
+     head(1000)
> top_1000_comparison <- top_1000_nodes_degree %>%
+     group_by(maturity, affiliate) %>%
+     summarise(
+         count = n(),
+         avg_degree = mean(degree),  
+         max_degree = max(degree),   
+         .groups = "drop"
+     )
> print(top_1000_comparison)
# A tibble: 4 × 5
  maturity   affiliate     count avg_degree max_degree
  <fct>      <fct>         <int>      <dbl>      <dbl>
1 Non-Mature Non-Affiliate   309      1164.      18483
2 Non-Mature Affiliate       194      1218.      13474
3 Mature     Non-Affiliate   207      1212.      18183
4 Mature     Affiliate       290      1190.      20761

> ggplot(top_1000_nodes_degree, aes(x = interaction(maturity, affiliate), y = degree, fill = interaction(maturity, affiliate))) +
+     geom_violin(trim = FALSE) +  
+     scale_y_log10() +  
+     labs(title = "Degree Distribution by Maturity and Affiliate Status (Top 1000)",
+          x = "Maturity | Affiliate Status", 
+          y = "Degree (log scaled)") +
+     theme_minimal() +
+     scale_fill_manual(values = c("#4a2377", "#f55f74", "#8cc5e3", "#0d7d87")) +  
+     theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

 #edge density based on maturity and affiliate status top 1000 nodes based on degree centrality
> top_1000_nodes <- head(order(degree(g), decreasing = TRUE), 1000)
> subgraph_top_1000 <- induced_subgraph(g, top_1000_nodes)

> subgraph_mature_affiliate <- induced_subgraph(g, V(g)$name %in% top_1000_nodes & V(g)$mature == "1" & V(g)$affiliate == "1")
> subgraph_mature_non_affiliate <- induced_subgraph(g, V(g)$name %in% top_1000_nodes & V(g)$mature == "1" & V(g)$affiliate == "0")
> subgraph_non_mature_non_affiliate <- induced_subgraph(g, V(g)$name %in% top_1000_nodes & V(g)$mature == "0" & V(g)$affiliate == "0")
> subgraph_non_mature_affiliate <- induced_subgraph(g, V(g)$name %in% top_1000_nodes & V(g)$mature == "0" & V(g)$affiliate == "1")

> density_mature_affiliate <- edge_density(subgraph_mature_affiliate)
> density_mature_non_affiliate <- edge_density(subgraph_mature_non_affiliate)
> density_non_mature_affiliate <- edge_density(subgraph_non_mature_affiliate)
> density_non_mature_non_affiliate <- edge_density(subgraph_non_mature_non_affiliate)

> density_table <- data.frame(
+     Maturity = c("Mature", "Mature", "Non-Mature", "Non-Mature"),
+     Affiliate_Status = c("Affiliate", "Non-Affiliate", "Affiliate", "Non-Affiliate"),
+     Density = c(density_mature_affiliate, density_mature_non_affiliate, 
+                 density_non_mature_affiliate, density_non_mature_non_affiliate)
+ )
> print(density_table)
    Maturity Affiliate_Status      Density
1     Mature        Affiliate 0.0004297115
2     Mature    Non-Affiliate 0.0001424299
3 Non-Mature        Affiliate 0.0007046389
4 Non-Mature    Non-Affiliate 0.0002985075

> kruskal_result_density <- kruskal.test(Density ~ interaction(Maturity, Affiliate_Status), data = density_table)
> kruskal_result_density

	Kruskal-Wallis rank sum test

data:  Density by interaction(Maturity, Affiliate_Status)
Kruskal-Wallis chi-squared = 3, df = 3, p-value = 0.3916

#largest clique based on maturity and affiliate status
> largest_cliques <- largest_cliques(g)
> largest_clique_nodes <- unique(unlist(largest_cliques))
> clique_node_data <- data.frame(
+     node = largest_clique_nodes,
+     maturity = factor(V(g)$mature[largest_clique_nodes], levels = c(0, 1), labels = c("Non-Mature", "Mature")),
+     affiliate = factor(V(g)$affiliate[largest_clique_nodes], levels = c(0, 1), labels = c("Non-Affiliate", "Affiliate"))
+ )
> 
> clique_summary <- clique_node_data %>%
+     group_by(maturity, affiliate) %>%
+     summarise(count = n(), .groups = "drop")
> print(clique_summary)
# A tibble: 4 × 3
  maturity   affiliate     count
  <fct>      <fct>         <int>
1 Non-Mature Non-Affiliate    26
2 Non-Mature Affiliate        14
3 Mature     Non-Affiliate    25
4 Mature     Affiliate        19

> community_detection <- cluster_louvain(g)
> community_membership <- membership(community_detection)
> community_data <- data.frame(
+     node = V(g)$name,
+     community = community_membership,
+     maturity = factor(V(g)$mature, levels = c(0, 1), labels = c("Non-Mature", "Mature")),
+     affiliate = factor(V(g)$affiliate, levels = c(0, 1), labels = c("Non-Affiliate", "Affiliate"))
+ )
> community_sizes <- community_data %>%
+     group_by(community) %>%
+     summarise(community_size = n(), .groups = "drop") %>%
+     arrange(desc(community_size)) %>%
+     head(10)
> top_10_communities <- community_data %>%
+     filter(community %in% community_sizes$community)
> community_summary <- top_10_communities %>%
+     group_by(community, maturity, affiliate) %>%
+     summarise(count = n(), .groups = "drop") %>%
+     group_by(community) %>%
+     mutate(
+         total_count = sum(count),
+         portion = count / total_count
+     )
> print(community_summary, n = 100)
# A tibble: 40 × 6
# Groups:   community [10]
   community  maturity   affiliate     count total_count portion
   <membrshp> <fct>      <fct>         <int>       <int>   <dbl>
 1  1         Non-Mature Non-Affiliate  1151        3642   0.316
 2  1         Non-Mature Affiliate       735        3642   0.202
 3  1         Mature     Non-Affiliate   783        3642   0.215
 4  1         Mature     Affiliate       973        3642   0.267
 5  2         Non-Mature Non-Affiliate  6872       21414   0.321
 6  2         Non-Mature Affiliate      4463       21414   0.208
 7  2         Mature     Non-Affiliate  4139       21414   0.193
 8  2         Mature     Affiliate      5940       21414   0.277
 9  3         Non-Mature Non-Affiliate  6035       19135   0.315
10  3         Non-Mature Affiliate      4057       19135   0.212
11  3         Mature     Non-Affiliate  3819       19135   0.200
12  3         Mature     Affiliate      5224       19135   0.273
13  4         Non-Mature Non-Affiliate  4067       12834   0.317
14  4         Non-Mature Affiliate      2743       12834   0.214
15  4         Mature     Non-Affiliate  2550       12834   0.199
16  4         Mature     Affiliate      3474       12834   0.271
17  6         Non-Mature Non-Affiliate  3070        9437   0.325
18  6         Non-Mature Affiliate      1996        9437   0.212
19  6         Mature     Non-Affiliate  1825        9437   0.193
20  6         Mature     Affiliate      2546        9437   0.270
21  7         Non-Mature Non-Affiliate  4719       14791   0.319
22  7         Non-Mature Affiliate      3060       14791   0.207
23  7         Mature     Non-Affiliate  2951       14791   0.200
24  7         Mature     Affiliate      4061       14791   0.275
25  8         Non-Mature Non-Affiliate   965        2936   0.329
26  8         Non-Mature Affiliate       604        2936   0.206
27  8         Mature     Non-Affiliate   549        2936   0.187
28  8         Mature     Affiliate       818        2936   0.279
29 10         Non-Mature Non-Affiliate   789        2586   0.305
30 10         Non-Mature Affiliate       568        2586   0.220
31 10         Mature     Non-Affiliate   515        2586   0.199
32 10         Mature     Affiliate       714        2586   0.276
33 11         Non-Mature Non-Affiliate  1629        5183   0.314
34 11         Non-Mature Affiliate      1153        5183   0.222
35 11         Mature     Non-Affiliate  1015        5183   0.196
36 11         Mature     Affiliate      1386        5183   0.267
37 13         Non-Mature Non-Affiliate   868        2778   0.312
38 13         Non-Mature Affiliate       588        2778   0.212
39 13         Mature     Non-Affiliate   525        2778   0.189
40 13         Mature     Affiliate       797        2778   0.287

> ggplot(community_summary, aes(x = factor(community), y = portion, fill = interaction(maturity, affiliate))) +
+     geom_bar(stat = "identity", position = "stack") +
+     labs(
+         title = "Portion of Maturity and Affiliate Status in Top 10 Largest Communities",
+         x = "Community",
+         y = "Proportion",
+         fill = "Maturity | Affiliate Status"
+     ) +
+     scale_fill_manual(values = c("#4a2377", "#f55f74", "#8cc5e3", "#0d7d87")) +
+     scale_y_continuous(labels = scales::percent) +  
+     theme_minimal()
