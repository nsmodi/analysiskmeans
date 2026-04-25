# Compute Gap Statistic for each K

Compute Gap Statistic for each K

## Usage

``` r
gap_statistic(pca, n_starts = 25, max_k, metrics)
```

## Arguments

- pca:

  PCA matrix

- n_starts:

  Number of initial sets

- max_k:

  The max amount k value you wish to go up to

- metrics:

  List of silhouette scores

## Value

Table of Gap statistic values for each K starting at a minimum set of 5

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
outputs <- k_means(5, 9, n_starts = 25, seed = 42, pca)
gap_statistic(pca, n_starts=25, 9, outputs$metrics)
#>       logW   E.logW          gap     SE.sim
#> 1 3.856946 3.936114  0.079167222 0.04078358
#> 2 3.772539 3.802685  0.030145701 0.04182158
#> 3 3.688131 3.697286  0.009155754 0.04347637
#> 4 3.611720 3.597200 -0.014519442 0.04656626
#> 5 3.533081 3.498033 -0.035047899 0.04918973
#> 6 3.446830 3.397636 -0.049194442 0.05228922
#> 7 3.360925 3.296461 -0.064463407 0.05450298
#> 8 3.267450 3.192973 -0.074477066 0.05692509
#> 9 3.164604 3.084985 -0.079619581 0.05893235
```
