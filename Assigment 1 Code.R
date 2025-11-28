library(sna)
library(ergm)
library(igraph)

# Grotto Tommaso

setwd("C:/Users/39348/Downloads/Advanced Social Network Analysis/Assingment1")
list.files()

load("Borgatti_Scientists504.RDA")

Borgatti_Scientists504$Collaboration

Borgatti_Scientists504$Attributes

# 1

# Create a graph object from the Collaboration matrix
graph <- graph_from_adjacency_matrix(Borgatti_Scientists504$Collaboration, mode = "undirected", weighted = TRUE)

# Apply the cutoff (>2)
graph_cutoff <- delete_edges(graph, E(graph)[weight <= 2])

# Simplify the graph (optional, to remove loops or multiple edges if any)
graph_cutoff <- simplify(graph_cutoff, remove.multiple = TRUE, remove.loops = TRUE)

# Basic plot
plot(
  graph_cutoff, 
  vertex.size = 5, 
  vertex.label = NA,  # Suppress labels for clarity
  edge.width = E(graph_cutoff)$weight / 2,  # Scale edge width by weight
  main = "Collaboration Network (Cutoff > 2)"
)

# 2

# Add the 'Years' attribute to the nodes
V(graph_cutoff)$years <- Borgatti_Scientists504$Attributes$Years

# Define a color gradient for seniority
color_palette <- colorRampPalette(c("lightblue", "blue"))  # Adjust colors if needed
node_colors <- color_palette(100)[cut(V(graph_cutoff)$years, breaks = 100)]

# Plot with node colors representing seniority
plot(
  graph_cutoff,
  vertex.size = 5, 
  vertex.color = node_colors,
  vertex.label = NA,
  edge.width = E(graph_cutoff)$weight / 2,
  main = "Collaboration Network (Nodes Colored by Seniority)"
)

# Add a legend for color gradient
legend(
  "topright", 
  legend = c("Few Years", "Many Years"), 
  fill = color_palette(2), 
  title = "Seniority",
  bty = "n"  # No border around the legend
)

# 3

# Compute betweenness centrality
betweenness_values <- betweenness(graph_cutoff, directed = FALSE, weights = E(graph_cutoff)$weight)

# Add betweenness values to the graph
V(graph_cutoff)$betweenness <- betweenness_values

# Identify the top node(s) by betweenness centrality
top_betweenness <- which(betweenness_values == max(betweenness_values))
top_betweenness_nodes <- names(V(graph_cutoff))[top_betweenness]

# Print results
cat("Top node(s) by Betweenness Centrality:\n")
print(top_betweenness_nodes)
cat("Betweenness value:\n")
print(max(betweenness_values))

# Compute eigenvector centrality
eigenvector_values <- eigen_centrality(graph_cutoff, directed = FALSE, weights = E(graph_cutoff)$weight)$vector

# Add eigenvector centrality values to the graph
V(graph_cutoff)$eigenvector <- eigenvector_values

# Identify the top node(s) by eigenvector centrality
top_eigenvector <- which(eigenvector_values == max(eigenvector_values))
top_eigenvector_nodes <- names(V(graph_cutoff))[top_eigenvector]

# Print results
cat("Top node(s) by Eigenvector Centrality:\n")
print(top_eigenvector_nodes)
cat("Eigenvector value:\n")
print(max(eigenvector_values))

# Highlight top nodes
vertex_colors <- ifelse(names(V(graph_cutoff)) %in% c(top_betweenness_nodes, top_eigenvector_nodes), "red", "skyblue")

# Visualize with top nodes highlighted
plot(
  graph_cutoff,
  vertex.size = 5,
  vertex.color = vertex_colors,
  vertex.label = NA,
  edge.width = E(graph_cutoff)$weight / 2,
  main = "Collaboration Network (Top Nodes Highlighted)"
)

# 4

# Ensure both measures are computed
betweenness_values <- V(graph_cutoff)$betweenness
eigenvector_values <- V(graph_cutoff)$eigenvector

# Compute Pearson correlation
pearson_corr <- cor(betweenness_values, eigenvector_values, method = "pearson")

# Print the result
cat("Pearson Correlation between Betweenness and Eigenvector Centrality:\n")
print(pearson_corr)

# Scatterplot
plot(
  betweenness_values, 
  eigenvector_values, 
  xlab = "Betweenness Centrality", 
  ylab = "Eigenvector Centrality",
  main = "Correlation between Betweenness and Eigenvector Centrality",
  pch = 16,
  col = "blue"
)

# 5

# Extract years (seniority) attribute
seniority <- V(graph_cutoff)$years

# Ensure centrality measures are available
betweenness_values <- V(graph_cutoff)$betweenness
eigenvector_values <- V(graph_cutoff)$eigenvector

# Correlate Betweenness Centrality with Seniority
pearson_corr_bet_sen <- cor(betweenness_values, seniority, method = "pearson")

# Correlate Eigenvector Centrality with Seniority
pearson_corr_eig_sen <- cor(eigenvector_values, seniority, method = "pearson")

# Print results
cat("Pearson Correlation between Betweenness Centrality and Seniority:\n")
print(pearson_corr_bet_sen)
cat("Pearson Correlation between Eigenvector Centrality and Seniority:\n")
print(pearson_corr_eig_sen)


# Scatterplot for Betweenness Centrality vs Seniority
plot(
  seniority, 
  betweenness_values, 
  xlab = "Seniority (Years)", 
  ylab = "Betweenness Centrality",
  main = "Betweenness Centrality vs Seniority",
  pch = 16,
  col = "blue"
)

# Scatterplot for Eigenvector Centrality vs Seniority
plot(
  seniority, 
  eigenvector_values, 
  xlab = "Seniority (Years)", 
  ylab = "Eigenvector Centrality",
  main = "Eigenvector Centrality vs Seniority",
  pch = 16,
  col = "red"
)
