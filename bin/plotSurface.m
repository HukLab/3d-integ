%%
basename = 'pcor';
data = loadFiles(basename, subj);
outfile = fullfile('..', 'plots', [basename '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 10;
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

xlin = logspace(log10(min(xs)), log10(max(xs)));
ylin = logspace(log10(min(ys)), log10(max(ys)));

[X, Y] = meshgrid(xlin, ylin);
f = scatteredInterpolant(xs, ys, zs);
Z = f(X, Y);
surf(gca, X, Y, Z); % interpolated
% plot3(xs, ys, zs, '.', 'Color', 'k', 'MarkerFaceColor', 'k', 'MarkerSize', sz) % nonuniform

axis tight; hold on;
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
xlim([3, 50]);
%     ylim([1, 2000]);
zlim([0.45, 1.05]);
grid minor;
if strcmp(dotmode, '2d')
    colormap summer;
else
    colormap hot;
end
% legend('Location', 'NorthWest');
plotFormats;

print(gcf, ['-d' fig_ext], outfile);
