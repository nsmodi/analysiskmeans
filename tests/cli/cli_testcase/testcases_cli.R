#The following is a file to test the CLI for my package
#This shows the testing and performance of my CLI

#First, we can start with testing the Elbow Plot function
##############################################################################
##                                                                          ##
##  ███████╗██╗     ██████╗  ██████╗ ██╗    ██╗                            ##
##  ██╔════╝██║     ██╔══██╗██╔═══██╗██║    ██║                            ##
##  █████╗  ██║     ██████╔╝██║   ██║██║ █╗ ██║                            ##
##  ██╔══╝  ██║     ██╔══██╗██║   ██║██║███╗██║                            ##
##  ███████╗███████╗██████╔╝╚██████╔╝╚███╔███╔╝                            ##
##  ╚══════╝╚══════╝╚═════╝  ╚═════╝  ╚══╝╚══╝                            ##
##                                                                          ##
##  ████████╗███████╗███████╗████████╗                                      ##
##     ██║   ██╔════╝██╔════╝╚══██╔══╝                                      ##
##     ██║   █████╗  ███████╗   ██║                                         ##
##     ██║   ██╔══╝  ╚════██║   ██║                                         ##
##     ██║   ███████╗███████║   ██║                                         ##
##     ╚═╝   ╚══════╝╚══════╝   ╚═╝                                         ##
##                                                                          ##
##############################################################################
#The above banner was generated with Claude
library(SingleCellExperiment)
#read_data_file is a helper function to load in a dataset in a csv/tsv format
read_data_file <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext == "csv") {
    utils::read.csv(path, row.names = 1, check.names = FALSE)
  } else {
    utils::read.table(path, sep = "\t", header = TRUE, row.names = 1,
                      check.names = FALSE)
  }
}

#The following example starts by constructing these input files
set.seed(42)
num_genes <- 100
num_cells <- 20 #Used to be 8
raw_counts <- as.integer(rexp(num_genes*num_cells, rate = 0.1))
raw_counts <- matrix(raw_counts, nrow = num_genes, ncol = num_cells)

gene_metadata <- data.frame(
  name = paste("Gene", 1:num_genes, sep = "_"),
  length = as.integer(rnorm(num_genes, mean = 10000, sd = 500))
)

cell_metadata <- data.frame(
  names = paste("Cell", 1:num_cells, sep = "_"),
  batch = rep(1:2, each = num_cells/2),
  label = rep(c("xylem", "phloem"), times = num_cells/2)
)

#Writing the inputs into files in a tests/cli folder
write.csv(raw_counts, "C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/counts_df.csv", row.names = TRUE)
write.csv(gene_metadata, "C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/genemeta_df.csv", row.names = TRUE)
write.csv(cell_metadata, "C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/cellmeta_df.csv", row.names = TRUE)

#reading the files and beginning the CLI simulation
counts_df <- read_data_file(paste(getwd(),"/tests/cli/counts_df.csv", sep = ""))
genemeta_df <- read_data_file(paste(getwd(),"/tests/cli/genemeta_df.csv", sep = ""))
cellmeta_df <- read_data_file(paste(getwd(),"/tests/cli/cellmeta_df.csv", sep = ""))

#REFERNCE FOR MYSELF DURING TESTING AND MY OWN FILE PATH
#To make a proper local path so everyone can access it (and so I don't have a hardcoded path)

#counts_fp <- paste(getwd(),"/tests/cli/counts_df.csv", sep = "")
#"C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/counts_df.csv"
#genemeta_fp <- paste(getwd(),"/tests/cli/genemeta_df.csv", sep = "")
#"C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/genemeta_df.csv"
#cellmeta_fp <- paste(getwd(),"/tests/cli/cellmeta_df.csv", sep = "")
#"C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/cellmeta_df.csv"
#output_dir <- paste(getwd(),"/tests/cli",sep="")
#"C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli"
#-----------

#Making an sce object with the dataframes from files

sce1 <- SingleCellExperiment(
  assays = list(counts = as.matrix(counts_df)),
  rowData = genemeta_df,
  colData = cellmeta_df
)
#After file fetched object is gotten, running the functions and doing analysis
results <- data_config(sce1)
sce1 <- results$sce
mat_norm <- top_x_genes(sce1, n_top = 50)
pca <- computepca(mat_norm)
max_k <- 10
min_k = 5
outputs <- k_means(min_k = min_k, max_k=max_k, pca = pca)
metrics<-outputs$metrics
grDevices::png(paste(getwd(),"/tests/cli/plots/elbowplot.png", sep = ""), width = 8, height = 6, units = "in", res = 300)
elbow_plot(metrics)
grDevices::dev.off()
message("Saved!")

#My Personal TEST Command is the following:
#analysiskmeans elbow
#-c "C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/counts_df.csv"
#-gm "C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/genemeta_df.csv"
#-cm "C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli/cellmeta_df.csv"
#-o "C:/Users/nmodi/Desktop/SciApps_KNN/analysiskmeans/tests/cli"
#--max_k 10
#--min_k 5

#The output will be a saved plot in the plots folder in tests/cli

#############################################
##                                         ##
##  ██████╗██╗     ██╗   ██╗███████╗████████╗███████╗██████╗ ##
##  ██╔════╝██║    ██║   ██║██╔════╝╚══██╔══╝██╔════╝██╔══██╗##
##  ██║     ██║    ██║   ██║███████╗   ██║   █████╗  ██████╔╝##
##  ██║     ██║    ██║   ██║╚════██║   ██║   ██╔══╝  ██╔══██╗##
##  ╚██████╗███████╗╚██████╔╝███████║   ██║   ███████╗██║  ██║##
##   ╚═════╝╚══════╝ ╚═════╝ ╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝##
##                                         ##
##  ████████╗███████╗███████╗████████╗     ##
##     ██║   ██╔════╝██╔════╝╚══██╔══╝     ##
##     ██║   █████╗  ███████╗   ██║        ##
##     ██║   ██╔══╝  ╚════██║   ██║        ##
##     ██║   ███████╗███████║   ██║        ##
##     ╚═╝   ╚══════╝╚══════╝   ╚═╝        ##
##                                         ##
#############################################
#The above banner was generated with Claude

#Again, we will construct a SCE object with the data we previously imported
sce1 <- SingleCellExperiment(
  assays = list(counts = as.matrix(counts_df)),
  rowData = genemeta_df,
  colData = cellmeta_df
)
#After file fetched object is gotten, running the functions and doing analysis
results <- data_config(sce1)
sce1 <- results$sce
mat_norm <- top_x_genes(sce1, n_top = 50)
pca <- computepca(mat_norm)
max_k <- 10
min_k = 5
outputs <- k_means(min_k = min_k, max_k=max_k, pca = pca)
metrics<-outputs$metrics
km_list <- outputs$km_list
#Save the plot in the proper plots directory
grDevices::png(paste(getwd(),"/tests/cli/plots/clusterplot.png", sep = ""), width = 8, height = 6, units = "in", res = 300)
analysiskmeans::cluster_plot(selected_k=8, km_list, pca, results$cell_type)
grDevices::dev.off()
#Message is successfully prompted!
message("Saved!")
