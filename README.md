# SBcents

All code used in 'Oxidative stress and serum deprivation influence the evolution of newly formed tetraploid cells during tumorigenesis' by Sweet, Bloomfield, et al., PNAS (in press)

_in vitro_ fitting:
Contains the MATLAB codes needed to perform Genetic Algorithm fitting of the data in Baudoin et al., eLife, 2020 to our model

_in vivo_ inference:
Contains the R codes needed to perform Bayesian Inference with the tumor data generated in this paper
Required packages:
- deBinfer
- deSolve
- coda
- R.matlab

Sensitivity analysis:
Contains the MATLAB codes needed to perform Sobol index analysis and one-at-a-time sensitivity analysis on our model
Sobol code was adapted with permission from Yao et al, PLOS Comp Bio, 2021

Figure generation:
Contains the MATLAB codes needed to generate Figures 3B, 3C, 3D, S2, S3
Figures S6 and S7 are generated in their respective codes, which are found in the Sensitivity Analysis folder

Raw data:
Contains the individual output files of each Bayesian Inference run
