library(deBInfer)
library(deSolve)
library(coda)

ploidyModel <- function(t,y,params){
  with(as.list(c(y,params)),{
    # EQUATIONS
    
    dy2n2c  <- n2c2*(NP*dNP + n4SC*(d4nSC - b4nSC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1) - b4nSC*(pSCsym - 1)*(pCyto + pOver - 1)) + n2c2*(d2n2c - 2*b2n2c*pOver + b2n2c*(2*pCyto + 2*pOver - 1) + b2n2c*pCyto*(pSC - 1) - b2n2c*pCyto*pSC) - n4c2l*(b4n2cl*pCyto - d4n2cl + 2*b4n2cl*pOver + 2*b4n2cs*pOver - b4n2cl*(2*pCyto + 2*pOver - 1)) + n2c4*(d2n4c - b2n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b2n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c4*(d4n4c - b4n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b4n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c2s*(d4n2cs - b4n2cs*pCyto + b4n2cs*(2*pCyto + 2*pOver - 1))) - n2c2*(d2n2c + b2n2c*(2*pCyto + 2*pOver - 1)) + b2n4c*n2c4*pBi*(pSym - 1)*(pCyto + pOver - 1)
    dy2n4c  <- n2c4*(NP*dNP + n4SC*(d4nSC - b4nSC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1) - b4nSC*(pSCsym - 1)*(pCyto + pOver - 1)) + n2c2*(d2n2c - 2*b2n2c*pOver + b2n2c*(2*pCyto + 2*pOver - 1) + b2n2c*pCyto*(pSC - 1) - b2n2c*pCyto*pSC) - n4c2l*(b4n2cl*pCyto - d4n2cl + 2*b4n2cl*pOver + 2*b4n2cs*pOver - b4n2cl*(2*pCyto + 2*pOver - 1)) + n2c4*(d2n4c - b2n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b2n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c4*(d4n4c - b4n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b4n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c2s*(d4n2cs - b4n2cs*pCyto + b4n2cs*(2*pCyto + 2*pOver - 1))) - n2c4*(d2n4c + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1)) + 2*b2n2c*n2c2*pOver
    dy4n2cs <- n4c2s*(NP*dNP + n4SC*(d4nSC - b4nSC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1) - b4nSC*(pSCsym - 1)*(pCyto + pOver - 1)) + n2c2*(d2n2c - 2*b2n2c*pOver + b2n2c*(2*pCyto + 2*pOver - 1) + b2n2c*pCyto*(pSC - 1) - b2n2c*pCyto*pSC) - n4c2l*(b4n2cl*pCyto - d4n2cl + 2*b4n2cl*pOver + 2*b4n2cs*pOver - b4n2cl*(2*pCyto + 2*pOver - 1)) + n2c4*(d2n4c - b2n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b2n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c4*(d4n4c - b4n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b4n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c2s*(d4n2cs - b4n2cs*pCyto + b4n2cs*(2*pCyto + 2*pOver - 1))) - n4c2s*(d4n2cs + b4n2cs*(2*pCyto + 2*pOver - 1)) + b4nSC*n4SC*(pSCsym - 1)*(pCyto + pOver - 1)
    dy4n2cl <- n4c2l*(NP*dNP + n4SC*(d4nSC - b4nSC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1) - b4nSC*(pSCsym - 1)*(pCyto + pOver - 1)) + n2c2*(d2n2c - 2*b2n2c*pOver + b2n2c*(2*pCyto + 2*pOver - 1) + b2n2c*pCyto*(pSC - 1) - b2n2c*pCyto*pSC) - n4c2l*(b4n2cl*pCyto - d4n2cl + 2*b4n2cl*pOver + 2*b4n2cs*pOver - b4n2cl*(2*pCyto + 2*pOver - 1)) + n2c4*(d2n4c - b2n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b2n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c4*(d4n4c - b4n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b4n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c2s*(d4n2cs - b4n2cs*pCyto + b4n2cs*(2*pCyto + 2*pOver - 1))) - n4c2l*(d4n2cl + b4n2cl*(2*pCyto + 2*pOver - 1)) + b4n4c*n4c4*pBi*(pSym - 1)*(pCyto + pOver - 1)
    dy4n4c  <- n4c4*(NP*dNP + n4SC*(d4nSC - b4nSC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1) - b4nSC*(pSCsym - 1)*(pCyto + pOver - 1)) + n2c2*(d2n2c - 2*b2n2c*pOver + b2n2c*(2*pCyto + 2*pOver - 1) + b2n2c*pCyto*(pSC - 1) - b2n2c*pCyto*pSC) - n4c2l*(b4n2cl*pCyto - d4n2cl + 2*b4n2cl*pOver + 2*b4n2cs*pOver - b4n2cl*(2*pCyto + 2*pOver - 1)) + n2c4*(d2n4c - b2n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b2n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c4*(d4n4c - b4n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b4n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c2s*(d4n2cs - b4n2cs*pCyto + b4n2cs*(2*pCyto + 2*pOver - 1))) - n4c4*(d4n4c + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1)) + 2*b4n2cl*n4c2l*pOver - b2n2c*n2c2*pCyto*(pSC - 1)
    dy4nSC  <- n4SC*(NP*dNP + n4SC*(d4nSC - b4nSC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1) - b4nSC*(pSCsym - 1)*(pCyto + pOver - 1)) + n2c2*(d2n2c - 2*b2n2c*pOver + b2n2c*(2*pCyto + 2*pOver - 1) + b2n2c*pCyto*(pSC - 1) - b2n2c*pCyto*pSC) - n4c2l*(b4n2cl*pCyto - d4n2cl + 2*b4n2cl*pOver + 2*b4n2cs*pOver - b4n2cl*(2*pCyto + 2*pOver - 1)) + n2c4*(d2n4c - b2n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b2n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c4*(d4n4c - b4n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b4n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c2s*(d4n2cs - b4n2cs*pCyto + b4n2cs*(2*pCyto + 2*pOver - 1))) - n4SC*(d4nSC + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1)) + 2*b4n2cs*n4c2l*pOver + b2n2c*n2c2*pCyto*pSC
    dyNP    <- NP*(NP*dNP + n4SC*(d4nSC - b4nSC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4nSC*(pSCsym*(2*pCyto + 2*pOver - 2) + 1) - b4nSC*(pSCsym - 1)*(pCyto + pOver - 1)) + n2c2*(d2n2c - 2*b2n2c*pOver + b2n2c*(2*pCyto + 2*pOver - 1) + b2n2c*pCyto*(pSC - 1) - b2n2c*pCyto*pSC) - n4c2l*(b4n2cl*pCyto - d4n2cl + 2*b4n2cl*pOver + 2*b4n2cs*pOver - b4n2cl*(2*pCyto + 2*pOver - 1)) + n2c4*(d2n4c - b2n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b2n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b2n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c4*(d4n4c - b4n4c*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*(pBi*pSym*(2*pCyto + 2*pOver - 2) + 1) - b4n4c*pBi*(pSym - 1)*(pCyto + pOver - 1)) + n4c2s*(d4n2cs - b4n2cs*pCyto + b4n2cs*(2*pCyto + 2*pOver - 1))) - NP*dNP + b4nSC*n4SC*(pCyto + 2*pOver + (pSCsym - 1)*(pCyto + pOver - 1)) + b4n2cl*n4c2l*pCyto + b4n2cs*n4c2s*pCyto + b2n4c*n2c4*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1)) + b4n4c*n4c4*(pCyto + 2*pOver + pBi*(pSym - 1)*(pCyto + pOver - 1))
      
    list(c(dy2n2c,dy2n4c,dy4n2cs,dy4n2cl,dy4n4c,dy4nSC,dyNP))
  })
}

# OBSERVATIONS

# 4N tumor data
obs4N <- data.frame(
  time = c(21,21,21,22,23,25,27,28,28,34,35,35,41,50,54,58),
  n2c2 = c(50,38,22,32,33.3,16,42,20,20,26,28,34,24,46,22,32)/100,
  n2c4 = c(4,4,2,4,4.2,6,10,2,2,2,10,2,0,6,0,6)/100,
  n4c2 = c(30,40,58,48,41.7,46,32,46,56,46,44,46,54,36,62,44)/100,
  n4c4 = c(16,18,18,16,20.8,32,16,32,20,26,18,16,20,12,16,18)/100,
  NP   = c(0,0,0,0,0,0,0,0,2,0,0,2,2,0,0,0)/100,
  stringsAsFactors = FALSE
)

# Likelihood model
obs4N_model <- function(data, sim.data, samp){
  ec <- 1e-6
  llik.n2c2 <- 0
  llik.n2c4 <- 0
  llik.n4c2 <- 0
  llik.n4c4 <- 0
  llik.NP   <- 0
  for(i in unique(data$time)){
    try(llik.n2c2 <- llik.n2c2 + sum(dnorm(obs4N$n2c2[obs4N$time == i],
                                           mean = (sim.data[,"n2c2"][sim.data[,"time"] == i] + ec),
                                           sd = samp[['sd.n2c2']], log = TRUE)))
    try(llik.n2c4 <- llik.n2c4 + sum(dnorm(obs4N$n2c4[obs4N$time == i],
                                           mean = (sim.data[,"n2c4"][sim.data[,"time"] == i] + ec),
                                           sd = samp[['sd.n2c4']], log = TRUE)))
    try(llik.n4c2 <- llik.n4c2 + sum(dnorm(obs4N$n4c2[obs4N$time == i],
                                           mean = (sim.data[,"n4c2s"][sim.data[,"time"] == i] + sim.data[,"n4c2l"][sim.data[,"time"] == i] + ec),
                                           sd = samp[['sd.n4c2']], log = TRUE)))
    try(llik.n4c4 <- llik.n4c4 + sum(dnorm(obs4N$n4c4[obs4N$time == i],
                                           mean = (sim.data[,"n4c4"][sim.data[,"time"] == i] + sim.data[,"n4SC"][sim.data[,"time"] == i] + ec),
                                           sd = samp[['sd.n4c4']], log = TRUE)))
    try(llik.NP <- llik.NP + sum(dnorm(obs4N$NP[obs4N$time == i],
                                       mean = (sim.data[,"NP"][sim.data[,"time"] == i] + ec),
                                       sd = samp[['sd.NP']], log = TRUE)))
  }
  llik <- llik.n2c2 + llik.n2c4 + llik.n4c2 + llik.n4c4 + llik.NP
  return(llik)
}

# Define inference parameters
# propvar: Uniform(9/10*theta, 10/9*theta) --> SMALL step, keeps positive
b2n2c <- debinfer_par(name = "b2n2c", var.type = "de", fixed = FALSE, value = b22,
                      prior = "unif", hypers = list(min = 0.6, max = 1.6),
                      prop.var = c(9,10), samp.type = "rw-unif")
b2n4c <- debinfer_par(name = "b2n4c", var.type = "de", fixed = FALSE,
                      value = b24, prior = "unif", hypers =
                        list(min = 0.6, max = 1.4), prop.var = c(9,10),
                      samp.type = "rw-unif")
b4n2cs <- debinfer_par(name = "b4n2cs", var.type = "de", fixed = FALSE,
                       value = b42s, prior = "unif", hypers = 
                         list(min = 0.6, max = 1.4), prop.var = c(9,10),
                       samp.type = "rw-unif")
b4n2cl <- debinfer_par(name = "b4n2cl", var.type = "de", fixed = FALSE,
                       value = b42l,  prior = "unif", hypers =
                         list(min = 0.4, max = 1.4), prop.var = c(9,10),
                       samp.type = "rw-unif")
# b4n4cl in manuscript
b4n4c <- debinfer_par(name = "b4n4c", var.type = "de", fixed = FALSE,
                      value = b44, prior = "unif", hypers =
                        list(min = 0.4, max = 1.4), prop.var = c(9,10),
                      samp.type = "rw-unif")
# b4n4cs in manuscript
b4nSC <- debinfer_par(name = "b4nSC", var.type = "de", fixed = FALSE,
                      value = b4SC, prior = "unif", hypers = 
                        list(min = 0.6, max = 1.4), prop.var = c(9,10),
                      samp.type = "rw-unif")

d2n2c <- debinfer_par(name = "d2n2c", var.type = "de", fixed = FALSE,
                      value = d22, prior = "unif", hypers =
                        list(min = 0, max = 1.5), prop.var = c(9,10),
                      samp.type = "rw-unif")
d2n4c <- debinfer_par(name = "d2n4c", var.type = "de", fixed = FALSE,
                      value = d24, prior = "unif", hypers =
                        list(min = 0, max = 1.5), prop.var = c(9,10),
                      samp.type = "rw-unif")
d4n2cs <- debinfer_par(name = "d4n2cs", var.type = "de", fixed = FALSE,
                       value = d42s, prior = "unif", hypers =
                         list(min = 0, max = 2), prop.var = c(9,10),
                       samp.type = "rw-unif")
d4n2cl <- debinfer_par(name = "d4n2cl", var.type = "de", fixed = FALSE,
                       value = d42l, prior = "unif", hypers =
                         list(min = 0, max = 2), prop.var = c(9,10),
                       samp.type = "rw-unif")
d4n4c <- debinfer_par(name = "d4n4c", var.type = "de", fixed = FALSE,
                      value = d44, prior = "unif", hypers =
                        list(min = 0.2, max = 2), prop.var = 0.05,
                      samp.type = "rw")
d4nSC <- debinfer_par(name = "d4nSC", var.type = "de", fixed = FALSE,
                      value = dsc, prior = "unif", hypers =
                        list(min = 0, max = 2), prop.var = c(9,10),
                      samp.type = "rw-unif")
dNP <- debinfer_par(name = "dNP", var.type = "de", fixed = FALSE,
                    value = dnp, prior = "unif", hypers =
                      list(min = 0, max = 3), prop.var = c(9,10),
                    samp.type = "rw-unif")

pBi <- debinfer_par(name = "pBi", var.type = "de", fixed = FALSE, value = pb,
                    prior = "unif", hypers = list(min = 0.3, max = 0.9),
                    prop.var = c(9,10), samp.type = "rw-unif")
pSym <- debinfer_par(name = "pSym", var.type = "de", fixed = FALSE, value = ps,
                     prior = "unif", hypers = list(min = 0.3, max = 0.8),
                     prop.var = c(9,10), samp.type = "rw-unif")
pCyto <- debinfer_par(name = "pCyto", var.type = "de", fixed = FALSE, value = pc,
                      prior = "unif", hypers = list(min = 0.01, max = 0.1),
                      prop.var = c(9,10), samp.type = "rw-unif")
pOver <- debinfer_par(name = "pOver", var.type = "de", fixed = FALSE, value = po,
                      prior = "unif", hypers = list(min = 0, max = 0.2),
                      prop.var = c(9,10), samp.type = "rw-unif")
pSCsym <- debinfer_par(name = "pSCsym", var.type = "de", fixed = FALSE, value = pscs,
                       prior = "unif", hypers = list(min = 0.5, max = 1),
                       prop.var = c(9,10), samp.type = "rw-unif")

# Fixed
pSC <- debinfer_par(name = "pSC", var.type = "de", fixed = TRUE, value = 0.329)

# Noise Parameters
sd.n2c2 <- debinfer_par(name = "sd.n2c2", var.type = "obs", fixed = FALSE,
                        value = 0.05, prior = "lnorm", hypers = list(meanlog = 0, sdlog = 1),
                        prop.var = c(3,4), samp.type = "rw-unif")
sd.n2c4 <- debinfer_par(name = "sd.n2c4", var.type = "obs", fixed = FALSE,
                        value = 0.05, prior = "lnorm", hypers = list(meanlog = 0, sdlog = 1),
                        prop.var = c(3,4), samp.type = "rw-unif")
sd.n4c2 <- debinfer_par(name = "sd.n4c2", var.type = "obs", fixed = FALSE,
                        value = 0.05, prior = "lnorm", hypers = list(meanlog = 0, sdlog = 1),
                        prop.var = c(3,4), samp.type = "rw-unif")
sd.n4c4 <- debinfer_par(name = "sd.n4c4", var.type = "obs", fixed = FALSE,
                        value = 0.05, prior = "lnorm", hypers = list(meanlog = 0, sdlog = 1),
                        prop.var = c(3,4), samp.type = "rw-unif")
sd.NP <- debinfer_par(name = "sd.NP", var.type = "obs", fixed = FALSE,
                      value = 0.05, prior = "lnorm", hypers = list(meanlog = 0, sdlog = 1),
                      prop.var = c(3,4), samp.type = "rw-unif")

# Initial Conditions (+DCB)
n2c2 <- debinfer_par(name = "n2c2", var.type = "init", fixed = TRUE, value = 0.0922)
n2c4 <- debinfer_par(name = "n2c4", var.type = "init", fixed = TRUE, value = 0.0019)
n4c2s <- debinfer_par(name = "n4c2s", var.type = "init", fixed = TRUE, value = 0.0074)
n4c2l <- debinfer_par(name = "n4c2l", var.type = "init", fixed = TRUE, value = 0)
n4c4 <- debinfer_par(name = "n4c4", var.type = "init", fixed = TRUE, value = 0.5552)
n4SC <- debinfer_par(name = "n4SC", var.type = "init", fixed = TRUE, value = 0.2727)
NP   <- debinfer_par(name = "NP", var.type = "init", fixed = TRUE, value = 0.0706)

mcmc.pars <- setup_debinfer(b2n2c,b2n4c,b4n2cs,b4n2cl,b4n4c,b4nSC,d2n2c,d2n4c,
                            d4n2cs,d4n2cl,d4n4c,d4nSC,dNP,pBi,pSym,pCyto,pOver,
                            pSC,pSCsym,sd.n2c2,sd.n2c4,sd.n4c2,sd.n4c4,sd.NP,
                            n2c2,n2c4,n4c2s,n4c2l,n4c4,n4SC,NP)

# Inference

iter <- 100000
mcmc_samples <- de_mcmc(N = iter, data = obs4N, de.model = ploidyModel,
                        obs.model = obs4N_model, all.params = mcmc.pars,
                        Tmax = max(obs4N$time), data.times = obs4N$time, cnt = 5000,
                        plot = FALSE, solver = "ode", verbose.mcmc = FALSE)

#Simulate using the R model and the samples from the inference on it
post_traj <- post_sim(mcmc_samples, n=100, times=0:58, burnin=iter*0.5,
                      output = 'all', prob = 0.95)
