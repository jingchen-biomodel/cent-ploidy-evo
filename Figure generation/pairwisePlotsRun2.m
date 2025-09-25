
clear; clc; close all;

% Generates Figure 3D

load('tetraploidData.mat')
param = finpar;

% effective birth rates
be2n2c = param(:,1)-param(:,7);
be2n4c = param(:,2)-param(:,8);
be4n2cS = param(:,3)-param(:,9);
be4n2cL = param(:,4)-param(:,10);
be4n4c = param(:,5)-param(:,11);
be4nSC = param(:,6)-param(:,12);

effectiveList = [be2n2c, be2n4c, be4n2cS, be4n2cL, be4n4c, be4nSC];
combos = nchoosek(1:size(effectiveList,2),2);

covlist = zeros(length(combos),1);

for jj = 1:length(combos)

    covtemp = corrcoef(effectiveList(:,combos(jj,1)),effectiveList(:,combos(jj,2)));
    covlist(jj) = covtemp(1,2);
    clear covtemp
end

covlist = [abs(covlist), combos];
[~, sortIdx] = sort(covlist(:,1), 'descend');
covlist = covlist(sortIdx,:);

figure(1)
subplot(2,2,1)
scatter(effectiveList(:,1),effectiveList(:,5))
hold on
plot([0 1.5],[0 1.5],'LineWidth',2)
xlabel('be2N2C')
ylabel('be4N4C')
title(sprintf('r = %f',covlist(7,1)))
subplot(2,2,2)
scatter(effectiveList(:,1),effectiveList(:,3))
hold on
plot([0 1.5],[0 1.5],'LineWidth',2)
xlabel('be2N2C')
ylabel('be4N2Cs')
title(sprintf('r = %f',covlist(1,1)))
subplot(2,2,3)
scatter(effectiveList(:,1),effectiveList(:,4))
hold on
plot([0 1.5],[0 1.5],'LineWidth',2)
xlabel('be2N2C')
ylabel('be4N2Cl')
title(sprintf('r = %f',covlist(3,1)))
subplot(2,2,4)
scatter(effectiveList(:,3),effectiveList(:,4))
hold on
plot([0 1.5],[0 1.5],'LineWidth',2)
xlabel('be4N2Cs')
ylabel('be4N2Cl')
title(sprintf('r = %f',covlist(2,1)))
fontsize(14,"points")
fontname("SansSerif")
set(gcf,'units','centimeters','position',[0 0 25 25])
