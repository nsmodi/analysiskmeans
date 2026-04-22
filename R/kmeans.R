
#' Compute Principal Component Analysis
#'
#'
#'
#' @param mat_norm A normalized matrix of the top x genes you want to analyze
#'
#' @return Resulting PCA matrix
#' @export
#'


computepca <- function(mat_norm){
  pca <- stats::prcomp(t(mat_norm), scale. = TRUE, center = TRUE)
  pca_mat <- pca$x[, 1:20]  # first 20 PCs for clustering
  return(list("pca" = pca, "pca_mat" = pca_mat))
}

#' Conduct K Means Clustering
#'
#' @param max_k The max amount k value you wish to go up to
#' @param n_starts Number of initial sets
#' @param seed Random seed for reproducibility
#' @param pca Resulting PCA matrix
#'
#'
#' @return List Average silhouette scores and of K Means clustering results with various K values
#' @export

k_means <- function(max_k, n_starts = 25, seed = 42, pca_mat){

  metrics <- data.frame(k = 5:max_k, wss = NA_real_, avg_silhouette = NA_real_)
  km_list <- list()
  for (k in 5:max_k) {
    km <- stats::kmeans(pca_mat, centers = k, nstart = n_starts)
    km_list[[as.character(k)]] <- km
    metrics$wss[k - 1] <- km$tot.withinss # Total within-cluster sum of squares
    sil <- cluster::silhouette(km$cluster, stats::dist(pca_mat))
    metrics$avg_silhouette[k - 1] <- mean(sil[, "sil_width"])
  }
  return(list("metrics" = metrics, "km_list" = km_list))
}


