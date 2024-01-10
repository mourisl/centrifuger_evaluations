#!/bin/perl

use strict ;
use warnings ;

die "usage: a.pl art.aln\n" if (@ARGV == 0) ;

sub hd 
{
  return ($_[0] ^ $_[1]) =~ tr/\001-\255//;
}

my $i ;
my $mismatchCnt = 0 ;
my $totalCnt = 0 ;
open FP, $ARGV[0] ;
while (<FP>)
{
  next if (!/^>/) ;

  my $seq = <FP> ;
  my $ref = <FP> ;
  chomp $seq ;
  chomp $ref ;
  my $len = length($seq) ;
  next if ($len != length($ref)) ; # we only calculate hamming distance
  $totalCnt += $len ;
  $mismatchCnt += hd($seq, $ref) ;
}
close FP ;
print("$mismatchCnt\t$totalCnt\n") ;
