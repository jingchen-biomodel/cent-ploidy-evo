
clear; clc; close all;

% Generates box plots for each fitted parameter (figure S2)
% Generates Figure 3B

load('gaThetasSize.mat')
load('fvalSize.mat')

xlabsBirths = {"b2N2C";"b2N4C";"b4N2Cs";"b4N2Cl";"b4N4C";"b4NSC"};
xlabsDeaths = {"d2N2C";"d2N4C";"d4N2Cs";"d4N2Cl";"d4N4C";"d4NSC";"dNP"};
xlabsProbs = {"pBi";"pSym";"pCyto";"pOver";"pSC";"pSCsym"};

figure(1)
boxchart(theta(:,1:6))
title('Model birth rates')
xticklabels(xlabsBirths)
fontsize(12,"points")
fontname("SansSerif")

figure(2)
boxchart(theta(:,7:13))
title('Model death rates')
xticklabels(xlabsDeaths)
fontsize(12,"points")
fontname("SansSerif")

figure(3)
boxchart(theta(:,1:6)-theta(:,7:12))
title('Model effective birth rates')
xticklabels(xlabsBirths)
fontsize(12,"points")
fontname("SansSerif")

figure(4)
boxchart(theta(:,14:19))
title('Model probabilities')
xticklabels(xlabsProbs)
fontsize(12,"points")
fontname("SansSerif")

figure(5)
boxchart(fval)
title('Cost of hybrid GA output')
fontsize(12,"points")
fontname("SansSerif")
ylabel("Cost")
xticklabels({""})

medThetas = median(theta);
trange = linspace(0,12,1000); % time points model data is collected at
[~,Cfit,sol] = sizeGaNPfit(medThetas,trange);
centData = [1-0.9004, 0.9004;
            1-0.485,  0.485;
            1-0.4079, 0.4079;
            1-0.3165, 0.3165;
            1-0.26,   0.26;
            1-0.202,  0.202;
            1-0.1625, 0.1625];

figure(6)
plot([0 2 4 6 8 10 12], centData, 'p','MarkerSize',10)
hold on
set(gca,'ColorOrderIndex',1)
plot(trange, Cfit, 'LineWidth',2);
grid
xlim([0 12])
ylim([0 1])
xlabel('Time (d)')
ylabel('Fraction of Population')
plot(sol.x,sol.y,'LineWidth',1.5,'LineStyle','--');
legend('2C data','EC data','2C fit','EC fit','2N2C','2N4C','4N2Cs','4N2Cl','4N4C','4NSC','NP')
fontsize(12,"points")
fontname("SansSerif")
