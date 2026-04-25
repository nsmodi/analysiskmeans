
#' Compute Principal Component Analysis
#'
#'
#'
#' @param mat_norm A normalized matrix of the top x genes you want to analyze
#'
#' @return Resulting PCA matrix
#' @export
#' @examples
#' library(analysiskmeans)
#' data(example_sce)
#' SingleCellExperiment::logcounts(example_sce) <- log1p(SingleCellExperiment::counts(example_sce))#Line taken from Claude AI - Debug
#' sce <- example_sce
#' results <- data_config(sce)
#' mat_norm <- top_x_genes(results$sce, n_top = 50)
#' computepca(mat_norm)


computepca <- function(mat_norm){

  pca <- stats::prcomp(t(mat_norm),scale. = TRUE, center = TRUE)

  return(pca)
}

#' Conduct K Means Clustering
#'
#' @param min_k The min amount k value you wish to start at
#' @param max_k The max amount k value you wish to go up to
#' @param n_starts Number of initial sets
#' @param seed Random seed for reproducibility
#' @param pca Resulting PCA matrix
#'
#'
#' @return List Average silhouette scores and of K Means clustering results with various K values
#' @export
#' @examples
#' library(analysiskmeans)
#' data(example_sce)
#' SingleCellExperiment::logcounts(example_sce) <- log1p(SingleCellExperiment::counts(example_sce))#Line taken from Claude AI - Debug
#' sce <- example_sce
#' results <- data_config(sce)
#' mat_norm <- top_x_genes(results$sce, n_top = 50)
#' pca <- computepca(mat_norm)
#' k_means(4, 9, n_starts = 25, seed = 42, pca)

k_means <- function(min_k, max_k, n_starts = 25, seed = 42, pca){
  pca_mat <- pca$x[, 1:20]  # first 20 PCs for clustering
  metrics <- data.frame(k = min_k:max_k, wss = NA_real_, avg_silhouette = NA_real_)
  km_list <- list()

  #---
  for (k in min_k:max_k) {
    km <- stats::kmeans(pca_mat, centers = k, nstart = n_starts)
    km_list[[as.character(k)]] <- km
    metrics$wss[k - min_k + 1] <- km$tot.withinss
    sil <- cluster::silhouette(km$cluster, stats::dist(pca_mat))
    metrics$avg_silhouette[k - min_k + 1] <- mean(sil[, "sil_width"])
  }
  #---
  return(list("metrics" = metrics, "km_list" = km_list))
}


