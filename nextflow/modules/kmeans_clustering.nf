

process kmeans_clustering {

    input:
    val counts
    val cellmeta
    val genemeta
    val mn
    val mx

    output:
    path '/tests/cli/plots/'

    script:
    
    analysiskmeans elbow -c ${counts} -cm${cellmeta} -gm ${genemeta} -o ${output} -mn 5 -mx 10 
    analysiskmeans cluster -c ${counts} -cm${cellmeta} -gm ${genemeta} -o ${output} -mn 5 -mx 10

    
}