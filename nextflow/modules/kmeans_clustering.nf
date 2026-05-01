

process kmeans_elbow{
    container "analysiskmeans:0.0.2"
    publishDir 'results', mode: 'copy'
    input:
    path counts
    path cellmeta
    path genemeta
    val mn
    val mx

    output:
    path 'tests/cli/plots/elbowplot.png'

    script:
    """
    mkdir -p tests/cli/plots/
    /usr/local/bin/analysiskmeans elbow -c ${counts} -cm ${cellmeta} -gm ${genemeta} -o tests/cli/plots/ -mn ${mn} -mx ${mx} 
    """

    
}

process kmeans_clustering {
    container "analysiskmeans:0.0.2"
    publishDir 'results', mode: 'copy'
    input:
    path counts
    path cellmeta
    path genemeta
    val mn
    val mx
    val sk

    output:
    path 'tests/cli/plots/clusterplot.png'

    script:
    """
    mkdir -p tests/cli/plots/
    /usr/local/bin/analysiskmeans cluster -c ${counts} -cm ${cellmeta} -gm ${genemeta} -o tests/cli/plots/ -mn ${mn} -mx ${mx} -sk ${sk}
    """
}