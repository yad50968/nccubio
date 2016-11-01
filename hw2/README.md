
## Homework2

Perform pairwise alignment

##### Manual

```shell
git clone https://github.com/yad50968/nccubio.git

cd nccubio/hw2/

Rscritp hw2_105753036.R --input test.fasta --score pam250.txt --aln global --gap_open -10\
        --gap_extend -2 --output result.fasta

```
##### Note
```shell
You can change the option parameters
  ex:
    input test.fasta
    score pam250.txt  (it can use other matrix)
    aln global (finish) | local   (upcoming)  
    gap_open    (upcoming)
    gap_extend     (upcoming)
    output result.fasta
```







