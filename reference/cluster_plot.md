# Create final scatter plot of kmeans clustering

Create final scatter plot of kmeans clustering

## Usage

``` r
cluster_plot(selected_k, km_list, pca, cell_type)
```

## Arguments

- selected_k:

  Kmeans Value Selected

- km_list:

  List of K Means clustering results with various K values

- pca:

  PCA values dataframe

- cell_type:

  Cell type labels provided

## Value

Resulting Cluster Plot

## Examples

``` r
library(analysiskmeans)
data(example_sce)
SingleCellExperiment::logcounts(example_sce) <- log1p(SingleCellExperiment::counts(example_sce))#Line taken from Claude AI - Debug
sce <- example_sce
results <- data_config(sce)
#> Warning: 'librarySizeFactors' is deprecated.
#> Use 'scrapper::centerSizeFactors' instead.
#> See help("Deprecated")
#> Warning: 'normalizeCounts' is deprecated.
#> Use 'scrapper::normalizeCounts' instead.
#> See help("Deprecated")
mat_norm <- top_x_genes(results$sce, n_top = 50)
pca <- computepca(mat_norm)
outputs <- k_means(4, 9, n_starts = 25, seed = 42, pca)
cluster_plot(7, outputs$km_list, pca, results$cell_type)
```
