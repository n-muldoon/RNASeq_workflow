#!/usr/bin/env python

# gtf file: all areas of enome
# want ensembl human gene ids and names

# argparse is a library that allows you to make user-friendly command line interfaces
import argparse

# here we are initializing the argparse object that we will modify
parser = argparse.ArgumentParser()

# we are asking argparse to require a -i or --input flag on the command line when this
# script is invoked. It will store it in the "filenames" attribute of the object
# we will be passing it via snakemake, a list of all the outputs of verse so we can
# concatenate them into a single matrix using pandas 

parser.add_argument("-i", "--input", help='a GFF file', dest="input", required=True)
parser.add_argument("-o", "--output", help='Output file with region', dest="output", required=True)

# this method will run the parser and input the data into the namespace object
args = parser.parse_args()

# you can access the values on the command line by using `args.input` or 'args.output`

import random
import re
# make gene name variable with regex
# make gene id  variable with regex
geneid = r'gene_id\s([^;]*)'
genename=r'gene_name\s([^;]*)'
#stick in diictionary
geneid_to_name={}
#writes out file from dictionary


entries = []
with open(args.input, 'rt') as f:
    for line in f:
        if line.startswith('#'):
            continue
        gene_name=re.search(genename,line)
        gene_id=re.search(geneid,line)

        if gene_id and gene_name:
            gene_id_value = gene_id.group().split('"')[1]
            gene_name_value = gene_name.group().split('"')[1]
            if gene_id_value in geneid_to_name:
                continue
            else:
                geneid_to_name[gene_id_value] = gene_name_value

print("adding to dictionary done correctly")

with open(args.output, 'w') as w:
    for gene_name, gene_id in geneid_to_name.items():
        w.write('{}\t{}\n'.format(gene_name,gene_id))


