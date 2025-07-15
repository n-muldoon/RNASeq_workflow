#!/usr/bin/env python

#input: list of all the verse files
#ouptut 'counts_matrix.txt'
import argparse

# here we are initializing the argparse object that we will modify
parser = argparse.ArgumentParser()

parser.add_argument("-i", "--input", nargs='+', help='a exon.txt file', dest="input", required=True)
parser.add_argument("-o", "--output", help='Output cv', dest="output", required=True)

# this method will run the parser and input the data into the namespace object
args = parser.parse_args()

# you can access the values on the command line by using `args.input` or 'args.output`

import random
import re
import pandas as pd
import os

#input: [/projectnb/bf528/students/amuldoon/project-1-n-muldoon/work/da/d7cb484d04b530039678d7d0b8d1dd/exp_rep3.exon.txt, 
# /projectnb/bf528/students/amuldoon/project-1-n-muldoon/work/07/f6c90d3a871ba5356c9f5776f2d51c/control_rep1.exon.txt, 
# /projectnb/bf528/students/amuldoon/project-1-n-muldoon/work/b8/66630429a3cf639d122663e894a468/control_rep2.exon.txt, 
# /projectnb/bf528/students/amuldoon/project-1-n-muldoon/work/3e/2ae7809e956e4f93efdb25ab45c3a9/control_rep3.exon.txt, 
# /projectnb/bf528/students/amuldoon/project-1-n-muldoon/work/76/233bacca8a1db2c9aed5e66e22f68f/exp_rep1.exon.txt, 
# /projectnb/bf528/students/amuldoon/project-1-n-muldoon/work/0d/2cb3e1766e31a783203c7d16a2036e/exp_rep2.exon.txt]

samples=[]
samples.append('genes')
dfs=[]
name=r'^([^.]+)'
for file in args.input:
    file=file.replace('[','').replace(']','').replace(',','')
    sample_name = os.path.basename(file)
    sample=re.search(name,sample_name)
    samples.append(sample[1])
    df = pd.read_csv(file, sep='\t', index_col=0)
    df.columns=[sample[1]]
    dfs.append(df)
combined_matrix = pd.concat(dfs, axis=1)

# Fill any missing values with 0
combined_matrix.fillna(0, inplace=True)

# Write to output file
combined_matrix.to_csv(args.output, sep=',')

#input: list of files

# 1. Write a python script that will concatenate all of the verse output files and
# write a single counts matrix containing all of your samples. As with any
# external script, make it executable with a proper shebang line and use argparse
# to allow the incorporation of command line arguments. I suggest you use `pandas`
# for this task and you can use the pandas container `ghcr.io/bf528/pandas:latest`.
# The input files are sample.exon.txt format

#first rrow gene d, 6 values: counts for reach file
#need header

#row foor each sample, corresponding counts
#~63,242 genes or rows
