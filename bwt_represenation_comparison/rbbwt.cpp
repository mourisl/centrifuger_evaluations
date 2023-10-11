#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdarg.h>

#include <string>
#include <fstream>
#include <iostream>
#include <chrono>

#include "SequenceCompactor.hpp"
#include "Sequence_WaveletTree.hpp"
#include "Sequence_RunLength.hpp"
#include "Sequence_RunBlock.hpp"
#include "FMBuilder.hpp"
#include "FMIndex.hpp"

// Usage: ./a.out sequence_file [load]
using namespace std::chrono ;
using timer = std::chrono::high_resolution_clock;

using namespace compactds ;

int main(int argc, char *argv[])
{
  std::string seq ;
  FixedSizeElemArray s ;
  
  char abList[] = "ACGT" ;
  FixedSizeElemArray BWT ;
  size_t n = 0 ;
  if (atoi(argv[2]) == 0 || argc <= 2)
  {
    std::ifstream ifs(argv[1], std::ifstream::in) ;
    std::getline(ifs, seq) ;
    SequenceCompactor seqCompactor ;
    seqCompactor.Init(abList, s, 1000000) ;
    seqCompactor.Compact(seq.c_str(), s) ;

    n = s.GetSize() ;
    struct _FMBuilderParam param ;
    struct _FMIndexAuxData fmAuxData ;
    param.threadCnt = 4 ;
    param.saBlockSize = n / param.threadCnt ;
    size_t firstISA = 0 ;
    FMBuilder::Build(s, n, strlen(abList),
        BWT, firstISA, param) ;

    FILE *fp = fopen("tmp.idx", "w") ;
    BWT.Save(fp) ;
    fclose(fp) ;
  }
  else
  {
    FILE *fp = fopen(argv[1], "r") ;
    BWT.Load(fp) ;
    fclose(fp) ;
    
    n = BWT.GetSize() ;
  }
  printf("Total size: %lu\n", n) ;

  Sequence_WaveletTree<> plbwt ; // plain bwt
  plbwt.SetSelectSpeed(0) ;
  plbwt.Init(BWT, n, abList) ;
  printf("Plain bwt space (bytes): %lu\n", plbwt.GetSpace()) ;

  Sequence_RunLength rlbwt ;
  rlbwt.Init(BWT, n, abList) ;
  rlbwt.PrintStats() ;
  printf("Runlength bwt space (bytes): %lu\n", rlbwt.GetSpace()) ;

  Sequence_RunBlock rbbwt ;
  rbbwt.Init(BWT, n, abList) ;
  rbbwt.PrintStats() ;
  printf("RunBlock bwt space (bytes): %lu\n", rbbwt.GetSpace()) ;
  
  auto start = timer::now();
  size_t check = 0 ;
  size_t i ;
  for (i = 0 ; i < n && i < 100000000 ; ++i)
    check += rbbwt.Rank(i, 'A') ;
  auto stop = timer::now();
  std::cout << "# rank time (ns) from " << i << "  = " << duration_cast<nanoseconds>(stop-start).count()/(double)i << std::endl;
  std::cout << "# rank sum = " << check << std::endl;
  

  return 0 ;
}
