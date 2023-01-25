library(Matrix)

for(year in 1995:1996){
  A <- read.delim(paste0("exiobase/IOT_",year,"_pxp/A.txt"), skip = 2,sep = "\t", dec = ".")
  A <-Matrix(as.matrix(A[,3:ncol(A)]), sparse = TRUE)
  
  Y <- read.delim(paste0("exiobase/IOT_",year,"_pxp/Y.txt"), skip = 2,sep = "\t", dec = ".")
  Y <-Matrix(as.matrix(Y[,3:ncol(Y)]), sparse = TRUE)
  
  I <- diag(ncol(A))
  L <- solve(I - A)
  X <- L %*% Y
  x <- rowSums(X)
  Z <- t(x*t(A))
  
  save(Z, file = paste0("exiobase/pxp/",year,"_Z.RData"))
  save(L, file = paste0("exiobase/pxp/",year,"_L.RData"))
  save(x, file = paste0("exiobase/pxp/",year,"_x.RData"))
  save(Y, file = paste0("exiobase/pxp/",year,"_Y.RData"))
  print(year)
}

