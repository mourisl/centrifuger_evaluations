### Obtain certain species/genus sequences 
0. Requires the downloaded procaryotic genomes data(p_genomes.fna); taxonomy tree file (nodes.dm); seqid to taxid map file (p_seqid.map)

1. Get the seq id associated with genus 586
```
fgrep -w -f <(python3 ./taxonomy.py --op subtree --taxid 586 --tree nodes.dmp) p_seqid.map | cut -d' ' -f1 > genus586_seqid.out
```

2. Get the sequences with those seqids
```
perl ~/Tools/SelectFa.pl genus586_seqid.out < p_genomes.fna > genus586_genomes.fna
```

3. Get non-plasmid sequences
```
paste <(grep ">" genus586_genomes.fna) <(grep -v ">" genus586_genomes.fna) | grep -v plasmid | tr "\t" "\n" > genus586_noplasmid.fa
```
