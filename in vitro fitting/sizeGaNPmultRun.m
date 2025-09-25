
clear; clc; close all;

parpool('AttachedFiles',{'sizeGaNP.m','sizeGaNPfit.m'})

numitrs = 30;
theta = zeros(numitrs,19);
fval = zeros(numitrs,1);

for ii = 1:numitrs
    tic
    [theta(ii,:), fval(ii)] = sizeGaNP();
    toc
    fprintf('itr %d complete \n',ii)
end

save("gaThetasSize.mat","theta");
save("fvalSize.mat","fval")
