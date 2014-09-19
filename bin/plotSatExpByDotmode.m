%%
basename = 'pcorVsDurByCoh';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', [basename '-' subj '.' fig_ext]);

%%

sz = 100;
lw1 = 2.0;
lw2 = 3.0;
lw3 = 3.0;
x_delay = 0; % (ms)
cmap = colorSchemes('both');
dotmodes = {'2d', '3d'};

%%

fig = figure(1); clf; hold on;
set(gca, 'XScale', 'log');
title('Percent correct vs. duration (ms)');
xlabel('duration (ms)');
ylabel('% correct');

Ts = zeros(length(dotmodes), 1);
for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    is_bin = strcmp(data.pts.is_bin_or_fit, 'bin');
    is_fit = strcmp(data.pts.is_bin_or_fit, 'fit');
    xb = data.pts.xs(is_bin & i1);
    yb = data.pts.ys(is_bin & i1);
    xf = data.pts.xs(is_fit & i1);
    yf = data.pts.ys(is_fit & i1);
    
    T = data.params.T(i2);
    Ts(i) = T;
    
    lbl = dotmode;
    plot([T, T], [0.4, 1.0], '--', 'Color', cmap{i}, 'LineWidth', lw3, 'HandleVisibility', 'off');
    plot(xf, yf, '-', 'Color', cmap{i}, 'LineWidth', lw2, 'DisplayName', lbl);
    scatter(xb, yb, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{i}, 'LineWidth', lw1, 'HandleVisibility', 'off');
end
for ii = 1:numel(Ts)
    T = Ts(ii);
    text(T, 0.55 - (ii-1)*0.05, ['\rightarrow ' sprintf('%.0f', T) ' msec' ], 'FontSize', 14, 'FontWeight', 'bold');
end

set(gca, 'XTick', [10, 100, 1000]);
set(gca, 'XTickLabel', {'10', '100', '1000'});
set(gca, 'YTick', [0.5, 0.75, 1.0]);
set(gca, 'YTickLabel', {'50', '75', '100'});
legend('Location', 'NorthWest');
plotFormats;
print(fig, ['-d' fig_ext], outfile);
