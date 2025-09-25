library(doParallel)
library(foreach)

# Set up parallel
num_cores <- 5
cl <- makeCluster(num_cores)
registerDoParallel(cl)

numitrs <- 5

foreach(i = 1:numitrs) %dopar% {
  
  inf_filename <- paste0('TetraploidSizeResult_', as.character(i), '.RData') 

  # Skip if itr is done already
  if (file.exists(inf_filename)) {
    next
  }
  
  # run inference with different param inits for Gelman (coda)
  b22s <- c(0.65, 0.85, 1.05, 1.25, 1.45)
  b24s <- c(0.65, 0.85, 1.05, 1.15, 1.35)
  b42ss <- c(0.65, 0.85, 1.05, 1.15, 1.35)
  b42ls <- c(0.45, 0.65, 0.85, 1.05, 1.25)
  b44s <- c(0.45, 0.65, 0.85, 1.05, 1.25)
  b4SCs <- c(0.65, 0.85, 1.05, 1.15, 1.35)
  
  d22s <- c(0.15, 0.35, 0.65, 0.95, 1.25)
  d24s <- c(0.15, 0.35, 0.65, 0.95, 1.25)
  d42sc <- c(0.15, 0.35, 0.65, 0.95, 1.35)
  d42lc <- c(0.35, 0.55, 0.85, 1.15, 1.45)
  d44s <- c(0.25, 0.55, 0.85, 1.15, 1.45)
  dscs <- c(0.15, 0.35, 0.65, 0.95, 1.35)
  dnps <- c(0.55, 0.75, 0.95, 1.15, 1.35)
  
  pbs <- c(0.35, 0.45, 0.55, 0.65, 0.75)
  pss <- c(0.35, 0.45, 0.55, 0.65, 0.75)
  pcs <- c(0.015, 0.025, 0.035, 0.045, 0.055)
  pos <- c(0.01, 0.06, 0.11, 0.16, 0.19)
  pscsc <- c(0.55, 0.65, 0.75, 0.85, 0.95)
  
  b22  <- b22s[i]
  b24  <- b24s[i]
  b42s <- b42ss[i]
  b42l <- b42ls[i]
  b44  <- b44s[i]
  b4SC <- b4SCs[i]
  d22  <- d22s[i]
  d24  <- d24s[i]
  d42s <- d42sc[i]
  d42l <- d42lc[i]
  d44  <- d44s[i]
  dsc  <- dscs[i]
  dnp  <- dnps[i]
  pb   <- pbs[i]
  ps   <- pss[i]
  pc   <- pcs[i]
  po   <- pos[i]
  pscs <- pscsc[i]
  
  source('~/sizeModelTetraploid.R', local=TRUE)
  
  # Save output to folder
  save(list = ls(environment()), file = inf_filename)
  
}

stopCluster(cl)
