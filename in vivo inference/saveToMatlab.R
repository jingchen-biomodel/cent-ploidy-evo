library(R.matlab)
library(deBInfer)

# filepath to load/save needs to be changed based on folder/file to be read/saved

load('~/TetraploidSizeResult_1.RData')

output <- as.matrix(mcmc_samples$samples) # MCMC chain for each param

writeMat(param=output)
remove(list=ls())