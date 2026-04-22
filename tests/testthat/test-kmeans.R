#Test for computepca
test_that("computepca returns correct structure and type", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- analysiskmeans::data_config(sce)
  sce <- results$sce
  mat_norm <- analysiskmeans::top_x_genes(sce, n_top = 50)
  pca <- computepca(mat_norm)
  expect_s3_class(pca, "prcomp")
  expect_type(pca, "list")
})
#Test kmeans
test_that("Kmeans returns correct structure with max_k of 10", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- analysiskmeans::data_config(sce)
  sce <- results$sce
  mat_norm <- analysiskmeans::top_x_genes(sce, n_top = 50)
  pca <- analysiskmeans::computepca(mat_norm)
  outputs <- analysiskmeans::k_means(10, pca=pca)
  expect_type(outputs$metrics, "list")
  expect_type(outputs$km_list, "list")

})
