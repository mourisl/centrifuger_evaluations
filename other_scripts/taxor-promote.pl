#!/usr/bin/env perl

use strict ;
use warnings ;


die "Usage: taxor-promote taxor_seq_id.map nodes.dmp  < taxor_class.out > taxor_3c.output\n" if ( @ARGV == 0 ) ;

# file name to tax id
open FP, $ARGV[0] ;
my %seqIdToTaxId ;
while (<FP>)
{
  # GCA_009858895.3 694009  https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/009/858/895/GCA_009858895.3_ASM985889v3    k__Viruses;p__Pisuviricota;c__Pisoniviricetes;o__Nidovirales;f__Coronaviridae;g__Betacoronavirus;s__Severe acute respiratory syndrome-related coronavirus 10239;2732408;2732506;76804;11118;694002;694009
  chomp ;
  my @cols = split ;
  $seqIdToTaxId{$cols[0]} = $cols[1] ;
}
close FP ;

open FP, $ARGV[1] ;
my %taxParent ;
while (<FP>)
{
  chomp ;
  my @cols = split ;
  $taxParent{$cols[0]} = $cols[2] ;
}
close FP ;

sub lca 
{
  my ($a, $b) = @_;
  return $b if $a eq 0;
  return $a if $b eq 0;
  return $a if $a eq $b;
  my %a_path;
  while ($a ge 1) 
  {
    $a_path{$a} = 1;
    if (!defined $taxParent{$a}) {
      #print STDERR "Couldn't find parent of taxID $a - directly assigned to root.\n";
      last;
    }
    last if $a eq $taxParent{$a};
    $a = $taxParent{$a};
  }

  while ($b > 1) 
  {
    return $b if (defined $a_path{$b});
    if (!defined $taxParent{$b}) {
      #print STDERR "Couldn't find parent of taxID $b - directly assigned to root.\n";
      last;
    }
    last if $b eq $taxParent{$b};
    $b = $taxParent{$b};
  }
  return 1;
}

sub OutputPromotedLines
{
  # ERR7616152.2 2 length=1433  GCA_011537355.1   694009  29882 1433  1414  564 k__Viruses;p__Pisuviricota;c__Pisoniviricetes;o__Nidovirales;f__Coronaviridae;g__Betacoronavirus;s__Severe acute respiratory syndrome-related coronavirus 10239;2732408;2732506;76804;11118;694002;694009
  my @lines = @{ $_[0] } ;
  return if ( scalar( @lines ) <= 0 ) ;

  my @newLines ;
  my $i ;
  my $numMatches = 0 ;
  my %showedUpTaxId ;
  my $tab = sprintf( "\t" ) ;

  $numMatches = 1 ;
  my @cols = split /\t+/, $lines[0] ;
  my $l = 1 ;
  for ($i = 0 ; $i < scalar(@lines) ; ++$i)
  {
    if (defined $seqIdToTaxId{$cols[1]}) 
    {
      $l = $seqIdToTaxId{$cols[1]} ;
      next if (!defined $taxParent{$l}) ;
      last ;
    }
  }

  for ( ; $i < scalar( @lines ) ; ++$i )
  {
    @cols = split /\t+/, $lines[ $i ] ;
    my $nextl = 1 ;
    if (defined $seqIdToTaxId{$cols[1]})
    {
      $nextl = $seqIdToTaxId{$cols[1]} ;
      next if (!defined $taxParent{$nextl}) ;

      $l = lca( $l, $nextl ) ;
    }
  }

  @cols = split /\t+/, $lines[0] ;
  $cols[0] = (split /\s/, $cols[0])[0] ;
  $cols[0] =~ s/\/1//g ;
  my $contig = "lca" ;
  $contig = $cols[1] if (scalar(@lines) == 1) ;

  print($cols[0]."\t".$l."\t$contig\n") ;
}

my $prevReadId = "" ;
my @lines ;

while ( <STDIN> )
{
  next if (/^#/) ;
  chomp ;
  my @cols = split /\t/ ;
  if ( $cols[0] eq $prevReadId )
  {
    push @lines, $_ ;
  }
  else
  {
    $prevReadId = $cols[0] ;

    OutputPromotedLines( \@lines ) ;

    undef @lines ;
    push @lines, $_ ;
  }
}
OutputPromotedLines( \@lines )  ;
