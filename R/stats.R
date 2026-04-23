
#' Compute Gap Statistic for each K
#'
#' @param pca_mat PCA matrix
#' @param n_starts Number of initial sets
#' @param max_k The max amount k value you wish to go up to
#' @param metrics List of silhouette scores
#'
#'
#' @return Table of Gap statistic values for each K
#' @export
#'



gap_statistic <- function(pca, n_starts=25, max_k, metrics){
  pca_mat <- pca$x[, 1:20]  # first 20 PCs for clustering
  gap_stat <- cluster::clusGap(pca_mat, FUN = stats::kmeans, nstart = n_starts,
                      K.max = max_k, B = 20)
  gap_tab <- as.data.frame(gap_stat$Tab)
  metrics$gap <- gap_tab$gap[5:max_k]
  metrics$gap_se <- gap_tab$SE.sim[5:max_k]

  return(gap_tab)
}
#' Compute ARI Values for each K
#'
#' @param max_k The max amount k value you wish to go up to
#' @param km_list List of K Means clustering results with various K values
#' @param cell_type Corresponding cell type labels
#'
#' @return ARI values for each K
#' @export
evaluation_metrics <- function(min_k,max_k, km_list, cell_type){
  evaluation <- data.frame(k = min_k:max_k, ari = NA_real_)
  for (k in min_k:max_k) {
    pred <- km_list[[as.character(k)]]$cluster
    tab <- table(unlist(cell_type), pred)
    n <- sum(tab)
    sum_comb <- function(x) x * (x - 1) / 2
    sum_rows <- sum(sum_comb(rowSums(tab)))
    sum_cols <- sum(sum_comb(colSums(tab)))
    sum_all  <- sum(sum_comb(tab))
    expected <- sum_rows * sum_cols / sum_comb(n)
    max_index <- (sum_rows + sum_cols) / 2
    ari <- if (max_index == expected) 0 else (sum_all - expected) / (max_index - expected)
    evaluation$ari[k - min_k + 1] <- ari
  }
  return(evaluation)
}
