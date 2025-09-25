
function figset = SobolPlot(S1,ST)
% From Yao et al., 2021

tmp = size(S1); % S1 is of size m by d, where m = # outputs, d =  # parameters
OutputNumber = tmp(1);
% plot single and total Sobol index for each output
figset = zeros(1,OutputNumber);
for i=1:OutputNumber
    figset(i) = figure(i);
    figure(i)
    single_index = S1(i,:);
    total_index = ST(i,:);

    plot_matrix = [single_index;total_index]';

    bar(plot_matrix);

    ylim([0 1])
    % lgnd = legend('\color{white} S','\color{white} T');
    lgnd = legend('S','T');
    yticks(0:.5:1)
    % set(lgnd, 'FontSize', 16)
    % set(gca,'FontSize',20)
    % set(gca, 'Color','k', 'XColor','w', 'YColor','w')
    % set(gcf, 'Color','k')
    % set(lgnd,'color','k')
    set(lgnd, 'Box', 'off');
end

end