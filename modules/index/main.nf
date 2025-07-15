#!/usr/bin/env nextflow

process INDEX {
    label 'process_high'
    //conda 'envs/biopython_env.yml'
    container 'ghcr.io/bf528/star:latest'
    
    input:
    path genome
    path gtf

    output:
    path "star", emit: index

    shell:
    """
    mkdir star
    STAR --runThreadN $task.cpus --runMode genomeGenerate --genomeDir star --genomeFastaFiles $genome --sjdbGTFfile $gtf
    """
    
    //echo $genome
    //echo $gtf
}
