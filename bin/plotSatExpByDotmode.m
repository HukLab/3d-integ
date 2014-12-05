%%
basename = 'pcorVsDurByDotmode';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', ['satExpByDotmode' '-' subj '.' fig_ext]);

%%

sz = 100;
lw1 = 2;
lw2 = 6;
lw3 = 3;
x_delay = 0; % (ms)
cmap = colorSchemes('both');
dotmodes = {'2d', '3d'};

%%

fig = figure(1); clf; hold on;
set(gca, 'XScale', 'log');
% title('Percent correct vs. duration (msec)');
xlabel('Duration (msec)');
ylabel('% Correct');

vrts = [];
dots = [];
crvs = [];
ebrs = [];

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
    ns = data.pts.ntrials(is_bin & i1);
    xf = data.pts.xs(is_fit & i1);
    yf = data.pts.ys(is_fit & i1);
    
    T = data.params.T(i2);
    Ts(i) = T;
    
    err = sqrt((yb.*(1-yb))./ns);
    errs = [err err];
%     errs = abs(pcorBootstrap(xb, yb, ns) - repmat(yb, 1, 2));
    ebr = errorbar(xb, yb, errs(:,1), errs(:,2), 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
    errorbar_tick(ebr, 0);
    
    lbl = dotmode;
%     vrt = plot([T, T], [0.4, 1.0], '--', 'Color', cmap{i}, 'LineWidth', lw3, 'HandleVisibility', 'off');
    crv = plot(xf, yf, '-', 'Color', cmap{i}, 'LineWidth', lw2, 'DisplayName', lbl);
    dts = scatter(xb, yb, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{i}, 'LineWidth', lw1, 'HandleVisibility', 'off');

    ebrs = [ebrs; ebr];
    dots = [dots; dts];
%     vrts = [vrts; vrt];
    crvs = [crvs; crv];
end
% for ii = 1:numel(Ts)
%     T = Ts(ii);
%     text(T, 0.55 - (ii-1)*0.05, ['\rightarrow ' sprintf('%.0f', T) ' msec' ], 'FontSize', 14, 'FontWeight', 'bold');
% end

crvs = crvs(end:-1:1);
uistack(dots, 'bottom');
uistack(ebrs, 'bottom');
uistack(crvs, 'bottom');
% uistack(vrts, 'bottom');

set(gca, 'XTick', [33, 200, 1000, 6000]);
set(gca, 'XTickLabel', {'33', '200', '1000', '6000'});
set(gca, 'YTick', [0.5, 0.75, 1.0]);
set(gca, 'YTickLabel', {'50', '75', '100'});
legend('Location', 'NorthWest');
xlim([floor(min(data.pts.xs)), 6000]);
ylim([0.45 1.0]);
plotFormats;
print(fig, ['-d' fig_ext], outfile);
