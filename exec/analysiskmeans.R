#!/usr/bin/env Rapp
#| name: analysiskmeans
#| title: analysiskmeans Kmeans Tool
#| description: Kmeans analysis for SingleCellExperiment data.

suppressPackageStartupMessages({
  library(analysiskmeans)
  library(utils)
  library(stats)
  library(ggplot2)
  library(SummarizedExperiment)
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

  #| title: Create an Elbow Plot
  #| description: Create an elbow_plot on a SingleCellExperiment and export results.
  elbow = {
    #| description: Path to counts matrix (TSV/CSV, genes x samples)
    #| short: c
    counts <- ""

    #| description: Path to sample gene metadata (TSV/CSV)
    #| short: m
    genemeta <- ""

    #| description: Path to sample cell metadata (TSV/CSV)
    #| short: m
    cellmeta <- ""

    #| description: Output directory
    #| short: o
    output <- ""

    #| description: Number of top variable genes
    #| short: n
    n_top <- 50L

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

#    se <- SummarizedExperiment(
#      assays  = list(counts = as.matrix(counts_df)),
#      colData = meta_df
#    )

    sce <- SingleCellExperiment(
      assays = list(counts = as.matrix(counts_df)),
      rowData = genemeta_df,
      colData = cellmeta_df
    )

    #result <- run_pca(se, n_top = n_top, log_transform = log_transform)
    results <- data_config(sce)
    sce <- results$sce
    mat_norm <- top_x_genes(sce, n_top = n_top)
    pca <- computepca(mat_norm)
    max_k <- max_k
    min_k = min_k
    outputs <- k_means(min_k = min_k, max_k=max_k, pca = pca)
    metrics<-outputs$metrics
    output <- elbow_plot(metrics)
    plot_file <- file.path(output, "pca_plot.png")
    png(plot_file, width = 8, height = 6, units = "in", res = 300)
    dev.off()
    message("Saved: ", plot_file)


    #if (color_by != "") {
    #  plot_file <- file.path(output, "pca_plot.png")
    #  p <- plot_pca(result, color_by = color_by)
    #  png(plot_file, width = 8, height = 6, units = "in", res = 300)
    #  print(p)
    #  dev.off()
    #  message("Saved: ", plot_file)
    #}

    message("Done.")
  }
)

