% sizeModelRun.m
% By Nicholas Keen
% Last edit: 9/25/2025
% Generates Figure S6

clear; clc; close all;

% Parameter distribution sample size
paramSize = 100000; % number of samples to take of each parameter

%% UNIFORM PARAMETER DISTRIBUTIONS
% Constraints pulled from intuition, measurement, & Baudoin et al., 2020

b2n2c = makedist('Uniform','lower',1,'upper',1.6);
% ratio (b2n2c*phi)
phi2n4c = makedist('Uniform','lower',0.5,'upper',1);
phi4n2cs = makedist('Uniform','lower',0.5,'upper',1);
phi4n2cl = makedist('Uniform','lower',0.4,'upper',0.9);
phi4n4c = makedist('Uniform','lower',0.4,'upper',0.8);
phi4nSC = makedist('Uniform','lower',0.4,'upper',0.9);

d2n2c = makedist('Uniform','lower',0,'upper',0.2);
d2n4c = makedist('Uniform','lower',0,'upper',0.2);
d4n2cs = makedist('Uniform','lower',0,'upper',0.2);
d4n2cl = makedist('Uniform','lower',0.1,'upper',0.4);
d4n4c = makedist('Uniform','lower',0.1,'upper',0.6);
d4nSC = makedist('Uniform','lower',0,'upper',0.2);
dNP   = makedist('Uniform','lower',0.5,'upper',2);

pBi = makedist('Uniform','lower',0.2,'upper',0.8); % bipolar div w/ ECs
pSym = makedist('Uniform','lower',0.2,'upper',0.6); % sym div w/ ECs
pCyto = makedist('Uniform','lower',0,'upper',0.1); % cyto failure in 2N
pOver = makedist('Uniform','lower',0,'upper',0.05); % overduplication
pSC = makedist('Uniform','lower',0.1,'upper',0.6); % SC from cyto failure
pSCsym = makedist('Uniform','lower',0.6,'upper',0.95); % SC sym div

%% Parameter List for Sobol

params = {b2n2c,phi2n4c,phi4n2cs,phi4n2cl,phi4n4c,phi4nSC,d2n2c,d2n4c,...
    d4n2cs,d4n2cl,d4n4c,d4nSC,dNP,pBi,pSym,pCyto,pOver,pSC,pSCsym};

%% call Sobol
numParams = size(params,2);
numResults = 2; % time til 50% pop has EC; ss frac EC
sobolFormula = 1; % 1 = saltelli, 2 = jansen

tStart = tic;
disp('Started running Ploidy_Sobol_Model');
[S1,ST] = Saltelli_estimator(@sobolModelSize,params,numParams,numResults,sobolFormula,paramSize);
tEnd = toc(tStart);
fprintf('The run took %s \n', duration([0, 0, tEnd]));

save("S1.mat","S1")
save("ST.mat","ST")

%% plot results
figset = SobolPlot(S1,ST);
xlabs = {"b2N2C";"b2N4C";"b4N2Cs";"b4N2Cl";"b4N4Cl";"b4N4Cs";"d2N2C";"d2N4C";"d4N2Cs";"d4N2Cl";"d4N4Cl";"d4N4Cs";"dNP";"pBi";"pCyto";"pSym";"pOver";"pSC";"pSCsym"};

% Generate figures
figure(figset(1))
title('EC Half Life')
set(gca,'xtick',1:length(xlabs))
set(gca,'xticklabel',xlabs); % parameter labels
figure(figset(2))
title('Steady State Fraction')
set(gca,'xtick',1:length(xlabs))
set(gca,'xticklabel',xlabs);
