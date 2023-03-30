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
regions <- read.csv("fabio_v1.2/regions.csv")

years <- 1990:2019

for(year in years){
  print(year)
  
  E <- readRDS("fabio_v1.2/E_newwater.rds")
  E <- E[[paste0(year)]]
  X <- readRDS("fabio_v1.2/X.rds")
  X <- X[,paste0(year)]
  X[X<0] <- 0
  
  Y <- readRDS("fabio_v1.2/Y.rds")
  Y <- Y[[paste0(year)]]
  #mask out all other uses in Y
  other <- seq(4,1728,9)
  Y[,other] <- 0
  # aggregate countries in Y
  colnames(Y) <- rep(1:192, each = 9)
  Y <- agg(Y)
  
  L <- readRDS(paste0("fabio_v1.2/",year,"_L_value.rds"))
  
  for (water in c("blue","green")){

    e <- as.vector(E[[water]]) / X#change it to blue water
    e[!is.finite(e)] <- 0
    
    # calculate multipliers
    MP <- e * L
    # calculate footprints
    FP <- MP %*% Y
    #FP <- t(FP)
    #colnames(FP) <- rep(1:192, each = 123)
    #FP <- agg(FP)
    #FP <- t(FP)
    
    # write results, reserve sector information, further processed in Python
    rownames(FP) <- rep(1:192, each = 123)
    colnames(FP) <- regions$area
    write.csv(as.data.frame(as.matrix(FP)), paste0("footprint_output/","Afootprints_",water,year,"_value.csv"))
    
  }

}



#--------------------------
# mass-based allocation
#--------------------------
#L <- readRDS(paste0("fabio_v1.2/",year,"_B_inv_mass.rds"))
# calculate multipliers
#MP <- e * L
# calculate footprints
#FP <- MP %*% Y
#FP <- t(FP)
#colnames(FP) <- rep(1:192, each = 123)
#FP <- agg(FP)
#FP <- t(FP)

# write results
#rownames(FP) <- regions$area
#colnames(FP) <- regions_gloria$GLORIA_region
#write.csv(FP, paste0("fabio_v1.2/hybrid/","footprints_",year,"_mass.csv"))

#--------------------------
# price-based allocation FP EU
#--------------------------
#L <- readRDS(paste0("/mnt/nfs_fineprint/tmp/fabio/v2/hybrid/",year,"_B_inv_price.rds"))
# calculate multipliers
#MP <- e * L
# calculate footprints
#FP <- MP %*% rowSums(Y[,1:28])

# write results
#data <- data.frame(item = substr(rownames(FP)[1:125],3,100),
#                   country = rep(regions$Country, each=125),
#                   continent = rep(regions$Continent, each=125),
#                   value = FP[,1])

#data <- data[data$value!=0,]
# data <- reshape2::dcast(data, item ~ country)
# data[is.na(data)] <- 0
#write.csv2(data, paste0("footprints_non-food_EU_",year,"__hectares_price.csv"))
