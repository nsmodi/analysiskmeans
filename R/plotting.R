#' Conduct K Means Clustering
#'
#' @param mat_norm A normalized matrix of the top x genes you want to analyze
#' @param max_k The max amount k value you wish to go up to
#' @param pca_mat Resulting PCA matrix
#' @param seed Random seed for reproducibility
#' @param n_starts Number of initial sets
#'
#'
#' @return PCA matrix
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
