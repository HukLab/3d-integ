%%
basename = 'sensVsDurSlopes';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', ['decisionSlope' '-' subj '.' fig_ext]);

%%

fig = figure(1); clf; hold on;
sz = 15;
lw1 = 2;
lw2 = 3;

subjs = unique(data.params.subj);
dotmodes = {'2d', '3d'};
cmap = hsv(numel(subjs));

pts = [];
crs = [];
for ii = 1:numel(subjs)
    sbj = subjs(ii);
    for jj = 1:numel(dotmodes)
        dm = dotmodes{jj};
        inds = strcmp(data.params.subj, sbj) & strcmp(data.params.dotmode, dm);
        slopes.(['lb' dm]) = data.params.lb(inds);
        slopes.(['ub' dm]) = data.params.ub(inds);
        slopes.(['md' dm]) = data.params.med(inds);
%         xs = prctile(slopes, [0.5-delta 0.5 0.5+delta]);
%         lb.(['d' dm]) = xs(1);
%         med.(['d' dm]) = xs(2);
%         ub.(['d' dm]) = xs(3);
    end
    
    lb2d = slopes.lb2d;
    ub2d = slopes.ub2d;
    md2d = slopes.md2d;
    lb3d = slopes.lb3d;
    ub3d = slopes.ub3d;
    md3d = slopes.md3d;
    
    pt = plot(md2d, md3d, 'o', 'MarkerSize', sz, 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', cmap(ii,:), 'LineWidth', lw1, ...
        'DisplayName', sbj);
    crs = [crs pt];
    cr = plot([lb2d ub2d], [md3d md3d], 'Color', cmap(ii,:), ...
        'LineWidth', lw2, 'HandleVisibility', 'off');
    crs = [crs cr];
    cr = plot([md2d md2d], [lb3d ub3d], 'Color', cmap(ii,:), ...
        'LineWidth', lw2, 'HandleVisibility', 'off');
    crs = [crs cr];
    
%     pts = [pts pt];
end
ln = plot([0 1], [0 1], '--', 'LineWidth', lw1, 'Color', 'k', ...
    'HandleVisibility', 'off');
uistack(pts, 'bottom');
uistack(crs, 'bottom');
uistack(ln, 'bottom');

xlabel('2d');
ylabel('3d');
leg = legend('Location', 'NorthWest');
plotFormats;
print(fig, ['-d' fig_ext], outfile);
