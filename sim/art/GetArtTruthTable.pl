#!/usr/bin/env perl

use strict ;
use warnings ;

# Convert simulated reads to two-column truth table
my $usage = "a.pl art_read_1.fq conversion_table [raw_reference_seq] > truth.out" ;

die "$usage\n" if (@ARGV == 0) ;

my %conversion ;
open FP, $ARGV[1] ;
while (<FP>)
{
  chomp ;
  my @cols = split ;
  $conversion{$cols[0]} = $cols[1] ;
}
close FP ;

my $header ;
my $seq ;
my $tmp ;
my $qual ;
open FP, $ARGV[0] ;
while (<FP>)
{
  $header = $_ ;
  $seq = <FP> ;
  $tmp = <FP> ;
  $qual = <FP> ;

  chomp $header ;
  $header = substr($header, 1) ;
  my @cols = split /-/, $header ;
  print $header, "\t", $conversion{$cols[0]}, "\n" ;
}
close FP ;
