#!/bin/bash
variable=$2
out=$3
filename="$1"

function help
{
	usage
	echo ""
	echo "Reads in the specified parameters from the provided AEM pages and writes them out to a CSV file"
	echo ""
	echo "---Required Parameters---"
	echo "1. The Input file"
	echo "2. The parameters to extract, separated by commas"
	echo "3. The output file"
	echo ""
	echo "---Optional Parameters---"
	echo "-p  - The subpath for extraction, e.g. jcr:content/par"
}

function usage
{
	echo "usage: aem-properties-reader input.txt aem,variable out.csv [-p jcr:content]"
}

echo "Writing to data $out..."
echo "URL,$variable" > $out
while read -r line
do
    echo "Extracting properties from $line..."
    fnd=".html"
    sub="/jcr:content.json"
	variable=$(curl -s ${line/$fnd/$sub} | jq -r '.["cq:template"]')
	echo "$line,$variable" >> $out
done < "$filename"