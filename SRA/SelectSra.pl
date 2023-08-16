#!/bin/perl

# Select the SRA from runinfo file with representative tax id

use strict ;
use warnings ;

die "Usage: perl a.pl sra_run_info full_nodes.dmp effective_nodes.dmp num_of_species in_species(1-in species, 0-not in species but has genus)\n" if (@ARGV == 0) ;

my $n = $ARGV[3] ;
my $inSpecies = $ARGV[4] ;

my %effectiveTax ; # the tax ids used in building the genome database
open FP, $ARGV[2] ;
while (<FP>)
{
  chomp ;
  my @cols = split /\s+/, $_ ;
  $effectiveTax{$cols[0]} = $cols[4] ;
}
close FP ;

my %taxTree ;
my %taxRank ;
open FP, $ARGV[1] ;
while (<FP>)
{
  chomp ;
  my @cols = split /\s+/, $_ ;  
  $taxTree{$cols[0]} = $cols[2] ;
  $taxRank{$cols[0]} = $cols[4] ;
}
close FP ;

my %taxToSpecies ;
my %taxToGenus ;
foreach my $tid (keys %taxTree)
{
  if ($taxRank{$tid} eq "species")
  {
    $taxToSpecies{$tid} = $tid ;
  }
  my $p = $taxTree{$tid} ;
  while ($p != 1)
  {
    if ($taxRank{$p} eq "species")
    {
      $taxToSpecies{$tid} = $p ;
    }
    elsif ($taxRank{$p} eq "genus")
    {
      $taxToGenus{$tid} = $p ;
      last ;
    }
    $p = $taxTree{$p} ; 
  }
}

# Start to process the runinfo file
#Run,ReleaseDate,LoadDate,spots,bases,spots_with_mates,avgLength,size_MB,AssemblyName,download_path,Experiment,LibraryName,LibraryStrategy,LibrarySelection,LibrarySource,LibraryLayout,InsertSize,InsertDev,Platform,Model,SRAStudy,BioProject,Study_Pubmed_id,ProjectID,Sample,BioSample,SampleType,TaxID,ScientificName,SampleName,g1k_pop_code,source,g1k_analysis_group,Subject_ID,Sex,Disease,Tumor,Affection_Status,Analyte_Type,Histological_Type,Body_Site,CenterName,Submission,dbgap_study_accession,Consent,RunHash,ReadHash
#SRR25408000,2023-07-24 21:05:20,2023-07-24 21:03:56,417481,201004449,417481,481,105,,https://sra-downloadb.be-md.ncbi.nlm.nih.gov/sos4/sra-pub-zq-7/SRR025/25408/SRR25408000/SRR25408000.lite.1,SRX21144088,WGS_05142019,WGS,RANDOM,GENOMIC,PAIRED,0,0,ILLUMINA,Illumina MiSeq,SRP450441,PRJNA996741,,996741,SRS18407838,SAMN36698470,simple,53408,Pseudomonas citronellolis,1,,,,,,,no,,,,,UCLA,SRA1678671,,public,F16C16AB8ECAC92FF88C93D7D6D04143,96E0E76C6B58FAF4539116CD0767D656
my $minFrag = 1000000 ;
my $selected = 0 ;
open FP, $ARGV[0] ;
while (<FP>)
{
  chomp ;
  my @cols = split /,/, $_ ;
  next if ($cols[3] < $minFrag) ;
  my $taxId = $cols[27] ;
  next if (!defined $taxRank{$taxId}) ;
  
  if ($inSpecies == 1)
  {
    next if (!defined $taxToSpecies{$taxId} 
        || !defined $effectiveTax{ $taxToSpecies{$taxId}}) ;
  }
  else
  {
    # Skip if its species is in the database
    next if ((defined $taxToSpecies{$taxId} 
        && !defined $effectiveTax{ $taxToSpecies{$taxId}})) ;
    
    next if (!defined $taxToGenus{$taxId} 
        || !defined $effectiveTax{ $taxToGenus{$taxId}}) ;

  }
  print $cols[0] ;
  ++$selected ;
  last if ($selected >= $n) ;
}
close FP ;
