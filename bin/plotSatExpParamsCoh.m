%%
basename = 'pcorVsDurByCoh';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', ['satExpParamsCoh' '-' subj '-' param '.' fig_ext]);

%%

sz = 100;
lw1 = 2.0;
lw2 = 3.0;
lw3 = 3.0;
dotmodes = {'2d', '3d'};
cmap = colorSchemes('both');

%%

fig = figure(i); clf; hold on;
xlabel('motion coherence');
if strcmp(param, 'A')
    title('saturation accuracy vs. motion coherence');
    ylabel('saturation accuracy %');
    ylim([0.45, 1.0]);
elseif strcmp(param, 'T')
    title('tau vs. motion coherence');
    ylabel('tau (ms)');
    ylim([0, 500]);
end
set(gca,'XScale','log');

for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    
    cohs = unique(data.params.coh);
    v_all = data.params.(param);
    v_all = v_all(i2);
    cohs_all = data.params.coh(i2);
    v0s = [];
    for ci = 1:length(cohs)
        coh = cohs(ci);
        v = v_all(cohs_all == coh);
        v0 = mean(v); 
        v0s = [v0s v0];
        er = std(v)/sqrt(numel(v));
        h = errorbar(coh, v0, er, er, 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
        errorbar_tick(h, 0);
        if ci == 1
            vis = 'on';
        else
            vis = 'off';
        end
        scatter(coh, v0, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{i}, 'LineWidth', lw1, 'DisplayName', dotmode, 'HandleVisibility', vis);
    end
    ls = plot(cohs, v0s, '-', 'Color', cmap{i}, 'LineWidth', lw2, 'HandleVisibility', 'off');
    uistack(ls, 'bottom');
end

% set(gcf, 'PaperSize', [5 5]);
% set(gcf, 'PaperPosition', [0 0 5 5]);
set(gca, 'XTick', [1e-2 1e-1 1]);
set(gca, 'XTickLabel', {'1', '10', '100'});
if strcmp(param, 'A')
    set(gca, 'YTick', [0.5, 0.75, 1.0]);
    set(gca, 'YTickLabel', {'50', '75', '100'});
    legend('Location', 'NorthWest');
elseif strcmp(param, 'T')
    set(gca, 'YTick', [0, 250, 500]);
    set(gca, 'YTickLabel', {'0', '250', '500'});
    legend('Location', 'NorthWest');
end
plotFormats;
print(fig, ['-d' fig_ext], outfile);
