################
# Hybrid footprint
################

agg <- function(x)
{
  x <- as.matrix(x) %*% sapply(unique(colnames(x)),"==",colnames(x))
  return(x)
}

library(Matrix)

items <- read.csv2("fabio/Items.csv")
regions <- read.csv2("fabio/Regions.csv")
regions_exio_fao <- read.csv2("Regions_FAO-EXIO.csv", stringsAsFactors = FALSE)
regions_exio <- unique(regions_exio_fao[,3:5])
regions_exio$EXIOcode <- as.numeric(regions_exio$EXIOcode)
regions_exio <- regions_exio[order(regions_exio$EXIOcode)[1:49],]

year=1995
# years <- 1995:2013

load(paste0("exiobase/pxp/",year,"_Y.RData"))
#E <- readRDS(paste0("fabio/",year,"_E.rds"))
#X <- readRDS(paste0("fabio/",year,"_X.rds"))
E <- readRDS("fabio/E.rds")
E <- E[[paste0(year)]]
X <- readRDS("fabio/X.rds")
X <- X[,paste0(year)]


X[X<0] <- 0
# e <- c(as.vector(E$Landuse) / X, rep(0,nrow(Y)))
e <- as.vector(E$blue) / X#change it to blue water
e[!is.finite(e)] <- 0

# aggregate countries in Y
colnames(Y) <- rep(1:49, each = 7)
Y <- agg(Y)
# Y <- rbind(matrix(0,nrow(E),49),Y)


#--------------------------
# 130 products version
#--------------------------
#L <- readRDS(paste0("/mnt/nfs_fineprint/tmp/fabio/hybrid/",year,"_B.rds"))
# calculate multipliers
#MP <- e * L
# calculate footprints
#FP <- MP %*% Y
#FP <- t(FP)
#colnames(FP) <- rep(1:192, each = 130)
#FP <- agg(FP)
#FP <- t(FP)

# write results
#rownames(FP) <- regions$Country
#colnames(FP) <- regions_exio$EXIOregion
#write.csv2(FP, "footprints_2013_mass.csv")
#sum(FP)

#--------------------------
# mass-based allocation
#--------------------------
L <- readRDS(paste0("fabio/",year,"_B_inv_mass.rds"))
# calculate multipliers
MP <- e * L
# calculate footprints
FP <- MP %*% Y
FP <- t(FP)
colnames(FP) <- rep(1:192, each = 125)
FP <- agg(FP)
FP <- t(FP)

# write results
rownames(FP) <- regions$Country
colnames(FP) <- regions_exio$EXIOregion
write.csv2(FP, paste0("footprints_",year,"_mass.csv"))

#--------------------------
# price-based allocation
#--------------------------
L <- readRDS(paste0("fabio/",year,"_B_inv_value.rds"))
# calculate multipliers
MP <- e * L
# calculate footprints
FP <- MP %*% Y
FP <- t(FP)
colnames(FP) <- rep(1:192, each = 125)
FP <- agg(FP)
FP <- t(FP)

# write results
rownames(FP) <- regions$Country
colnames(FP) <- regions_exio$EXIOregion
write.csv2(FP, paste0("footprints_",year,"_price.csv"))

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
