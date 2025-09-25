# cent-ploidy-evo

All code used in 'Oxidative stress and serum deprivation influence the evolution of newly formed tetraploid cells during tumorigenesis' by Sweet, Bloomfield, et al., PNAS (in press). The code was developed primarily by Nicholas Keen, supervised by Jing Chen.

**_in vitro_ fitting:**
Contains the MATLAB codes needed to perform Genetic Algorithm fitting of the _in vitro_ data in (Baudoin, 2020) to our model

_in vivo_ inference:
Contains the R codes needed to perform Bayesian Inference with deBInfer (Boersch-Supan, 2017) with the tumor data generated in this paper

Required packages:
- deBInfer
- deSolve
- coda
- R.matlab

**Sensitivity analysis:**
Contains the MATLAB codes needed to perform Sobol index analysis and one-at-a-time sensitivity analysis on our model
Sobol code was adapted with permission from (Yao 2021)

**Figure generation:**
Contains the MATLAB codes needed to generate Figures 3B, 3C, 3D, S2, S3.

Figures S6 and S7 are generated in their respective codes, which are found in the Sensitivity Analysis folder

**Raw data:**
Contains the individual output files of each Bayesian Inference run

**References**

Baudoin, N.C., et al., Asymmetric clustering of centrosomes defines the early evolution of tetraploid cells. Elife, 2020. 9: p. e54565.

Boersch‐Supan, P.H., S.J. Ryan, and L.R. Johnson, deBInfer: Bayesian inference for dynamical models of biological systems in R. Methods in Ecology and Evolution, 2017. 8(4): p. 511-518.

Yao, X., S. Kojima, and J. Chen, Critical role of deadenylation in regulating poly(A) rhythms and circadian gene expression. PLOS Computational Biology, 2020. 16(4): p. e1007842.
