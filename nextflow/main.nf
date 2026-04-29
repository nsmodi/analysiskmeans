#!/usr/bin/env nextflow

// Pasted from:
// https://github.com/nextflow-io/training/blob/master/nextflow-run/1-hello.nf


// Student: these should be adjusted based on how your Rapp command-line interface accepts inputs
params.counts = '/tests/cli/counts_df.csv'  // pass your file with: nextflow run main.nf -counts ../r-package/tests/testdata/counts.tsv
params.cellmeta = '/tests/cli/cellmeta_df.csv' // -cm
params.genemeta = '/tests/cli/genemeta_df.csv' // -gm
param.output = '/tests/cli/plots/' // -o
param.min = 5 // -mn
param.max = 10 // -mx

include {analysiskmeans} from "./modules/analysiskmeans.nf"

workflow {
    main:
        // Student: you may need to adjust the following line based on the params (input argument) you have above
        ch_counts = channel.fromPath(params.counts, checkIfExists: true)
        ch_cellmeta = channel.fromPath(params.cellmeta, checkIfExists: true)
        ch_genemeta = channel.fromPath(params.genemeta, checkIfExists: true)
        analysiskmeans(ch_counts, cellmeta_counts, genemeta_counts)


        // Student: if "your_package" needs more than one inputs, e.g., counts + metadata instead of just counts, you would do
        // ch_counts  = channel.fromPath(params.counts, checkIfExists: true)
        // ch_meta    = channel.fromPath(params.metadata, checkIfExists: true)
        // your_package(ch_counts, ch_meta)


    publish:
        results = analysiskmeans.out
}

output {
    results {
        path './results'
        mode 'copy'
    }
}