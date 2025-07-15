#!/usr/bin/env nextflow

include { FASTQC } from './modules/fastqc'
include { INDEX } from './modules/index'
include { PARSE_GTF } from './modules/parse_gtf/main.nf'
include { STAR } from './modules/star'
include { MULTIQC } from './modules/multiqc'
include { VERSE } from './modules/verse'
include { CONCAT } from './modules/pandas'
workflow {
    //[sample1, [sample1_R1.fastq.gz, sample1_R2.fastq.gz]]
    Channel.fromFilePairs(params.reads,flat:true) |
    set { align_ch }
    //map { tuple -> tuple(val(tuple[0]), path(tuple[1]), path(tuple[2])) } |
    //map { row -> tuple(row.name, file(row.file),file(row.file)) } |
    //view()
    
    //[sample1, sample1_R2.fastq.gz]
    Channel.fromFilePairs(params.reads) | 
    transpose() | 
    set { fastqc_channel }
    //view()

    //view(params.genome,params.gtf)

    FASTQC(fastqc_channel)
    INDEX(params.genome, params.gtf)
    PARSE_GTF(params.gtf)

    STAR(INDEX.out.index,align_ch)

    //     Use a combination of `map()`, `collect()`, `mix()`, `flatten()` to create a
    // single channel that contains a list with all of the output files from FASTQC and
    // STAR logs for every sample and call it `multiqc_ch`. Remember that you may access
    // the outputs of a previous process by using the `.out()` notation (i.e. ALIGN.out
    // or FASTQC.out.zip).
    //collect(STAR.out.log).view()

    FASTQC.out.zip.map { it -> [ it ] }
    .mix(STAR.out.log)
    .collect()
    .set { multiqc_ch }

    //.flatten()
    //.view()



    //sample1_R1_fastqc.zip, sample1_R2_fastqc.zip, sample1.Log.final.out,
    MULTIQC(multiqc_ch)
    

    //verse
    STAR.out.bam |
    map { filePath -> [ filePath.baseName.replaceAll(/^([^A]+).*$/, '$1'),filePath ] } |
    set { bam_tuple }
    //replaceAll(/^([^_]+).*$/, '$1')
    //(fileName, filePath) = [filePath.baseName, filePath]
    // fileTuples = filePaths.map { filePath -> 
    //     // For each file, extract the file name and use the full file path
    //     [filePath.baseName, filePath]
    
    
    

    //view(params.gtf)

    VERSE(params.gtf,bam_tuple)

    VERSE.out.counts.collect() |//.map{ it[1] }|
    //view()
    set{ counts_ch } 

    //by setting collect(), make sure this process runs & finishes before next noe
    CONCAT(counts_ch)

    //send index to cluster
    //everrything else can be local


}