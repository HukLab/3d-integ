%%
basename = 'pcorVsCohByDur_thresh_by_dotmode';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', [basename '-' subj '.' fig_ext]);

%%

sz = 100;
lw1 = 2;
lw2 = 3;
lw3 = 3;
cmap = colorSchemes('both');
dotmodes = {'2d', '3d'};

%%
    
fig = figure(1); clf; hold on;
set(gca, 'XScale', 'log');
title('Percent correct vs. motion coherence');
xlabel('% coherence');
ylabel('% correct');
plot([0.02, 0.7], [0.75, 0.75], '--', 'Color', 'k', 'LineWidth', lw3, 'HandleVisibility', 'off');

for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    xb = data.pts.x(i1);
    yb = data.pts.y(i1);
    ns = data.pts.ntrials(i1);   
    xf = linspace(min(xb), max(xb));

    scales = data.params.scale(i2);
    locs = data.params.loc(i2);
    threshes = data.params.thresh(i2);
    lapses = data.params.lapse(i2);
    
    % take first entry as mean (others are bootstrap)
    scale = scales(1);
    loc = locs(1);
    thresh = threshes(1);
    lapse = lapses(1);

    yf = 0.5 + (1 - 0.5 - lapse)*cdf('logistic', xf, loc, scale);
    
    lbl = dotmode;
    plot(xf, yf, '-', 'Color', cmap{i}, 'LineWidth', lw2, 'DisplayName', lbl);

    err = sqrt((yb.*(1-yb))./ns);
    errs = [err err];
%     errs = abs(pcorBootstrap(xb, yb, ns) - repmat(yb, 1, 2));
    errorbar(xb, yb, errs(:,1), errs(:,2), 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
    
    scatter(xb, yb, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{i}, 'LineWidth', lw1, 'HandleVisibility', 'off');
    plot([thresh, thresh], [0.5, 0.75], '--', 'Color', cmap{i}, 'LineWidth', lw3, 'HandleVisibility', 'off');
    
    % '\leftarrow '
    text(thresh, 0.52, ['  ' sprintf('%.0f%%', thresh*100)], 'FontSize', 14, 'FontWeight', 'bold');
end

set(gca, 'XTick', [1e-2, 1e-1, 0.5]);
set(gca, 'XTickLabel', {'1', '10', '50'});
set(gca, 'YTick', [0.5, 0.75, 1.0]);
set(gca, 'YTickLabel', {'50', '75', '100'});
xlim([0.02, 0.7]);
ylim([0.5 1.0]);
text(0.05, 0.85, 'N=5');
legend('Location', 'NorthWest');
plotFormats;
print(fig, ['-d' fig_ext], outfile);
