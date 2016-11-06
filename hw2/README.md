
## Homework2

Perform pairwise alignment with global alignment.
You can change the PAM files and set the gap_open / gap_extend by yourself.
   

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
    
    score pamxxx.txt (finish)  
    aln global  (finish)
    aln local   (upcoming)  
    gap_open    (finish)
    gap_extend  (finish)
    
    output result.fasta
```


#### Reference
```shell

http://www.bioinformaticsonline.org/ch/ch03/supp-all.html

```




