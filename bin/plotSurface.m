%%
basename = 'pcor';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', [basename '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 25;
lw1 = 2;
lw2 = 3;
lw3 = 3;

%%

fig = figure(1);
title('motion threshold vs. duration (ms)');

ic = strcmp(data.pts.dotmode, dotmode);
xs = 100*data.pts.coh(ic);
ys = 1000*data.pts.dur(ic);
zs = data.pts.pc(ic);
f = scatteredInterpolant(xs, ys, zs);

xlin = unique(xs);
ylin = unique(ys);
Nx = numel(xlin);
Ny = numel(ylin);

colorType = 'dur';
isFineGrid = false;
if isFineGrid
    switch dotmode
        case '2d'
            colormap(summer);
        case '3d'
            colormap(hot);
    end
    colormap(gray);
    xlin = logspace(log10(min(xs)), log10(max(xs)));
    ylin = logspace(log10(min(ys)), log10(max(ys)));
    [X, Y] = meshgrid(xlin, ylin);
    Z = f(X, Y);
    surf(gca, X, Y, Z, 'EdgeColor', 'none');
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
    colormap(colorSchemes(dotmode, colorType, N));
%     colormap(white);
    surf(gca, X, Y, Z, cm, 'EdgeColor', 'none');
end
% axis tight;
hold on;

colors = colorSchemes(dotmode, 'coh', Nx);
for ii = 1:Nx
    idx = grp2idx(xs) == ii;
    color = colors(ii,:);
    plot3(xs(idx), ys(idx), zs(idx), '-', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
    plot3(xs(idx), ys(idx), zs(idx), '.', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
end
colors = colorSchemes(dotmode, 'dur', Ny);
for ii = 1:Ny
    idx = grp2idx(ys) == ii;
    color = colors(ii,:);
    plot3(xs(idx), ys(idx), zs(idx), '-', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
end
% plot3(xs, ys, zs, '.', 'Color', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', sz);

set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
set(gca, 'ZTick', [0.5, 0.75, 1.0]);
set(gca, 'ZTickLabel', {'50', '75', '100'});
set(gca, 'YTick', [10, 100, 1000]);
set(gca, 'YTickLabel', {'10', '100', '1000'});
set(gca, 'XTick', [1, 12, 50]);
set(gca, 'XTickLabel', {'1', '12', '50'});
xlabel('coherence (%)');
ylabel('duration (ms)');
zlabel('correct (%)');
xlim([min(xs) max(xs)]);
ylim([min(ys) max(ys)]);
% xlim([3, 50]);
% ylim([1, 2000]);
zlim([0.45, 1.05]);
% legend('Location', 'NorthWest');
plotFormats;
grid off;
print(gcf, ['-d' fig_ext], outfile);
