#Test elbow_plot() function
test_that("elbow_plot has proper structure and no errors ", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  mat_norm <- top_x_genes(sce, n_top = 50)
  pca <- computepca(mat_norm)
  max_k <- 10
  outputs <- k_means(min_k = 5, max_k=max_k, pca = pca)
  metrics<-outputs$metrics
  plot <- elbow_plot(metrics)
  expect_s3_class(plot, "ggplot")
  expect_no_warning(plot)
  expect_no_message(plot)
})
#Test cluster_plot() function
test_that("cluster_plot has proper structure and no errors", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  mat_norm <- top_x_genes(sce, n_top = 50)
  pca <- computepca(mat_norm)
  max_k <- 10
  outputs <- k_means(min_k = 5, max_k=max_k, pca = pca)
  metrics<-outputs$metrics
  km_list <- outputs$km_list
  plot <- cluster_plot(selected_k=8, km_list, pca, results$cell_type)
  expect_s3_class(plot, "ggplot")
  expect_no_warning(plot)
  expect_no_message(plot)
})
