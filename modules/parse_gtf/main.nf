#!/usr/bin/env nextflow

process PARSE_GTF {
    label 'process_single'
    conda 'envs/biopython_env.yml'
    container 'ghcr.io/bf528/biopython:latest'
    publishDir params.outdir

    input:
    path (gtf)

    output:
    path "id2name.txt", emit: id2name
    
    shell:
    """
    gtf_parse.py -i $gtf -o id2name.txt
    """
}
