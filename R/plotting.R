#' Create an elbow plot
#'
#' @param metrics List of silhouette scores
#' @return Resulting Elbow Plot
#' @export
#'
#'


elbow_plot <- function(metrics){
  k_vals <- metrics$k
  wss_vals <- metrics$wss
  p_elbow <- ggplot2::ggplot(metrics, ggplot2::aes(x = k_vals, y = wss_vals)) +
  ggplot2::geom_line() + ggplot2::geom_point(size = 2) +
  ggplot2::theme_bw(base_size = 14) +
  ggplot2::labs(x = "Number of Clusters (k)",
       y = "Total Within-Cluster Sum of Squares",
       title = "Elbow Plot")
  print(p_elbow)
  return(p_elbow)
}
#' Create final scatter plot of kmeans clustering
#' @param selected_k Kmeans Value Selected
#' @param km_list List of K Means clustering results with various K values
#' @param pca PCA values dataframe
#' @param cell_type Cell type labels provided
#' @return Resulting Cluster Plot
#' @export
#' @examples
#' library(analysiskmeans)
#' data(example_sce)
#' SingleCellExperiment::logcounts(example_sce) <- log1p(SingleCellExperiment::counts(example_sce))#Line taken from Claude AI - Debug
#' sce <- example_sce
#' results <- data_config(sce)
#' mat_norm <- top_x_genes(results$sce, n_top = 50)
#' pca <- computepca(mat_norm)
#' outputs <- k_means(4, 9, n_starts = 25, seed = 42, pca)
#' cluster_plot(7, outputs$km_list, pca, results$cell_type)

cluster_plot <- function(selected_k, km_list, pca, cell_type){
  km_sel <- km_list[[as.character(selected_k)]]
  scatter_df <- data.frame(
    PC1 = pca$x[, 1], PC2 = pca$x[, 2],
    cluster = base::factor(km_sel$cluster),
    cell_type = cell_type
  )
  grDevices::graphics.off()
  p_scatter <- ggplot2::ggplot(scatter_df, ggplot2::aes(x = PC1, y = PC2, color = cluster)) +
    ggplot2::geom_point(size = 4, alpha = 0.6) +
    ggplot2::theme_bw(base_size = 14) +
    ggplot2::labs(title = paste0("K-means (k=", selected_k, ") on PCA"))
  print(p_scatter)
  return(p_scatter)

}
