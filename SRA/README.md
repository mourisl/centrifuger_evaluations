## Procedures to evaluate WGS samples downloaded from SRA (species-in, species-not-in, SARS-CoV-2 projects)
### Extract samples for species-in and species-no-in samples
1. Download the SraRunInfo by the sampels from the key word "Bacteria"[Organism] OR "Bacteria Latreille et al. 1825"[Organism]) AND ("2022/01/01"[MDAT] : "2023/08/01"[MDAT]) AND ("biomol dna"[Properties] AND "strategy wgs"[Properties] AND "platform illumina"[Properties] AND "filetype fastq"[Properties])"

2. Randomly shuffle the sra table
```
shuf --random-source Bacteria_SraRunInfo.csv Bacteria_SraRunInfo.csv | grep -v "^Run," > Bacteria_SraRunInfo_shuf.csv
```

3. Get the effective nodes that has sequences
```
centrifuger-inspect --conversion-table -x cfr_p > cfr_p_nodes.dmp
```

4. Extract samples
```
perl SelectSra.pl Bacteria_SraRunInfo_shuf.csv nodes.dmp cfr_p_nodes.dmp 100 1 > speciesin_sra.list
perl SelectSra.pl Bacteria_SraRunInfo_shuf.csv nodes.dmp cfr_p_nodes.dmp 100 0 > speciesnotin_sra.list
```

### Evaluate
```
perl ../EvaluateSra.pl $level $sralist cfr/cfr_ > eval.tsv
```
