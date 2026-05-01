#!/usr/bin/env nextflow

// Pasted from:
// https://github.com/nextflow-io/training/blob/master/nextflow-run/1-hello.nf


// Student: these should be adjusted based on how your Rapp command-line interface accepts inputs
params.counts = 'cli/counts_df.csv'  // pass your file with: nextflow run main.nf -counts ../r-package/tests/testdata/counts.tsv
params.cellmeta = 'cli/cellmeta_df.csv' // -cm
params.genemeta = 'cli/genemeta_df.csv' // -gm
params.output = 'results' // -o
params.min = 5 // -mn
params.max = 10 // -mx
params.sk = 8 // Needed for clustering and elbow inputs

include { kmeans_elbow; kmeans_clustering } from "./modules/kmeans_clustering.nf"

workflow {
    
        // Student: you may need to adjust the following line based on the params (input argument) you have above
        ch_counts = Channel.fromPath(params.counts, checkIfExists: true)
        ch_cellmeta = Channel.fromPath(params.cellmeta, checkIfExists: true)
        ch_genemeta = Channel.fromPath(params.genemeta, checkIfExists: true)
        kmeans_elbow(ch_counts, ch_cellmeta, ch_genemeta, params.min, params.max)
        kmeans_clustering(ch_counts, ch_cellmeta, ch_genemeta, params.min, params.max, params.sk)


        // Student: if "your_package" needs more than one inputs, e.g., counts + metadata instead of just counts, you would do
        // ch_counts  = channel.fromPath(params.counts, checkIfExists: true)
        // ch_meta    = channel.fromPath(params.metadata, checkIfExists: true)
        // your_package(ch_counts, ch_meta)


}

