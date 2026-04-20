#' Configure and Normalize input data
#'
#'
#'
#' @param sce A SingleCellExperiment object
#'
#' @return A SingleCellExperiment subset to the top n_top variable genes as a matrix
#' @return Corresponding cell type labels
#' @return Log Normalized SingleCellExperiment object
#'
#' Select n top variable genes and data configuration
#'
#'
#'
#' @param sce A SingleCellExperiment object
#' @param n_top Number of top variable genes to select (default: 100)
#' @param assay_name Name of assay to use (default: "counts")
#' @param counts_mat Matrix of counts resulting from data_config()
#'
#' @return Matrix of normalized top gene values
#'
#' Export tables of resulting metric data to files
#' @param sce A SingleCellExperiment object
#' @param cell_type Corresponding cell type labels
#' @param km_list List of K Means clustering results with various K values
#' @param selected_k Selected value of K for clustering
#'
#' @return None
#'
#' @export
#'
#' @examples
#' # Assuming 'sce' is a SingleCellExperiment object
#' # Assuming 'counts_mat' is a count matrix resulting from data_config()
#'
#' data_top <- top_x_genes(sce, counts_mat, n_top = 100)

data_config <- function(sce){
  assays(sce) <- list(counts = counts(sce))
  cell_type <- colData(sce)$label
  colData(sce) <- colData(sce)[, "label", drop = FALSE]
  colnames(colData(sce)) <- "cell_type"
  counts_mat <- counts(sce)
  sce <- logNormCounts(sce)

  return(counts_mat)
  return(cell_type)
  return(sce)
}

top_x_genes <- function(sce, counts_mat, n_top = 100, assay_name = "counts"){
  gene_vars <- apply(counts_mat, 1, var) #fetch this from data_config
  top_idx <- order(gene_vars, decreasing = TRUE)[seq_len(2000)]
  mat_norm <- as.matrix(logcounts(sce)[top_idx, ])
  return(mat_norm)
}

export_files <- function(sce, cell_type, km_list, selected_k){
  output_dir <- file.path(tempdir(), "kmeans_output")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  km_sel <- km_list[[as.character(selected_k)]]
  assignments <- data.frame(
    cell_id   = colnames(sce),
    cell_type = cell_type,
    cluster   = km_sel$cluster
  )
  write.table(assignments, file.path(output_dir, "cluster_assignments.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(metrics, file.path(output_dir, "kmeans_metrics.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(evaluation, file.path(output_dir, "cluster_evaluation.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)

  list.files(output_dir)
  }
