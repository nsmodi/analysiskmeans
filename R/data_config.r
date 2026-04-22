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
#' @export
#'


data_config <- function(sce){
  SummarizedExperiment::assays(sce) <- list(counts = SingleCellExperiment::counts(sce))
  cell_type <- SummarizedExperiment::colData(sce)$label
  #SummarizedExperiment::colData(sce) <- SummarizedExperiment::colData(sce)[, "label", drop = FALSE]
  colnames(SummarizedExperiment::colData(sce)) <- "cell_type"
  counts_mat <- SingleCellExperiment::counts(sce)
  sce <- scuttle::logNormCounts(sce)

  #return(counts_mat)
  #return(cell_type)
  #return(sce)
  return(list(1=counts_mat, 2=cell_type, 3=sce))
}

#' Select n top variable genes and data configuration
#'
#'
#'
#' @param sce A SingleCellExperiment object
#' @param n_top Number of top variable genes to select (default: 100)
#' @param assay_name Name of assay to use (default: "counts")
#'
#' @return Matrix of normalized top gene values
#' @importFrom SingleCellExperiment counts
#' @importFrom SingleCellExperiment logcounts
#' @importFrom BiocGenerics var
#' @export

#@examples
#' #Assuming 'sce' is a SingleCellExperiment object
#' install.packages("BiocManager")
#' BiocManager::install("airway")
#' library(airway)
#' airway_data <- data(BiocManager::airway)
#' airway_data <- as(airway_data, "SingleCellExperiment")
#'
#' top_genes <- top_x_genes(airway_data, n_top=100)
#'


top_x_genes <- function(sce, n_top = 100, assay_name = "counts"){
  counts_mat <- SingleCellExperiment::counts(sce)
  gene_vars <- apply(counts_mat, 1, BiocGenerics::var) #fetch this from data_config
  top_idx <- order(gene_vars, decreasing = TRUE)[seq_len(2000)]
  mat_norm <- as.matrix(SingleCellExperiment::logcounts(sce)[top_idx, ])
  return(mat_norm)
}

#' Export tables of resulting metric data to files
#' @param sce A SingleCellExperiment object
#' @param cell_type Corresponding cell type labels
#' @param km_list List of K Means clustering results with various K values
#' @param selected_k Selected value of K for clustering
#' @param Metrics Silhouette scores
#' @param evaluation ARI values for each K
#'
#' @return None
#'
#' @export

export_files <- function(sce, cell_type, km_list, selected_k, metrics, evaluation){
  output_dir <- file.path(tempdir(), "kmeans_output")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  km_sel <- km_list[[as.character(selected_k)]]
  assignments <- data.frame(
    cell_id   = colnames(sce),
    cell_type = cell_type,
    cluster   = km_sel$cluster
  )
  utils::write.table(assignments, file.path(output_dir, "cluster_assignments.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  utils::write.table(metrics, file.path(output_dir, "kmeans_metrics.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)
  utils::write.table(evaluation, file.path(output_dir, "cluster_evaluation.tsv"),
              sep = "\t", row.names = FALSE, quote = FALSE)

  list.files(output_dir)
  }
