################
# Hybrid footprint
################

agg <- function(x)
{
  x <- as.matrix(x) %*% sapply(unique(colnames(x)),"==",colnames(x))
  return(x)
}

library(Matrix)

#io_codes <- read.csv(file = 'fabio_v1.2/io_codes.csv')

items <- read.csv("fabio_v1.2/items.csv")

regions_gloria_fao <- read.csv2("Regions_FAO-gloria.csv", stringsAsFactors = FALSE)
regions_gloria <- unique(regions_gloria_fao[,3:5])
regions_gloria$GLORIA_code <- as.numeric(regions_gloria$GLORIA_code)
regions_gloria <- regions_gloria[order(regions_gloria$GLORIA_code)[1:164],]

years <- 1990:2019

for(year in years){
  print(year)

  load(paste0("gloria/EEMRIO_rdata/",year,"_x.RData"))
  X <- x[,1]
  X[X<0] <- 0
  
  load(paste0("gloria/EEMRIO_rdata/",year,"_Q.RData"))#million m3
  E <- Q[,"Non-agriculture blue water consumption"]*10^6
  e <- as.vector(E) / X#change it to blue water
  e[!is.finite(e)] <- 0
  
  # aggregate countries in Y
  load(paste0("gloria/EEMRIO_rdata/",year,"_Y.RData"))
  colnames(Y) <- rep(1:164, each = 6)
  Y <- agg(Y)
  
  load(paste0("gloria/EEMRIO_rdata/", year, "_L.RData"))
  # calculate multipliers
  MP <- e * L
  # calculate footprints
  FP <- MP %*% Y
  #FP <- t(FP)
  #colnames(FP) <- rep(1:192, each = 123)
  #FP <- agg(FP)
  #FP <- t(FP)
  
  # write results, reserve sector information, further processed in Python
  rownames(FP) <- rep(1:164, each = 120)
  colnames(FP) <- regions_gloria$GLORIA_region
  write.csv(as.data.frame(as.matrix(FP)), paste0("footprint_output/","Dfootprints_blue",year,"_value.csv"))
}
