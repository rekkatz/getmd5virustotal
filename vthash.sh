#!/bin/bash

FILE=$1
API="---API---"
count=0

touch ./result_hash.txt 
echo "Number,SourceHash,VTHits,MD5hash" > ./result_hash.txt

echo "Processing..."

while IFS= read -r line || [ -n "$line" ]; do

	let count=count+1
	var=$(curl -s -X POST 'https://www.virustotal.com/vtapi/v2/file/report' --form apikey="$API" --form resource="$line" | awk -F'positives\":' '{print $2}' | awk -F' ' '{print $1$5}' | sed 's/["}]//g')

	if [ -z "$var" ]; then
		echo "$count,$line,NULL,NULL" >> ./result_hash.txt
		echo "Hash $count - Not Found!"
	else
		echo "$count,$line,$var" >> ./result_hash.txt
		echo "Hash $count - OK!"
	fi

	sleep 15
done < $FILE