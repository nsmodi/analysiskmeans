#' The Example SingleCellExperiment
#'
#' @format A SingleCellExperiment with:
#' \describe{
#'   \item{assays}{counts - raw count matrix}
#'   \item{colData}{sample_id, treatment (control/treated), batch (A/B)}
#'   \item{rowData}{gene_id, gene_symbol}
#'   \item{reducedDimNames}{0}
#'   \item{mainExpName}{NULL}
#'   \item{altExpNames}{0}
#' }
#'
#' @source Simulated SingleCellExperiment data for teaching purposes
#'
#' @examples
#' library(SingleCellExperiment)
#' data(example_sce)
#' example_sce
#' colData(example_sce)
"example_sce"
