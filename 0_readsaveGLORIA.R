library(Matrix)
library(data.table)

for(year in 1990:2020){
  
  Z <- fread( paste0("gloria/EEMRIO/",year,"_Z.csv"))
  Z <- as.matrix(Z)
  save(Z, file = paste0("gloria/EEMRIO_rdata/",year,"_Z.RData"))
  rm(Z); gc()
  
  A <- fread( paste0("gloria/EEMRIO/",year,"_A.csv"))
  A <- as.matrix(A)
  save(A, file = paste0("gloria/EEMRIO_rdata/",year,"_A.RData"))
  rm(A); gc()
  
  L <- fread( paste0("gloria/EEMRIO/",year,"_L.csv"))
  L <- as.matrix(L)
  save(L, file = paste0("gloria/EEMRIO_rdata/",year,"_L.RData"))
  rm(L); gc()
  
  x <- fread( paste0("gloria/EEMRIO/",year,"_x.csv"))
  x <- as.matrix(x)
  save(x, file = paste0("gloria/EEMRIO_rdata/",year,"_x.RData"))
  rm(x); gc()
  
  Y <- fread( paste0("gloria/EEMRIO/",year,"_Y.csv"))
  Y <- as.matrix(Y)
  save(Y, file = paste0("gloria/EEMRIO_rdata/",year,"_Y.RData"))
  rm(Y); gc()
  
  Q <- fread( paste0("gloria/EEMRIO/",year,"_Q.csv"))
  Q <- as.matrix(Q)
  save(Q, file = paste0("gloria/EEMRIO_rdata/",year,"_Q.RData"))
  rm(Q); gc()
  
  print(year)
}

