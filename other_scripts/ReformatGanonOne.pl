#!/usr/bin/perl

use strict ;
use warnings ;

die "usage: a.pl ganon.out ganon_seq_map.out > ganon_taxid.out\n" if (@ARGV == 0) ;

my %seqIdMap ;
open FP, $ARGV[1] ;
while (<FP>)
{
  #p_genomes_dustmasker.fna	NZ_CP066370.1	24
  chomp ;
  my @cols = split ;
  $seqIdMap{$cols[1]} = $cols[2] ;
}
close FP ;

open FP, $ARGV[0] ;
while (<FP>)
{
  chomp ;
  my $line = $_ ;
  my @cols = split /\t/, $line ;
  #p_sim_2M.fq.000000000 contig=NC_014029.1 haplotype=0 length=100 orig_begin=2232881 orig_end=2232981 snps=0 indels=0 haplotype_infix=TGATAGCTGCGGCTGCCCCGCCTCCACCTTCGCCACCTTCACCTGCCTCGGCATAATATTTACGTGCGATATTTCGGAATAGCATGCTGTCCCCTTGGGA edit_string=MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMEMMM strand=reverse	1649845	20
  my $readid = (split /\s/, $cols[0])[0] ;
  $readid =~ s/\/1$//g ;
  my $taxId = $cols[1] ;
  $taxId = $seqIdMap{$taxId} if (defined $seqIdMap{$taxId}) ;
  print($readid."\t".$taxId."\t".$cols[1]."\n") ;
}
close FP ;
