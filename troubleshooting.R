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
cell_type <- unlist(results$cell_type)
km_list <- outputs$km_list
selected_k <- 8
metrics <- outputs$metrics
evaluation <- evalmetrics
#---
output_dir <- file.path(getwd(), "kmeans_output")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
km_sel <- km_list[[as.character(selected_k)]]
assignments <- data.frame(
  cell_id   = colnames(colData(sce)),
  cell_type = cell_type,
  cluster   = km_sel$cluster
)
utils::write.table(assignments, file.path(output_dir, "cluster_assignments.tsv"),
                   sep = "\t", row.names = FALSE, quote = FALSE)
utils::write.table(metrics, file.path(output_dir, "kmeans_metrics.tsv"),
                   sep = "\t", row.names = FALSE, quote = FALSE)
utils::write.table(evaluation, file.path(output_dir, "cluster_evaluation.tsv"),
                   sep = "\t", row.names = FALSE, quote = FALSE)

list.files(output_dir)
#---

expect_true(file.exists(paste(c(getwd(), "/kmeans_output", "/cluster_assignments.tsv"), collapse = "")))
expect_true(file.exists(paste(c(getwd(), "/kmeans_output", "/kmeans_metrics.tsv"), collapse = "")))
expect_true(file.exists(paste(c(getwd(), "/kmeans_output", "/cluster_evaluation.tsv"), collapse = "")))
