%%
basename = 'fitCurveVsDurByCoh';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', [basename '-' subj '-' param '.' fig_ext]);

%%

sz = 100;
lw1 = 2.0;
lw2 = 3.0;
lw3 = 3.0;
dotmodes = {'2d', '3d'};
cmap = {[0 0.8 0], [0.9 0 0]};

%%

fig = figure; clf; hold on;

is2d = strcmp(data.params.dotmode, '2d');
is3d = strcmp(data.params.dotmode, '3d');
vals = data.params.(param);
xs = vals(is2d);
ys = vals(is3d);
cohs = data.params.coh(is2d);

pts = [xs ys cohs];
pts = sortrows(pts, 3);
colors = gray(numel(cohs));
for i = 1:numel(cohs)
    col = colors(numel(cohs)-i+1,:);
    coh = pts(i,3);
    lbl = sprintf('%.0f%%', coh*100);
    scatter(pts(i,1), pts(i,2), sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', col, 'LineWidth', lw1, 'DisplayName', lbl);
end
legend('Location', 'NorthWest');
if strcmp(param, 'A')
    title('saturation accuracy');
    xlabel('2d saturation %');
    ylabel('3d saturation %');
    xlim([0.5, 1.0]);
    ylim([0.5, 1.0]);
    plot([0.5, 1.0], [0.5, 1.0], '--', 'Color', 'k', 'LineWidth', lw3, 'HandleVisibility', 'off');
    set(gca, 'XTick', [0.5, 0.75, 1.0]);
    set(gca, 'XTickLabel', {'50', '75', '100'});
    set(gca, 'YTick', [0.5, 0.75, 1.0]);
    set(gca, 'YTickLabel', {'50', '75', '100'});
elseif strcmp(param, 'T')
    title('tau');
    xlabel('2d tau (msec)');
    ylabel('3d tau (msec)');
    xlim([0.0, 500]);
    ylim([0.0, 500]);
    plot([0.0, 500], [0.0, 500], '--', 'Color', 'k', 'LineWidth', lw3, 'HandleVisibility', 'off');
    set(gca, 'XTick', [0, 250, 500]);
%     set(gca, 'XTickLabel', {'0', '75', '100'});
    set(gca, 'YTick', [0, 250, 500]);
%     set(gca, 'YTickLabel', {'50', '75', '100'});
end
% set(gca,'XScale','log');

% set(gcf, 'PaperSize', [5 5]);
% set(gcf, 'PaperPosition', [0 0 5 5]);

plotFormats;
axis square;
print(fig, ['-d' fig_ext], outfile);
