######################################
# the reference code of program2 
######################################
######################################
# initial
######################################
# read parameters
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("USAGE: Rscript pro2_<your student ID>.R --input test.fasta --score pam250.txt --aln global --gap_open -10 --gap_extend -2 --output result.fasta", call.=FALSE)
}
# parse parameters
i<-1 
while(i < length(args))
{
  if(args[i] == "--input"){
    i_f<-args[i+1]
    i<-i+1
  }else if(args[i] == "--score"){
    s_f<-args[i+1]
    i<-i+1
  }else if(args[i] == "--aln"){
    aln_mode <- args[i+1]
    i<-i+1
  }else if(args[i] == "--gap_open"){
    g_o<-args[i+1]
    i<-i+1
  }else if(args[i] == "--gap_extend"){
    g_e<-args[i+1]
    i<-i+1    
  }else if(args[i] == "--output"){
    o_f<-args[i+1]
    i<-i+1
  }else{
    stop(paste("Unknown flag", args[i]), call.=FALSE)
  }
  i<-i+1
}

print("PARAMETERS")
print(paste("input file         :", i_f))
print(paste("output file        :", o_f))
print(paste("score file         :", s_f))
print(paste("gap open penalty   :", g_o))
print(paste("gap extend penalty :", g_e))

######################################
# main
######################################
# your code
score_file <- as.matrix(read.table(s_f))
input_file <- readLines(i_f)
linea = unlist(strsplit(paste("*", input_file[2], sep = ""),split=""))
lineb = unlist(strsplit(paste("*", input_file[4], sep = ""),split=""))

final_matrix = matrix(data =NA,nrow = length(lineb) , ncol = length(linea))
dimnames(final_matrix) <- list(lineb,linea)
    



final_matrix[1,1] = 1
for(x in 2:length(linea)){
   final_matrix[1,x] = score_file[lineb[1],linea[x]]
}
for(y in 2:length(lineb)){
    final_matrix[y,1] = score_file[linea[1],lineb[y]]
}
for(x in 2:length(linea)){
    for(y in 2:length(lineb)){
       mat <- score_file[linea[x],lineb[y]] + final_matrix[y-1,x-1]
       gepv <- score_file[lineb[y],ncol(score_file)] + final_matrix[y-1,x]
       geph <- score_file[linea[x],ncol(score_file)] + final_matrix[y,x-1]
       final_matrix[y,x] <- max(mat,gepv,geph)
    }
}

count_x = length(linea)
count_y = length(lineb)
final_a = ""
final_b = ""
while(count_x > 1 || count_y > 1){

    
    
    if(count_x == 1){
        final_a <- paste(final_a,"-" ,sep="" )
        final_b <- paste(final_b,lineb[count_y],sep="" )
        count_y = count_y - 1 
    }else if(count_y == 1){
        final_a <- paste(final_a,linea[count_x],sep="" )
        final_b <- paste(final_b,"-",sep="" )
        count_x = count_x - 1
    }else{
        max = max(final_matrix[y-1,x-1],final_matrix[y,x-1],final_matrix[y-1,x])
    
        if(max == final_matrix[y-1,x-1]){
            final_a <- paste(final_a,linea[count_x],sep="" )
            final_b <- paste(final_b,lineb[count_y],sep="" )
            count_x = count_x -1
            count_y = count_y -1
        }else if(max == final_matrix[y,x-1]){
            final_a <- paste(final_a,linea[count_x],sep="" )
            final_b <- paste(final_b,"-",sep="" )
            count_x = count_x -1
        }else if(max == final_matrix[y-1,x]){
            final_a <- paste(final_a,"-",sep="" )
            final_b <- paste(final_b,lineb[count_y],sep="" )
            count_y = count_y -1
        }
    }
}

write(final_a,file=o_f,append=FALSE)
write(final_b,file=o_f,append=TRUE)
print(final_a)
print(final_b)         #   paste(final_b,lineb[count_y],sep="")

