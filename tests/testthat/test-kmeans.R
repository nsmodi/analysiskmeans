#Test for computepca
test_that("computepca returns correct structure and type", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  mat_norm <- top_x_genes(sce)
  pca <- computepca(mat_norm)
  expect_s3_class(pca, "prcomp")
  expect_type(pca, "list")
  expect_no_warning(pca)
  expect_no_message(pca)
})
#Test kmeans
test_that("Kmeans returns correct structure with max_k of ", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  mat_norm <- top_x_genes(sce, n_top = 50)
  pca <- computepca(mat_norm)
  outputs <- k_means(min_k = 5, max_k=10, pca = pca)
  expect_type(outputs$metrics, "list")
  expect_type(outputs$km_list, "list")
  expect_no_warning(outputs)
  expect_no_message(outputs)
})
