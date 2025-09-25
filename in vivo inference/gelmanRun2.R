library(deSolve)
library(deBInfer)
library(coda)

load('~/TetraploidSizeResult_1.RData')
Tchain1 <- coda::as.mcmc.list(mcmc_samples$samples)
load('~/TetraploidSizeResult_2.RData')
Tchain2 <- coda::as.mcmc.list(mcmc_samples$samples)
load('~/TetraploidSizeResult_3.RData')
Tchain3 <- coda::as.mcmc.list(mcmc_samples$samples)
load('~/TetraploidSizeResult_4.RData')
Tchain4 <- coda::as.mcmc.list(mcmc_samples$samples)
load('~/TetraploidSizeResult_5.RData')
Tchain5 <- coda::as.mcmc.list(mcmc_samples$samples)

T_all_chains <- rbind(Tchain1,Tchain2,Tchain3,Tchain4,Tchain5)

T_summary <- summary(T_all_chains)
T_gelmancriteria <- coda::gelman.diag(T_all_chains)
