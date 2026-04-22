#Test for computepca
test_that("computepca returns correct structure", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- analysiskmeans::data_config(sce)
  sce <- results$sce
  mat_norm <- analysiskmeans::top_x_genes(sce, n_top = 50)
  pca <- computepca(mat_norm)
  expect_s3_class(pca, "prcomp")
  expect_type(pca, "list")
})
