#' Create an elbow plot
#'
#' @param metrics List of silhouette scores
#' @return Resulting Elbow Plot
#'
#'
#' @param selected_k Kmeans Value Selected
#' @param km_list List of K Means clustering results with various K values
#' @return Resulting Cluster Plot
#' @export
#'
#'


elbow_plot <- function(metrics){
  p_elbow <- ggplot(metrics, aes(x = k, y = wss)) +
  geom_line() + geom_point(size = 2) +
  theme_bw(base_size = 14) +
  labs(x = "Number of Clusters (k)",
       y = "Total Within-Cluster Sum of Squares",
       title = "Elbow Plot")
  print(p_elbow)
  return(p_elbow)
}

cluster_plot <- function(selected_k, km_list){
  km_sel <- km_list[[as.character(selected_k)]]
  scatter_df <- data.frame(
    PC1 = pca$x[, 1], PC2 = pca$x[, 2],
    cluster   = factor(km_sel$cluster),
    cell_type = cell_type
  )
  p_scatter <- ggplot(scatter_df, aes(x = PC1, y = PC2, color = cluster)) +
    geom_point(size = 0.6, alpha = 0.6) +
    theme_bw(base_size = 14) +
    labs(title = paste0("K-means (k=", selected_k, ") on PCA"))
    print(p_scatter)
    return(p_scatter)

}
