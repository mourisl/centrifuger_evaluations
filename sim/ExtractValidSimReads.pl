#!/bin/perl

use strict ;
use warnings ;

die "usage: a.pl mason_read.fq conversion_table nodes.dmp num_reads\n" if (@ARGV == 0) ;

my $n = $ARGV[3] ;

my %conversion ;
open FP, $ARGV[1] ;
while (<FP>)
{
  chomp ;
  my @cols = split ;
  $conversion{$cols[0]} = $cols[1] ;
}
close FP ;

my %taxIds ;
open FP, $ARGV[2] ;
while (<FP>)
{
  chomp ;
  my @cols = split ;
  $taxIds{$cols[0]} = $cols[2] ;
}
close FP ;

my $header ;
my $seq ;
my $separator ;
my $qual ;
my $count = 0 ;
open FP, $ARGV[0] ;
while (<FP>)
{
  $header = $_ ;
  $seq = <FP> ;
  $separator = <FP> ;
  $qual = <FP> ;

  chomp $header ;
  $header = substr($header, 1) ;
  my @cols = split /\s/, $header ;
  my @contigCols = split /=/, $cols[1] ;
  if (defined $conversion{$contigCols[1]}
     && defined $taxIds{ $conversion{$contigCols[1]} })
   {
     print "$header\n$seq$separator$qual" ;
     ++$count ;
     last if ($count >= $n) ;
   }
}
close FP ;
