#!/bin/perl

use strict ;
use warnings ;

die "usage: a.pl art_read.fq conversion_table nodes.dmp num_reads art_read_shuf_header.list\n" if (@ARGV == 0) ;

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

my $count = 0 ;
my %selectedRead ;
open FP, $ARGV[4] ;
while (<FP>)
{
  my $header = $_ ;
  chomp $header ;
  $header = substr($header, 1) ;
  $header =~ s/\/[12]$//g ;
  my $seqId = (split /-/, $header)[0] ; 
  if (defined $conversion{$seqId}
     && defined $taxIds{ $conversion{$seqId} })
   {
     $selectedRead{$header} = 1 ;
     ++$count ;
     last if ($count >= $n) ;
   }
}
close FP ;

my $header ;
my $seq ;
my $separator ;
my $qual ;
open FP, $ARGV[0] ;
while (<FP>)
{
  $header = $_ ;
  $seq = <FP> ;
  $separator = <FP> ;
  $qual = <FP> ;

  chomp $header ;
  $header = substr($header, 1) ;
  $header =~ s/\/[12]$//g ;
  #@NC_002607.1-60/1
  if (defined $selectedRead{$header})
  {
    print "@"."$header\n$seq$separator$qual" ;
  }
}
close FP ;
