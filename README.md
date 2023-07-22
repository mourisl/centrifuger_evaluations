## Running commands
### Build index
Kraken2:
```
kraken2-build --download-taxonomy --db kraken_db
kraken2-build --add-to-library cat_genomes.fa --db kraken_db
kraken2-build --threads 8 --build --db kraken_db
```
