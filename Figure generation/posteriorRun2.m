
clear; clc; close all;

% Generates Figure 3C
% Generates Figure S3

set(0, 'DefaultLineLineWidth', 2);
load('tetraploidData.mat')
param = finpar;

titles = {"b2N2C","b2N4C","b4N2Cs","b4N2Cl","b4N4Cl","b4N4Cs",...
    "d2N2C","d2N4C","d4N2Cs","d4N2Cl","d4N4Cl","d4N4Cs","dNP",...
    "pBi","pSym","pCyto","pOver","pSCsym"};

lb = [0.6,0.6,0.6,0.4,0.4,0.6,  0,  0,0,0,0,0,0,0.3,0.3,  0,  0,0.5];
ub = [1.6,1.4,1.4,1.4,1.4,1.4,1.5,1.5,2,2,2,2,3,0.9,0.8,0.1,0.2,  1];

% control values from Table S1
ctrl = [1.39,1.35,1.39,1.277,1.277,1.39,0.248,0.499,0.248,0.285,0.591,0.248,2,0.6,0.4,0.024,0.0001,0.939];

figure(1)
for ii = 1:length(titles)
    subplot(5,4,ii)
    hold on
    [fi,xi] = ksdensity(param(:,ii));
    plot(xi,fi,'Color','k')
    pd = makedist('Uniform','lower',lb(ii),'upper',ub(ii));
    xs = lb(ii):0.01:ub(ii);
    ys = pdf(pd,xs);
    plot(xs,ys,'Color','r')
    line([lb(ii) lb(ii)],[0 1/(ub(ii)-lb(ii))],'Color','r')
    line([ub(ii) ub(ii)], [0 1/(ub(ii)-lb(ii))],'Color','r')
    xline(ctrl(ii),'--b','LineWidth',1.5)
    xlabel('T')
    ylabel('P(T|X)')
    title(titles{ii})
end 
fontsize(14,"points")
fontname("SansSerif")

figure(2)
subplot(2,2,1)
hold on
[fO, xO] = ksdensity(param(:,17));
plot(xO,fO,'Color','k')
pdO = makedist('Uniform','lower',0,'upper',0.2);
xsO = 0:0.01:0.2;
ysO = pdf(pdO,xsO);
plot(xsO,ysO,'Color','r')
line([0 0],[0 5],'Color','r')
line([0.2 0.2], [0 5],'Color','r')
xline(0.0001,'--b','LineWidth',1.5)
xlim([-0.02 0.2])
xlabel('T')
ylabel('P(T|X)')
title('pOver')

subplot(2,2,2)
hold on
[fS, xS] = ksdensity(param(:,16));
plot(xS,fS,'Color','k')
pdS = makedist('Uniform','lower',0,'upper',0.1);
xsS = 0:0.001:0.1;
ysS = pdf(pdS,xsS);
plot(xsS,ysS,'Color','r')
line([0 0],[0 10],'Color','r')
line([0.1 0.1], [0 10],'Color','r')
xline(0.024,'--b','LineWidth',1.5)
xlabel('T')
ylabel('P(T|X)')
title('pCyto')

subplot(2,2,3)
hold on
[fS, xS] = ksdensity(param(:,15).*param(:,14));
plot(xS,fS,'Color','k')
pdS = makedist('Uniform','lower',0.3*0.3,'upper',0.8*0.9);
xsS = 0.3*0.3:0.01:0.8*0.9;
ysS = pdf(pdS,xsS);
plot(xsS,ysS,'Color','r')
line([0.3*0.3 0.3*0.3],[0 1/(0.8*0.9-0.3*0.3)],'Color','r')
line([0.8*0.9 0.8*0.9], [0 1/(0.8*0.9-0.3*0.3)],'Color','r')
xline(0.4*0.6,'--b','LineWidth',1.5)
xlabel('T')
ylabel('P(T|X)')
title('pBi*pSym')

subplot(2,2,4)
hold on
[fC, xC] = ksdensity(param(:,18));
plot(xC,fC,'Color','k')
pdC = makedist('Uniform','lower',0.5,'upper',1);
xsC = 0.5:0.01:1;
ysC = pdf(pdC,xsC);
plot(xsC,ysC,'Color','r')
line([0.5 0.5],[0 2],'Color','r')
line([1 1], [0 2],'Color','r')
xline(0.939,'--b','LineWidth',1.5)
xlabel('T')
ylabel('P(T|X)')
title('pSCsym')

fontsize(14,"points")
fontname("SansSerif")
