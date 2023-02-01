#!/bin/bash

# File containing the list of SVN repository names
csv_file="svn-og.csv"

while IFS="," read -r repo_name repo_description language; do


#getting authors from each svn file and outputting them in one file
svn log -q http://monaco:9000/svn/"$repo_name"/ | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u >> Allauthors.txt 


done < "$csv_file"


# The name of the input file
input_file="Allauthors.txt" 

# The name of the output file
output_file="Allauthors_unique.txt"

# Get the unique values from the input file
sort $input_file | uniq > $output_file