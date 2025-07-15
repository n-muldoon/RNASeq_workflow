#!/usr/bin/env nextflow

process VERSE {
    label 'process_low'
    //conda 'envs/biopython_env.yml'
    container 'ghcr.io/bf528/verse:latest'
    
    input:
    path(gtf)
    tuple val(name), path(bam)
    
    //tuple val(name), path(read1),path(read2)

    output:
    path('*exon.txt'), emit: counts
    //output.summary.exono.txt will still be created, just wono't be part of the channel output

    shell:
    """
    verse -S -a $gtf -o $name $bam
    """
    //./verse [options] -a <annotation_file> -o <output_file> input_file
    //took out readFilesCommand b/c already unzipped reads
    //echo $genome
    //echo $gtf
}
