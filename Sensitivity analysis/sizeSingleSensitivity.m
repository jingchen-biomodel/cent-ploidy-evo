
% sizeSingleSensitivity.m
% Single Parameter sensitivity analysis of the Size Ploidy Model
% By Nicholas Keen
% Last edit: 9/25/2025
% Generates Figure S7

clear; clc; close all;
set(0, 'DefaultLineLineWidth', 2);

func = @sensitivityModelSize;

%      { b2n2c,  b2n4c, b4n2cs, b4n2cl,  b4n4c,  b4nSC,  d2n2c,  d2n4c, d4n2cs, d4n2cl,  d4n4c,  d4nSC,   dNP,    pBi,   pSym,  pCyto,  pOver,    pSC, pSCsym};
par0 = [1.3164, 1.2909, 1.3135, 1.1743, 1.1739, 1.3163, 0.1535, 0.3463, 0.1539, 0.1745, 0.3475, 0.1536, 1.999, 0.5999, 0.4001, 0.0273, 0.0001, 0.3341, 0.9340];

%% Parameter set up for running sensitivity analysis

% logspace(-2, 2, 20)

p0.b2n2c                    = par0(1);                              % b2n2c, birth rate, ~ 1.2 per day
Plist.b2n2c.val             = 0:0.05:3;
Plist.b2n2c.xlabel          = 'b2N2C (d^{-1})';
p0.b2n4c                    = par0(2);                              % b2n4c, birth rate
Plist.b2n4c.val             = 0:0.05:3; % could limit bx to >= b2n2c...
Plist.b2n4c.xlabel          = 'b2N4C (d^{-1})';
p0.b4n2cs                   = par0(3);                              % b4n2c small, birth rate
Plist.b4n2cs.val            = 0:0.05:3;
Plist.b4n2cs.xlabel         = 'b4N2Cs (d^{-1})';
p0.b4n2cl                   = par0(4);                              % b4n2c large, birth rate
Plist.b4n2cl.val            = 0:0.05:3;
Plist.b4n2cl.xlabel         = 'b4N2Cl (d^{-1})';
p0.b4n4c                    = par0(5);                              % b4n4c, birth rate 
Plist.b4n4c.val             = 0:0.05:3;
Plist.b4n4c.xlabel          = 'b4N4Cl (d^{-1})';
p0.b4nSC                    = par0(6);                              % b4nSC, birth rate 
Plist.b4nSC.val             = 0:0.05:3;
Plist.b4nSC.xlabel          = 'b4N4Cs (d^{-1})';

p0.d2n2c                    = par0(7);                              % d2n2c, death rate
Plist.d2n2c.val             = 0:0.05:3;
Plist.d2n2c.xlabel          = 'd2N2C (d^{-1})';
p0.d2n4c                    = par0(8);                              % d2n4c, death rate
Plist.d2n4c.val             = 0:0.05:3;
Plist.d2n4c.xlabel          = 'd2N4C (d^{-1})';
p0.d4n2cs                   = par0(9);                              % d4n2c large, death rate
Plist.d4n2cs.val            = 0:0.05:3;
Plist.d4n2cs.xlabel         = 'd4N2Cs (d^{-1})';
p0.d4n2cl                   = par0(10);                             % d4n2c large, death rate
Plist.d4n2cl.val            = 0:0.05:3;
Plist.d4n2cl.xlabel         = 'd4N2Cl (d^{-1})';
p0.d4n4c                    = par0(11);                              % d4n4c, death rate
Plist.d4n4c.val             = 0:0.05:3;
Plist.d4n4c.xlabel          = 'd4N4Cl (d^{-1})';
p0.d4nSC                    = par0(12);                             % d4nSC, death rate
Plist.d4nSC.val             = 0:0.05:3;
Plist.d4nSC.xlabel          = 'd4N4Cs (d^{-1})';
p0.dNP                      = par0(13);                             % dNP, death rate
Plist.dNP.val               = 0:0.05:3;
Plist.dNP.xlabel            = 'dNP (d^{-1})';

p0.pBi                      = par0(14);                              % pBi, probability of bipolar division
Plist.pBi.val               = 0:0.01:1;
Plist.pBi.xlabel            = 'pBi';
p0.pSym                     = par0(15);                             % pSym, probability of symmetric division
Plist.pSym.val              = 0:0.01:1;
Plist.pSym.xlabel           = 'pSym';
p0.pCyto                    = par0(16);                              % pCyto, probability of cytokinesis failure
Plist.pCyto.val             = 0:0.01:0.2;
Plist.pCyto.xlabel          = 'pCyto';
p0.pOver                    = par0(17);                             % pOver, probability of centrosome overduplication
Plist.pOver.val             = 0:0.01:0.2;
Plist.pOver.xlabel          = 'pOver';
p0.pSC                      = par0(18);                             % pSC, probability of SC from cytokinesis failure
Plist.pSC.val               = 0:0.01:1;
Plist.pSC.xlabel            = 'pSC';
p0.pSCsym                   = par0(19);                             % pSCsym, probability of SC symmetric division
Plist.pSCsym.val            = 0:0.01:0.99;
Plist.pSCsym.xlabel         = 'pSCsym';

fields                      = fieldnames(Plist);

%% Control results value

res0 = func(p0);
hl0 = res0(1); ss0 = res0(2);

%% Sensitivity analysis

for qq = 1:length(fields)
    clear hl ss par

    par = p0;

    for ii = 1:length(Plist.(fields{qq}).val)
        par.(fields{qq}) = Plist.(fields{qq}).val(ii);
        res = func(par);
        hl(ii) = res(1); ss(ii) = res(2);
        clear res
    end
    
    figure(1)
    subplot(4,5,qq)
    plot(Plist.(fields{qq}).val, hl, 'k');
    hold on
    plot(par0(qq), hl0, 'k*');
    xlabel(Plist.(fields{qq}).xlabel);
    ylabel('EC half life')
    box off
    fontsize(12,"points")
    fontname("SansSerif")

    figure(2)
    subplot(4,5,qq)
    plot(Plist.(fields{qq}).val, ss, 'k');
    hold on
    plot(par0(qq), ss0, 'k*');
    xlabel(Plist.(fields{qq}).xlabel);
    ylabel('EC steady state')
    box off
    fontsize(12,"points")
    fontname("SansSerif")
end
