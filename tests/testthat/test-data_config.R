test_that("run_pca returns correct structure", {
  data(example_sce)
  sce <- example_sce

  results <- data_config(sce)
  counts_mat <- results[1]
  cell_type <- results[2]
  sce <- results[3]

  expect_type(results, "list")
  expect_named(results, c("counts_mat", "scores"))
  expect_s3_class(result$pca, "prcomp")
  expect_s3_class(result$scores, "data.frame")
})
