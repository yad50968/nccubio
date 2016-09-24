# read PAM1 from data
pam1<-as.matrix(read.table("./pam1.txt"))

pam1 <- pam1/10000  
#avoid number too large


pam250 <- pam1
for (i in 1:250) pam250 <- pam250 %*% pam1


pam250 <- pam250 * 100

# output PAM250 as a file
write.table(pam250,"./pam250.txt")

