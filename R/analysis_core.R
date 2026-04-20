library(SingleCellExperiment)
library(scRNAseq)
library(scuttle)
library(cluster)
library(ggplot2)
# --- Load data ---
sce <- scRNAseq::BaronPancreasData("human")
counts_mat <- counts(sce)
cell_type <- colData(sce)$label
# ============================================================================
# Everything above is upstream data preparation — belongs in data-raw/.
# Everything below is core analysis — should be functionized in R/.
# ============================================================================
# --- Log-normalize using scuttle ---
sce <- logNormCounts(sce)
# --- Feature selection: top 2000 most variable genes ---
gene_vars <- apply(counts_mat, 1, var)
top_idx <- order(gene_vars, decreasing = TRUE)[seq_len(2000)]
mat_norm <- as.matrix(logcounts(sce)[top_idx, ])
# --- PCA ---
pca <- prcomp(t(mat_norm), scale. = TRUE, center = TRUE)
pca_mat <- pca$x[, 1:20]
# --- K-means across k = 5..20 ---
min_k <- 5
max_k <- 20
n_starts <- 25
set.seed(42)
metrics <- data.frame(k = min_k:max_k, wss = NA_real_, avg_silhouette = NA_real_)
km_list <- list()
for (k in min_k:max_k) {
  km <- kmeans(pca_mat, centers = k, nstart = n_starts)
  km_list[[as.character(k)]] <- km
  metrics$wss[k - min_k + 1] <- km$tot.withinss
  sil <- silhouette(km$cluster, dist(pca_mat))
  metrics$avg_silhouette[k - min_k + 1] <- mean(sil[, "sil_width"])
}
# --- Gap statistic ---
gap_stat <- clusGap(pca_mat, FUN = kmeans, nstart = n_starts,
                    K.max = max_k, B = 20)
gap_tab <- as.data.frame(gap_stat$Tab)
metrics$gap <- gap_tab$gap[min_k:max_k]
metrics$gap_se <- gap_tab$SE.sim[min_k:max_k]
# --- Adjusted Rand Index vs known cell types ---
evaluation <- data.frame(k = min_k:max_k, ari = NA_real_)
for (k in min_k:max_k) {
  pred <- km_list[[as.character(k)]]$cluster
  tab <- table(cell_type, pred)
  n <- sum(tab)
  sum_comb <- function(x) x * (x - 1) / 2
  sum_rows <- sum(sum_comb(rowSums(tab)))
  sum_cols <- sum(sum_comb(colSums(tab)))
  sum_all  <- sum(sum_comb(tab))
  expected <- sum_rows * sum_cols / sum_comb(n)
  max_index <- (sum_rows + sum_cols) / 2
  ari <- if (max_index == expected) 0 else (sum_all - expected) / (max_index - expected)
  evaluation$ari[k - min_k + 1] <- ari
}
# --- Elbow plot ---
p_elbow <- ggplot(metrics, aes(x = k, y = wss)) +
  geom_line() + geom_point(size = 2) +
  theme_bw(base_size = 14) +
  labs(x = "Number of Clusters (k)",
       y = "Total Within-Cluster Sum of Squares",
       title = "Elbow Plot")
print(p_elbow)
# --- Cluster scatter for selected k ---
selected_k <- 14
km_sel <- km_list[[as.character(selected_k)]]
scatter_df <- data.frame(
  PC1 = pca$x[, 1], PC2 = pca$x[, 2],
  cluster   = factor(km_sel$cluster),
  cell_type = cell_type
)
p_scatter <- ggplot(scatter_df, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 0.6, alpha = 0.6) +
  theme_bw(base_size = 14) +
  labs(title = paste0("K-means (k=", selected_k, ") on PCA"))
print(p_scatter)


# --- Export ---
output_dir <- file.path(tempdir(), "kmeans_output")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

assignments <- data.frame(
  cell_id   = colnames(sce),
  cell_type = cell_type,
  cluster   = km_sel$cluster
)
write.table(assignments, file.path(output_dir, "cluster_assignments.tsv"),
            sep = "\t", row.names = FALSE, quote = FALSE)
write.table(metrics, file.path(output_dir, "kmeans_metrics.tsv"),
            sep = "\t", row.names = FALSE, quote = FALSE)
write.table(evaluation, file.path(output_dir, "cluster_evaluation.tsv"),
            sep = "\t", row.names = FALSE, quote = FALSE)

list.files(output_dir)
