#!/usr/bin/env Rapp
#| name: analysiskmeans
#| title: analysiskmeans Kmeans Tool
#| description: |
#|  Plot Kmeans Clustering - This is all done with a simple input of a SingleCellExperiment!
#|                    ▄▄
#|                     ██
#|         ▄           ██              ▀▀       ▄▄     ▄                    ▄
#|    ▄▀▀█▄ ████▄ ▄▀▀█▄ ██ ██ ██ ▄██▀█ ██ ▄██▀█ ██ ▄█▀ ███▄███▄ ▄█▀█▄ ▄▀▀█▄ ████▄ ▄██▀█
#|    ▄█▀██ ██ ██ ▄█▀██ ██ ██▄██ ▀███▄ ██ ▀███▄ ████   ██ ██ ██ ██▄█▀ ▄█▀██ ██ ██ ▀███▄
#|   ▄▀█▄██▄██ ▀█▄▀█▄██▄██▄▄▀██▀█▄▄██▀▄███▄▄██▀▄██ ▀█▄▄██ ██ ▀█▄▀█▄▄▄▄▀█▄██▄██ ▀██▄▄██▀
#|                          ██
#|                         ▀▀▀
#|
#| ---
#|

suppressPackageStartupMessages({
  library(analysiskmeans)
  library(utils)
  library(stats)
  library(ggplot2)
  library(SummarizedExperiment)
  library(BiocManager)
  library(SingleCellExperiment)
})

# Helper to read TSV/CSV (not exported; kept in CLI script)
read_data_file <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext == "csv") {
    utils::read.csv(path, row.names = 1, check.names = FALSE)
  } else {
    utils::read.table(path, sep = "\t", header = TRUE, row.names = 1,
                      check.names = FALSE)
  }
}

#---------------------------------
switch(
  "",

  #| title: Creation of elbow plot
  #| description: Create an elbow_plot of a SingleCellExperiment and export results.
  elbow = {
    #| name: counts
    #| type: string
    #| description: Path to counts matrix (TSV/CSV, genes x samples)
    #| short: c
    counts <- ""
    #| name: genemeta
    #| type: string
    #| description: Path to sample gene metadata (TSV/CSV)
    #| short: gm
    genemeta <- ""
    #| name: cellmeta
    #| type: string
    #| description: Path to sample cell metadata (TSV/CSV)
    #| short: cm
    cellmeta <- ""
    #| name: output
    #| type: string
    #| description: Output directory
    #| short: o
    output <- ""
    #| name: n_top
    #| type: integer
    #| description: Number of top variable genes
    #| short: n
    n_top <- 50L
    #| name: min_k
    #| type: integer
    #| description: Minimum K Value
    #| short: mn
    min_k <- 5L
    #| name: max_k
    #| type: integer
    #| description: Number of top variable genes
    #| short: mx
    max_k <- 10L

    # Validation
    if (counts == "" || genemeta == "" || cellmeta == "" || output == "") {
      stop("--counts, --genemeta, --cellmeta and --output are required", call. = FALSE)
    }
    if (!file.exists(counts)) {
      stop("File not found: ", counts, call. = FALSE)
    }
    if (!file.exists(genemeta)) {
      stop("File not found: ", genemeta, call. = FALSE)
    }
    if (!file.exists(cellmeta)) {
      stop("File not found: ", cellmeta, call. = FALSE)
    }

    if (!dir.exists(output)) dir.create(output, recursive = TRUE)

    # Read inputs
    counts_df <- read_data_file(counts)
    genemeta_df <- read_data_file(genemeta)
    cellmeta_df <- read_data_file(cellmeta)


    sce <- SingleCellExperiment(
      assays = list(counts = as.matrix(counts_df)),
      rowData = genemeta_df,
      colData = cellmeta_df
    )


    results <- data_config(sce)
    sce <- results$sce
    mat_norm <- top_x_genes(sce, n_top = n_top)
    pca <- computepca(mat_norm)
    max_k <- max_k
    min_k <- min_k
    outputs <- k_means(min_k = min_k, max_k=max_k, pca = pca)
    metrics<-outputs$metrics
    grDevices::png(paste(getwd(),"/tests/cli/plots/elbowplot.png", sep = ""), width = 8, height = 6, units = "in", res = 300)
    analysiskmeans::elbow_plot(metrics)


    message("Done! Congrats, you have successfully used this package!")
  },

  #| title: Creation of cluster plot
  #| description: Create a cluster plot of Kmeans Clustering with a SingleCellExperiment and export results.
  cluster = {
    #| name: counts
    #| type: string
    #| description: Path to counts matrix (TSV/CSV, genes x samples)
    #| short: c
    counts <- ""
    #| name: genemeta
    #| type: string
    #| description: Path to sample gene metadata (TSV/CSV)
    #| short: gm
    genemeta <- ""
    #| name: cellmeta
    #| type: string
    #| description: Path to sample cell metadata (TSV/CSV)
    #| short: cm
    cellmeta <- ""
    #| name: output
    #| type: string
    #| description: Output directory
    #| short: o
    output <- ""
    #| name: n_top
    #| type: integer
    #| description: Number of top variable genes
    #| short: n
    n_top <- 50L
    #| name: min_k
    #| type: integer
    #| description: Minimum K Value
    #| short: mn
    min_k <- 5L
    #| name: max_k
    #| type: integer
    #| description: Number of top variable genes
    #| short: mx
    max_k <- 10L
    #| name: selected_k
    #| type: integer
    #| description: A Selected K Value for Plotting
    #| short: sk
    selected_k <- 7L

    # Validation
    if (counts == "" || genemeta == "" || cellmeta == "" || output == "") {
      stop("--counts, --genemeta, --cellmeta and --output are required", call. = FALSE)
    }
    if (!file.exists(counts)) {
      stop("File not found: ", counts, call. = FALSE)
    }
    if (!file.exists(genemeta)) {
      stop("File not found: ", genemeta, call. = FALSE)
    }
    if (!file.exists(cellmeta)) {
      stop("File not found: ", cellmeta, call. = FALSE)
    }

    if (!dir.exists(output)) dir.create(output, recursive = TRUE)

    # Read inputs
    counts_df <- read_data_file(counts)
    genemeta_df <- read_data_file(genemeta)
    cellmeta_df <- read_data_file(cellmeta)


    sce <- SingleCellExperiment(
      assays = list(counts = as.matrix(counts_df)),
      rowData = genemeta_df,
      colData = cellmeta_df
    )


    results <- data_config(sce)
    sce <- results$sce
    mat_norm <- top_x_genes(sce, n_top = n_top)
    pca <- computepca(mat_norm)
    max_k <- max_k
    min_k <- min_k
    outputs <- k_means(min_k = min_k, max_k=max_k, pca = pca)
    metrics<-outputs$metrics
    metrics<-outputs$metrics
    km_list <- outputs$km_list
    grDevices::png(paste(getwd(),"/tests/cli/plots/clusterplot.png", sep = ""), width = 8, height = 6, units = "in", res = 300)
    analysiskmeans::cluster_plot(selected_k=7, km_list, pca, results$cell_type)

    message("Done! Congrats, you have successfully used this package!")
  }
  )


