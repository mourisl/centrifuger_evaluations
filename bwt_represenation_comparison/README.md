### Obtain certain species/genus sequences 
0. Requires the downloaded prokaryotic genomes data(p_genomes.fna); taxonomy tree file (nodes.dm); seqid to taxid map file (p_seqid.map)

1. Get the seq id associated with genus 455. "taxonomy.py" can be found in the script folder in the Centrifuger package.
```
fgrep -w -f <(python3 ./taxonomy.py --op subtree --taxid 455 --tree nodes.dmp) p_seqid.map | cut -d' ' -f1 > genus455_seqid.out
```

2. Get the sequences with those seqids
```
perl ~/Tools/SelectFa.pl genus455_seqid.out < p_genomes.fna > genus455_genomes.fna
```

3. Get non-plasmid sequences
```
paste <(grep ">" genus455_genomes.fna) <(grep -v ">" genus455_genomes.fna) | grep -v plasmid | tr "\t" "\n" > genus455_noplasmid.fa
```
