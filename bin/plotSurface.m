%%
basename = 'pcor';
data = loadFiles(basename, subj);

isFineGrid = false; % specifies surface shading by %-cor (t) or data dim (f)
showDurData = false; % controls plotting of data points and lines for dur
showCohData = true; % controls plotting of data points and lines for coh
colorType = 'dur'; % if ~isFineGrid, data dimension for surface shading

outfile = fullfile('..', 'plots', ['surface' '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 1;
lw1 = 3;
lw2 = 2;
lw3 = 3;
maxDur = 6000;
nColors = 20;

%%

fig = figure(1); clf;
% title('motion threshold vs. duration (msec)');

ic = strcmp(data.pts.dotmode, dotmode);
xs = 100*data.pts.coh(ic);
ys = 1000*data.pts.dur(ic);
zs = data.pts.pc(ic);

% add extra data strip at maxDur, duplicating previous data
% xs1 = xs(ys == max(ys));
% zs1 = zs(ys == max(ys));
% xs = [xs; xs1];
% zs = [zs; zs1];
% ys = [ys; maxDur*ones(numel(xs1), 1)];

xlin = unique(xs);
ylin = unique(ys);
Nx = numel(xlin);
Ny = numel(ylin);

f = scatteredInterpolant(xs, ys, zs); % >= 2014a
if isFineGrid
    colormap(colorSchemes(dotmode, 'surf', 50));
    xlin = logspace(log10(min(xs)), log10(max(xs)), 200);
    ylin = logspace(log10(min(ys)), log10(max(ys)), 200);
    [X, Y] = meshgrid(xlin, ylin);
    Z = griddata(xs, ys, zs, X, Y, 'linear'); % < 2014a
%     Z = f(X, Y); % >= 2014a
    srf = surf(gca, X, Y, Z, 'EdgeColor', 'none');
else
    [X, Y] = meshgrid(xlin, ylin);
    Z = f(X, Y);
    switch colorType
        case 'dur'
            N = Ny;
            cm = repmat(1:N, Nx, 1)';
        case 'coh'
            N = Nx;
            cm = repmat(1:N, Ny, 1);
    end
    tm = repmat(1:nColors, floor(N/nColors), 1);
    ex = [tm(:); (nColors+1)*ones(N - numel(tm), 1)]';
    switch colorType
        case 'dur'
            N = Ny;
            cm = repmat(ex, Nx, 1)';
        case 'coh'
            N = Nx;
            cm = repmat(ex, Ny, 1);
    end
    colormap(colorSchemes(dotmode, colorType, N));
    sf = surf(gca, X, Y, Z, cm, 'EdgeColor', 'flat');
end
% axis tight;
hold on;

colors = colorSchemes(dotmode, 'coh', Nx);
for ii = 1:Nx
    idx = grp2idx(xs) == ii;
%     color = colors(ii,:);
    color = colors(3,:);
    if showCohData
        plot3(xs(idx), ys(idx), zs(idx), '-', 'Color', color, 'LineWidth', 1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
%         plot3(xs(idx), ys(idx), zs(idx), '.', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
    end
end
colors = colorSchemes(dotmode, 'dur', Ny);
for ii = 1:Ny
    idx = grp2idx(ys) == ii;
    color = colors(ii,:);
    if showDurData
        if isFineGrid
            plot3(xs(idx), ys(idx), zs(idx), '-', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
        else
            plot3(xs(idx), ys(idx), zs(idx), '-', 'Color', 'k', 'LineWidth', 1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
        end
        plot3(xs(idx), ys(idx), zs(idx), '.', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
    end
end
% plot3(xs, ys, zs, '.', 'Color', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', sz);

set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
set(gca, 'ZTick', [0.5, 0.75, 1.0]);
set(gca, 'ZTickLabel', {'50', '75', '100'});
set(gca, 'YTick', [33, 200, 1000, 6000]);
set(gca, 'YTickLabel', {'33', '200', '1000', '6000'});
set(gca, 'XTick', [3, 6, 12, 25, 50]);
set(gca, 'XTickLabel', {'3', '6', '12', '25', '50'});
xlbl = xlabel('Coherence (%)');
ylbl = ylabel('Duration (msec)');
zlabel('% Correct');
xlim([min(xs) max(xs)]);
ylim([min(floor(ys)) 6000]);
zlim([0.46, 1.05]);

xl = xlim;
yl = ylim;
zl = zlim;
axb1 = plot3([xl(1), xl(2)], [yl(2), yl(2)], [zl(2) zl(2)], 'Color', 'k', 'LineWidth', lw2);
axb2 = plot3([xl(2), xl(2)], [yl(1), yl(2)], [zl(2) zl(2)], 'Color', 'k', 'LineWidth', lw2);
axb3 = plot3([xl(2), xl(2)], [yl(1), yl(1)], [zl(1) zl(2)], 'Color', 'k', 'LineWidth', lw2);
% axb4 = plot3([xl(1), xl(2)], [yl(2), yl(2)], [zl(1) zl(1)], 'Color', 'k', 'LineWidth', lw2);
% axb5 = plot3([xl(2), xl(2)], [yl(1), yl(2)], [zl(1) zl(1)], 'Color', 'k', 'LineWidth', lw2);
axb6 = plot3([xl(2), xl(2)], [yl(2), yl(2)], [zl(1) zl(2)], 'Color', 'k', 'LineWidth', lw2);
% uistack([axb1 axb2 axb3 axb6], 'bottom');
plotFormats;

set(xlbl, 'Units', 'normalized');
set(ylbl, 'Units', 'normalized');
xbnds = get(xlbl, 'Position');
ybnds = get(ylbl, 'Position');
xbnds(1) = 0.6;
xbnds(2) = ybnds(2);
ybnds(1) = 0.3;
set(xlbl, 'Position', xbnds);
set(ylbl, 'Position', ybnds);

grid off;
print(gcf, ['-d' fig_ext], outfile);
