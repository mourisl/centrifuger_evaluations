#!/usr/bin/env perl

use strict ;
use warnings ;


die "Usage: kmcp-promote kmcp_seq_id.map nodes.dmp  < kmcp_class.out > kmcp_3c.output\n" if ( @ARGV == 0 ) ;

# file name to tax id
open FP, $ARGV[0] ;
my %seqIdToTaxId ;
while (<FP>)
{
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
  # p_sim_2M.fq.000000000 200 160 9.5639e-15  58  GCF_015338205.1_ASM1533820v1_genomic  0 1 4501826 21  158 0.9875  0.0000  0.0000  0
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
    if (defined $seqIdToTaxId{$cols[5]}) 
    {
      $l = $seqIdToTaxId{$cols[5]} ;
      next if (!defined $taxParent{$l}) ;
      last ;
    }
  }

  for ( ; $i < scalar( @lines ) ; ++$i )
  {
    @cols = split /\t+/, $lines[ $i ] ;
    my $nextl = 1 ;
    if (defined $seqIdToTaxId{$cols[5]})
    {
      $nextl = $seqIdToTaxId{$cols[5]} ;
      next if (!defined $taxParent{$nextl}) ;

      $l = lca( $l, $nextl ) ;
    }
  }

  @cols = split /\t+/, $lines[0] ;
  $cols[0] =~ s/\/1//g ;
  print($cols[0]."\t".$l."\t".$cols[3]."\n") ;
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
