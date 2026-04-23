#Test gap_statistic function
test_that("gap_statistic has proper tabular structure ", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  mat_norm <- top_x_genes(sce, n_top = 50)
  pca <- computepca(mat_norm)
  max_k <- 10
  outputs <- k_means(min_k = 5, max_k=max_k, pca = pca)
  gap_table <- gap_statistic(pca, 25, max_k, outputs$metrics)
  expect_type(gap_table, "list")
  expect_s3_class(gap_table, "data.frame")
  expect_no_warning(gap_table)
  expect_no_message(gap_table)
})
#Test for the evaluation() function
test_that("evaluation has proper tabular structure ", {
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
  expect_type(evalmetrics, "list")
  expect_s3_class(evalmetrics, "data.frame")
  expect_no_warning(evalmetrics)
  expect_no_message(evalmetrics)
})
