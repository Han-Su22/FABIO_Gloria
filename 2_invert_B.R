################################
# invert B
################################
# Block matrix inversion:
# B^-1 = -(A - BD^-1C)^-1 BD^-1
# for C = 0 -->  B^-1 = -A^-1 BD^-1

library(Matrix)

#year=2013
#years <- 1986:2013
years <- 1995:1996
#versions <- c("","losses/","wood/")
#version="losses/"

#for(version in versions){
for(year in years){
  print(paste0(year))
  
  load(paste0("gloria/EEMRIO_rdata/", year, "_x.RData"))
  load(paste0("gloria/EEMRIO_rdata/", year, "_L.RData"))

  
  D_inv <- L
  rm(L); gc()
  
  B <- readRDS(paste0("fabio_v1.2/hybrid/", year, "_B.rds"))
  B <- t(t(B)/x[,1])
  B[!is.finite(B)] <- 0
  B[B<0] <- 0
  B <- 0-B
  
  A_inv <- readRDS(paste0("fabio_v1.2/", year, "_L_mass.rds"))
  B_inv <- -A_inv %*% B %*% D_inv
  saveRDS(B_inv, paste0("fabio_v1.2/", year, "_B_inv_mass.rds"))
  
  A_inv <- readRDS(paste0("fabio_v1.2/", year, "_L_value.rds"))
  B_inv <- -A_inv %*% B %*% D_inv
  saveRDS(B_inv, paste0("fabio_v1.2/", year, "_B_inv_value.rds"))
  
}
#}

