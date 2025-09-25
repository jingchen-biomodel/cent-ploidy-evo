
function [theta,fval] = sizeGaNP()
% Updated 9/25/25

% ASSUMPTIONS
% S cells are very close to 2N levels, and cluster efficiently (4Cs)
% L clones are much slower, but can compete over time (4Cl)
% 4Cs cells are a bit less restricted now, and can match 2N2C cells
% When 4Cs cells divide asymmetrically, they make a 4N2Cs population

trange = [0 2 4 6 8 10 12]; % time points data is collected at
% [ b2n2c, b2n4c, b4n2cs, b4n2cl, b4n4c, b4nSC, d2n2c, d2n4c, d4n2cs, d4n2cl, d4n4c, d4nSC, dNP, pBi, pSym, pCyto, pOver, pSC, pSCsym];
lb = [  1,     1,      1,    0.7,   0.7,     1,     0,      0,     0,      0,   0.1,     0, 0.5, 0.3,  0.4,  0.01,     0, 0.1,    0.5]; % lower bounds
ub = [1.5,   1.5,    1.5,    1.3,   1.3,   1.5,   0.5,    0.5,     1,      1,     1,     1,   2, 0.6,  0.7, 0.028, 0.005, 0.6,   0.98]; % upper bounds

A = [  -1      1       0       0      0      0      0       0      0       0      0      0    0    0     0      0      0    0       0;  % b2n4c  <= b2n2c
       -1      0       1       0      0      0      0       0      0       0      0      0    0    0     0      0      0    0       0;  % b4n2cs <= b2n2c
        0      0      -1       1      0      0      0       0      0       0      0      0    0    0     0      0      0    0       0;  % b4n2cl <= b4n2cs
        0      0       0      -1      1      0      0       0      0       0      0      0    0    0     0      0      0    0       0;  % b4n4c  <= b4n2cl
        0     -1       0       0      1      0      0       0      0       0      0      0    0    0     0      0      0    0       0;  % b4n4c  <= b2n4c
       -1      0       0       0      0      1      0       0      0       0      0      0    0    0     0      0      0    0       0;  % b4nSC  <= b2n2c
        0      0       0       0      0      0      1      -1      0       0      0      0    0    0     0      0      0    0       0;  % d2n4c  <= d2n2c
        0      0       0       0      0      0      1       0     -1       0      0      0    0    0     0      0      0    0       0;  % d4n2cs <= d2n2c
        0      0       0       0      0      0      0       0      1      -1      0      0    0    0     0      0      0    0       0;  % d4n2cl <= d4n2cs
        0      0       0       0      0      0      0       0      0       1     -1      0    0    0     0      0      0    0       0;  % d4n4c  <= d4n2cl
        0      0       0       0      0      0      0       1      0       0     -1      0    0    0     0      0      0    0       0;  % d4n4c  <= d2n4c
        0      0       0       0      0      0      1       0      0       0      0     -1    0    0     0      0      0    0       0;  % d4nSC  <= d2n2c
        1      0       0       0      0      0     -1       0      0       0      0      0    0    0     0      0      0    0       0;  % b2n2c - d2n2c <= 1.2
       -1      0       0       0      0      0      1       0      0       0      0      0    0    0     0      0      0    0       0;  % d2n2c - b2n2c <= -1.14
        0      0       1       0      0      0      0       0     -1       0      0      0    0    0     0      0      0    0       0;  % b4n2cs - d4n2cs <= 1.2
        0      0      -1       0      0      0      0       0      1       0      0      0    0    0     0      0      0    0       0;  % d4n2cs - b4n2cs <= -0.95
        0      0       0       1      0      0      0       0      0      -1      0      0    0    0     0      0      0    0       0;  % b4n2cl - d4n2cl <= 1
        0      0       0      -1      0      0      0       0      0       1      0      0    0    0     0      0      0    0       0;  % d4n2cl - b4n2cl <= -0.8
        0      0       0       0      1      0      0       0      0       0     -1      0    0    0     0      0      0    0       0;  % b4n4c - d4n4c <= 1
        0      0       0       0     -1      0      0       0      0       0      1      0    0    0     0      0      0    0       0]; % d4n4c - b4n4c <= -0.68

b = [0;0;0;0;0;0;0;0;0;0;0;0;1.2;-1.14;1.16;-0.95;1;-0.8;1;-0.68];

costGA = @(theta)sizeGaNPfit(theta,trange);
popSize = 500;
numParams = length(lb);
optsHybrid = optimoptions('fmincon','MaxIterations',1e4,'UseParallel',true);
optsGA = optimoptions('ga','PopulationSize',popSize, ...
    'EliteCount',20,'FunctionTolerance',1e-9, 'CreationFcn', ...
    'gacreationsobol','MaxStallGenerations',120, ...
    'ConstraintTolerance',1e-8,'MutationFcn','mutationadaptfeasible', ...
    'MaxGenerations',5E3,'UseParallel',true,'HybridFcn',{@fmincon,optsHybrid});

[theta,fval,~,~] = ga(costGA,numParams,A,b,[],[],lb,ub,[],[],optsGA);

end