#!/usr/bin/env perl

# Evaluate the SRA samples specified in the sra_list file.
#   assume the second column in the list file is the tax id

use strict ;
use warnings ;

die "Usage: a.pl nodes.dmp rank sra_list output_prefix > prediction.out\n" if (@ARGV == 0) ;

my %taxTree ;
my %taxRank ;
open FP, $ARGV[0] ;
while (<FP>)
{
  chomp ;
  my @cols = split /\s+/, $_ ;  
  $taxTree{$cols[0]} = $cols[2] ;
  $taxRank{$cols[0]} = $cols[4] ;
}
close FP ;

my $targetRank = $ARGV[1] ;
my %sraTax ;
open FP, $ARGV[2] ;
while (<FP>)
{
  chomp ;
  my @cols = split ;
  my $sra = $cols[0] ;
  my $taxId = $cols[1] ;
  if ($targetRank ne "strand")
  {
    while ($taxId != 1 && $taxRank{$taxId} ne $targetRank)
    {
      $taxId = $taxTree{$taxId} ;
    }
  }
  if ($taxId == 1)
  {
    print "WRONG: $sra tax id is not in the tree.\n" ;
  }

  $sraTax{$sra} = $taxId ;
}
close FP ;

# Now start to process each input
my $prefix = $ARGV[3] ;
foreach my $sra (keys %sraTax)
{
  if (-e "$prefix$sra.tsv.gz")
  {
    open FP, "zcat $prefix$sra.tsv.gz |" ;
  }
  else
  {
    open FP, "$prefix$sra.tsv" ;
  }
  my $P = 0;
  my $T = 0 ;
  my $TP = 0 ;
  while (<FP>)
  {
    next if (/^readID/) ;
    chomp ;
    my $line = $_ ;
    my @cols = split /\t/, $line ;
    my $taxId = $cols[2] ;
    
    if ($targetRank ne "strand")
    {
      while ($taxId > 1 && defined $taxRank{$taxId} 
        && $taxRank{$taxId} ne $targetRank)
      {
        $taxId = $taxTree{$taxId} ;
      }
    }

    ++$TP if ($taxId == $sraTax{$sra}) ;
    ++$P if (!($line =~ /^U\t/ || $line =~ /unclassified/)) ;
    ++$T ;
  }
  close FP ;
  # sra rank sensitivity precision
  print "$sra\t$targetRank\t".$TP/$T."\t".$TP/$P."\n" ;
}
