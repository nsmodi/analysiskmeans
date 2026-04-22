
#Tests for data_config
test_that("data_config returns correct structure", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- analysiskmeans::data_config(sce)
  expect_type(results, "list")
  expect_named(results, c("counts_mat", "cell_type", "sce"))
  expect_s4_class(results$sce, "SingleCellExperiment")
})
#Tests for top_x_gene
test_that("top_x_genes returns correct structure", {
  utils::data(example_sce, package="analysiskmeans")
  sce <- example_sce
  results <- analysiskmeans::top_x_genes(sce)
  expect_type(results, "matrix")
})


