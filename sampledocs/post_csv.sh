#!/bin/sh

FILES=$*
URL=http://localhost:8983/solr/test/update

for f in $FILES; do
  curl $URL/csv --data-binary @$f -H 'Content-type:application/csv; charset=utf-8'
done 

curl "$URL?softCommit=true"
echo

