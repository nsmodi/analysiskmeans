# Export tables of resulting metric data to files

Export tables of resulting metric data to files

## Usage

``` r
export_files(sce, cell_type, km_list, selected_k, metrics, evaluation)
```

## Arguments

- sce:

  A SingleCellExperiment object

- cell_type:

  Corresponding cell type labels

- km_list:

  List of K Means clustering results with various K values

- selected_k:

  Selected value of K for clustering

- metrics:

  Silhouette scores

- evaluation:

  ARI values for each K

## Value

None
