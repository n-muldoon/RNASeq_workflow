#!/usr/bin/env nextflow

process CONCAT {
    label 'process_low'
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir

    input:
    path(verse)

    output:
    path('counts_matrix.csv'),emit:concat

    shell:
    """
    concat_verse.py -i $verse -o counts_matrix.csv
    """
}
