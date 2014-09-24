%%
basename = 'pcorVsDurByCoh';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', ['satExpParams2d3d' '-' subj '-' param '.' fig_ext]);

%%

sz = 100;
lw1 = 2.0;
lw2 = 3.0;
lw3 = 3.0;
dotmodes = {'2d', '3d'};
cmap = colorSchemes('both');

%%

fig = figure; clf; hold on;

is2d = strcmp(data.params.dotmode, '2d');
is3d = strcmp(data.params.dotmode, '3d');
vals = data.params.(param);
xs = vals(is2d);
ys = vals(is3d);
cohs2d = data.params.coh(is2d);
cohs3d = data.params.coh(is3d);
pts2d = sortrows([cohs2d xs], 1);
pts3d = sortrows([cohs3d ys], 1);
assert(isequal(pts2d(:,1), pts3d(:,1)));

% [ys, errsY] = grpstats(ys, cohs, {'mean', 'std'});
% [xs, errsX] = grpstats(xs, cohs, {'mean', 'std'});
% cohs = unique(cohs);
% pts = [xs ys cohs errsX errsY];

cohs = sort(cohs2d);
colors = gray(numel(cohs));
cohsSeen = [];
for i = 1:numel(cohs)
    col = colors(numel(cohs)-i+1,:);
    coh = cohs(i);
    lbl = sprintf('%.0f%%', coh*100);
    if ~any(cohsSeen == coh)
        cohsSeen = [cohsSeen; coh];
        vis = 'on';
    else
        vis = 'off';
    end
    scatter(pts2d(i,2), pts3d(i,2), sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', col, 'LineWidth', lw1, 'DisplayName', lbl, 'HandleVisibility', vis);
%     h = errorbar(pts(i,1), pts(i,2), pts(i,5), pts(i,5), 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
%     herrorbar(pts(i,1), pts(i,2), pts(i,4), pts(i,4));%, 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
end

if strcmp(param, 'A')
    title('saturation accuracy');
    xlabel('saturation accuracy %');
    ylabel('saturation accuracy %');
    xlim([0.5, 1.0]);
    ylim([0.5, 1.0]);
    ln = plot([0.5, 1.0], [0.5, 1.0], '--', 'Color', 'k', 'LineWidth', lw3, 'HandleVisibility', 'off');
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
    ln = plot([0.0, 500], [0.0, 500], '--', 'Color', 'k', 'LineWidth', lw3, 'HandleVisibility', 'off');
    set(gca, 'XTick', [0, 250, 500]);
%     set(gca, 'XTickLabel', {'0', '75', '100'});
    set(gca, 'YTick', [0, 250, 500]);
%     set(gca, 'YTickLabel', {'50', '75', '100'});
end
uistack(ln, 'bottom');
% set(gca,'XScale','log');

% set(gcf, 'PaperSize', [5 5]);
% set(gcf, 'PaperPosition', [0 0 5 5]);
legend('Location', 'NorthWest');
plotFormats;
axis square;
print(fig, ['-d' fig_ext], outfile);
