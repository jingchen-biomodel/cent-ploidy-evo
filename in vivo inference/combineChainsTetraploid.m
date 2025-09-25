
clear; clc; close all;

% combineChainsTetraploid.m
% combined all five chains from a single run of inference
% Removes burn-in (first 50% of each chain)
% Removes non-biological parameter sets (be<0, bS<bL)
% Then selects 2000 random parameter sets to be used

chains = {'run2Chain1Tetraploid.mat','run2Chain2Tetraploid.mat','run2Chain3Tetraploid.mat','run2Chain4Tetraploid.mat','run2Chain5Tetraploid.mat'};

finpar = [];

for ii = 1:5

    load(chains{ii});

    param = param(50001:end,1:18);

    rowdel = [];

    for qq = 1:50000

        if param(qq,1)-param(qq,7)<0 || param(qq,2)-param(qq,8)<0 || ...
                param(qq,3)-param(qq,9)<0 || param(qq,6)-param(qq,12)<0 || ...
                param(qq,4)-param(qq,10)<0 || param(qq,5) - param(qq,11) < 0

            rowdel = [rowdel, qq];
        end

        if param(qq,3)-param(qq,9)<param(qq,4)-param(qq,10) && ~ismember(qq, rowdel)
            rowdel = [rowdel, qq];
        end

    end

    param(rowdel,:) = [];
    finpar = [finpar; param];

end

chosen = randi([1 size(finpar,1)],[2000 1]);

finpar = finpar(chosen,:);

save('finpar','tetraploidData.mat')