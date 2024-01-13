#!/bin/perl

use strict ;
use warnings ;

die "usage: a.pl genomes.fa seqid.map nodes.dmp > reheader.fa\n" if (@ARGV == 0) ;

my %seqIdMap ;
open FP, $ARGV[1] ;
while (<FP>)
{
  chomp ;
  my @cols = split ;
  $seqIdMap{$cols[0]} = $cols[1] ;
}
close FP ;

my %nodes ;
open FP, $ARGV[2] ;
while (<FP>)
{
  chomp ;
  my @cols = split ;
  $nodes{$cols[0]} = 1 ;
}
close FP ;

open FP, $ARGV[0] ;
my $cnt = 1 ;
while (<FP>)
{
  if (/^>/)
  {
    chomp ;
    my $seqId = (split /\s/, substr($_, 1))[0]  ;
    if (defined $seqIdMap{$seqId} && 
      defined $nodes{ $seqIdMap{$seqId} })
    {
      #>kraken:taxid|9606|C1|NC_001422.1
      print(">kraken:taxid|".$seqIdMap{$seqId}."|C$cnt|$seqId\n") ;
    }
    else
    {
      print(">kraken:taxid|1|C$cnt|$seqId\n") ;
    }
    ++$cnt ;
  }
  else
  {
    print $_ ;
  }
}
close FP ;
