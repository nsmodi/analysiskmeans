
#Tests for data_config
test_that("data_config returns correct structure", {
  data(example_sce)
  sce <- example_sce
  results <- data_config(sce)
  counts_mat <- results[1]
  cell_type <- results[2]
  sce <- results[3]
  #expect_type(results, "list")
  expect_named(results, c("counts_mat", "cell_type", "sce"))
  expect_s3_class(results[3], "SingleCellExperiment")
})
