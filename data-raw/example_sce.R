## code to prepare `example_sce` dataset goes here
library(SummarizedExperiment)
library(SingleCellExperiment)

#Example taken from https://inbre.ncgr.org/single-cell-workshop/bioconductor-singlecellexperiment.html documentation
#I will customize this later I just want to see if it will work first
set.seed(42)
num_genes <- 12
num_cells <- 8
raw_counts <- as.integer(rexp(num_genes*num_cells, rate = 0.5))
raw_counts <- matrix(raw_counts, nrow = num_genes, ncol = num_cells)


#---
gene_metadata <- data.frame(
  name = paste("Gene", 1:num_genes, sep = "_"),
  length = as.integer(rnorm(num_genes, mean = 10000, sd = 500))
)
cell_metadata <- data.frame(
  name = paste("Cell", 1:num_cells, sep = "_"),
  batch = rep(1:2, each = num_cells/2),
  tissue = rep(c("xylem", "phloem"), times = num_cells/2)
)

example_sce <- SingleCellExperiment(
  assays = list(counts = raw_counts), # wrap in a list
  rowData = gene_metadata,
  colData = cell_metadata,
  metadata = list(name = "Fake SCE")
)

usethis::use_data(example_sce, overwrite = TRUE)

