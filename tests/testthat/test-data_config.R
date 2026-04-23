
#Tests for data_config
test_that("data_config returns correct structure", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  expect_type(results, "list")
  expect_named(results, c("counts_mat", "cell_type", "sce"))
  expect_s4_class(results$sce, "SingleCellExperiment")
  expect_no_warning(results)
  expect_no_message(results)
})
#Tests for top_x_gene
test_that("top_x_genes returns correct structure", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  results <- top_x_genes(sce)
  expect_type(results, "double")
  expect_no_warning(results)
  expect_no_message(results)
})
#Test for top_x_genes with manual n_top()
test_that("top_x_genes returns correct structure with manual n_top", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- data_config(sce)
  sce <- results$sce
  results <- top_x_genes(sce, n_top = 50)
  expect_type(results, "double")
  expect_no_warning(results)
  expect_no_message(results)
})




