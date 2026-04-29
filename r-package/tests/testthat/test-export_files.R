#Check export_files() function
test_that("top_x_genes returns correct structure with manual n_top", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  mat_norm <- top_x_genes(sce, n_top = 50)
  pca <- computepca(mat_norm)
  max_k <- 10
  min_k <- 5
  outputs <- k_means(min_k=min_k, max_k=max_k, pca = pca)
  evalmetrics <- evaluation_metrics(min_k, max_k, outputs$km_list, results$cell_type)
  export_files(sce, results$cell_type, outputs$km_list, 8, outputs$metrics, evalmetrics)
  expect_true(file.exists(paste(c(getwd(), "/kmeans_output", "/cluster_assignments.tsv"), collapse = "")))
  expect_true(file.exists(paste(c(getwd(), "/kmeans_output", "/kmeans_metrics.tsv"), collapse = "")))
  expect_true(file.exists(paste(c(getwd(), "/kmeans_output", "/cluster_evaluation.tsv"), collapse = "")))
  })
