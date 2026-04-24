# Select n top variable genes and data configuration

Select n top variable genes and data configuration

## Usage

``` r
top_x_genes(sce, n_top = 100, assay_name = "counts")
```

## Arguments

- sce:

  A SingleCellExperiment object

- n_top:

  Number of top variable genes to select (default: 100)

- assay_name:

  Name of assay to use (default: "counts")

## Value

Matrix of normalized top gene values

## Examples

``` r
library(analysiskmeans)
data("example_sce")
```
