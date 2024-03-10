### An experiment for Ganon's reassignment based on EM algorithm

ganon_test.all and ganon_test.rep are two files mimicking the output from ganon classify --output-all. In the output, two reads are uniquely assigned to NZ_CP093546.1, one read is uniquely assigned to NZ_CP065615.1, and the other 97 reads are classified to both. After running 

```
 ganon reassign -i ganon_test -o ganon_test_reassign  
```

The reassigned results will assign 99 reads uniquely to NZ_CP093546.1 and only one read is uniquely assigned to NZ_CP065615.1.
