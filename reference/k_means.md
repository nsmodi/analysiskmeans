# Conduct K Means Clustering

Conduct K Means Clustering

## Usage

``` r
k_means(min_k, max_k, n_starts = 25, seed = 42, pca)
```

## Arguments

- max_k:

  The max amount k value you wish to go up to

- n_starts:

  Number of initial sets

- seed:

  Random seed for reproducibility

- pca:

  Resulting PCA matrix

## Value

List Average silhouette scores and of K Means clustering results with
various K values
