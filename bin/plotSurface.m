%%
basename = 'pcor';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', ['surface' '-' subj '-' dotmode '.' fig_ext]);

isFineGrid = true; % specifies surface shading by %-cor (t) or data dim (f)
showDurData = true; % controls plotting of data points and lines for dur
showCohData = false; % controls plotting of data points and lines for coh
% colorType = 'dur'; % if ~isFineGrid, data dimension for surface shading

%%

sz = 1;
lw1 = 3;
lw2 = 3;
lw3 = 3;

%%

fig = figure(1); clf;
title('motion threshold vs. duration (ms)');

ic = strcmp(data.pts.dotmode, dotmode);
xs = 100*data.pts.coh(ic);
ys = 1000*data.pts.dur(ic);
zs = data.pts.pc(ic);
% f = scatteredInterpolant(xs, ys, zs); % >= 2014a

xlin = unique(xs);
ylin = unique(ys);
Nx = numel(xlin);
Ny = numel(ylin);

if isFineGrid
    colormap(colorSchemes(dotmode, 'surf', 50));
    xlin = logspace(log10(min(xs)), log10(max(xs)), 200);
    ylin = logspace(log10(min(ys)), log10(max(ys)), 200);
    [X, Y] = meshgrid(xlin, ylin);
    Z = griddata(xs, ys, zs, X, Y, 'linear'); % < 2014a
%     Z = f(X, Y); % >= 2014a
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
    surf(gca, X, Y, Z, cm, 'EdgeColor', 'none');
end
% axis tight;
hold on;

colors = colorSchemes(dotmode, 'coh', Nx);
for ii = 1:Nx
    idx = grp2idx(xs) == ii;
    color = colors(ii,:);
    if showCohData
        plot3(xs(idx), ys(idx), zs(idx), '-', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
        plot3(xs(idx), ys(idx), zs(idx), '.', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
    end
end
colors = colorSchemes(dotmode, 'dur', Ny);
for ii = 1:Ny
    idx = grp2idx(ys) == ii;
    color = colors(ii,:);
    if showDurData
        plot3(xs(idx), ys(idx), zs(idx), '-', 'Color', color, 'LineWidth', lw1, 'MarkerFaceColor', 'k', 'MarkerSize', sz);
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
xlabel('Coherence (%)');
ylabel('Duration (ms)');
zlabel('% Correct');
xlim([min(xs) max(xs)]);
ylim([min(floor(ys)) 6000]);
% xlim([3, 50]);
% ylim([1, 2000]);
zlim([0.46, 1.05]);
% legend('Location', 'NorthWest');
plotFormats;
grid off;
print(gcf, ['-d' fig_ext], outfile);
