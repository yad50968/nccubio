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

score_file <- as.matrix(read.table(s_f))
input_file <- readLines(i_f)
linea = unlist(strsplit(paste("*", input_file[2], sep = ""),split=""))
lineb = unlist(strsplit(paste("*", input_file[4], sep = ""),split=""))

# store the final matrix value
final_matrix = matrix(data =NA,nrow = length(lineb) , ncol = length(linea))

# rename the final_matrix row and col name
dimnames(final_matrix) <- list(lineb,linea)
    

# set default value in final_matrix
final_matrix[1,1] = 0
final_matrix[1,2] = as.numeric(g_o)
final_matrix[2,1] = as.numeric(g_o)
for(x in 3:length(linea)){
  final_matrix[1,x] = final_matrix[1,x-1] + as.numeric(g_e)
}
for(y in 3:length(lineb)){
  final_matrix[y,1] = final_matrix[y-1,1] + as.numeric(g_e)
}


gep_is_open = 1
for(x in 2:length(linea)){
    for(y in 2:length(lineb)){
       mat <- score_file[linea[x],lineb[y]] + final_matrix[y-1,x-1]
       if(gep_is_open == 1){
		gepv <- as.numeric(g_o) + final_matrix[y-1,x]   # In global , meet a gap , add the gap open penalty
       		geph <- as.numeric(g_o)  + final_matrix[y,x-1]
       		final_matrix[y,x] <- max(mat,gepv,geph)
		
    		if(final_matrix[y,x] != mat){
			gep_is_open = 0 # it have to add a start gep 	
		}
	}else{  
		gepv <- as.numeric(g_e) + final_matrix[y-1,x]   # In global , meet a gap , add the gap open penalty
       		geph <- as.numeric(g_e)  + final_matrix[y,x-1]
		final_matrix[y,x] <- max(mat,gepv,geph)
    		if(final_matrix[y,x] == mat) gep_is_open = 1 # it have to add a gep 	
	}
     }
}
count_x =  2 
count_y =  2
final_a = ""
final_b = ""

while(1){

   if(count_x == length(linea)){
        final_a <- paste(final_a,"-" ,sep="" )
        final_b <- paste(final_b,lineb[count_y],sep="" )
        count_y = count_y + 1 
   	if(count_y > length(lineb)) break; 
   }else if(count_y == length(lineb)){
        final_a <- paste(final_a,linea[count_x],sep="" )
        final_b <- paste(final_b,"-",sep="" )
	count_x = count_x + 1
   	if(count_x > length(linea)) break;
    }else{
        max = max(final_matrix[count_y+1,count_x+1],final_matrix[count_y,count_x+1],final_matrix[count_y+1,count_x])
    
        if(max == final_matrix[count_y+1,count_x+1]){
            final_a <- paste(final_a,linea[count_x],sep="" )
            final_b <- paste(final_b,lineb[count_y],sep="" )
            count_x = count_x + 1
            count_y = count_y + 1
        }else if(max == final_matrix[count_y,count_x+1]){
            final_a <- paste(final_a,linea[count_x],sep="" )
            final_b <- paste(final_b,"-",sep="" )
            count_x = count_x + 1
        }else if(max == final_matrix[count_y+1,count_x]){
            final_a <- paste(final_a,"-",sep="" )
            final_b <- paste(final_b,lineb[count_y],sep="" )
            count_y = count_y + 1
        }
    }

    
    
}
write(input_file[1],file=o_f,append=FALSE)
write(final_a,file=o_f,append=TRUE)
write(input_file[3],file=o_f,append=TRUE)
write(final_b,file=o_f,append=TRUE)
