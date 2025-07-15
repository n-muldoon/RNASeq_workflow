#!/usr/bin/env nextflow

process STAR {
    label 'process_high'
    //conda 'envs/biopython_env.yml'
    container 'ghcr.io/bf528/star:latest'
    
    input:
    path index
    tuple val(name), path(read1),path(read2)
    //tuple val(name), val(path(read1),path(read2))
    //tuple val(name), list(reads)

    output:
    path "*.bam", emit: bam
    path "*.final.out", emit: log

    shell:
    """
    STAR --runThreadN $task.cpus --genomeDir $index --readFilesIn $read1 $read2 --readFilesCommand gunzip -c --outFileNamePrefix $name --outSAMtype BAM SortedByCoordinate
    """
    //
    //took out readFilesCommand b/c already unzipped reads
    //echo $genome
    //echo $gtf
}
