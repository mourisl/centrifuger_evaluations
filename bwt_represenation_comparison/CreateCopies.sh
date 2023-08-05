#!/usr/bin/sh

for i in 1 3 6 9 12 15 18 21
do
  yes EcoliK12.fasta | head -n $i | xargs cat | grep -v ">" | tr -d '\n'> ecoli_repeat${i}.fa 
done
