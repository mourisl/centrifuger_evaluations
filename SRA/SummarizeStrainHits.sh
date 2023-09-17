#/usr/bin/sh

# Usage: sh a.sh > sra_summary.tsv

for s in `cat sra.list | cut -f1`
do
  #echo $s
  awk -F"\t" '$3==2697049' cfr/cfr_${s}.tsv | cut -f2 | tr " " "_" | sort | uniq -c | awk -v sra=$s '{print sra"\t"$2"\t"$1}'
done
