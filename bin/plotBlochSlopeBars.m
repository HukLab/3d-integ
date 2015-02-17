basename = 'pcorVsCohByDur_elbow';
data = loadFiles(basename, subj);
outfile1 = fullfile('..', 'plots', ['blochSlope' '-' 'm0' '.' fig_ext]);
outfile2 = fullfile('..', 'plots', ['blochSlope' '-' 'm1' '.' fig_ext]);

cmap = colorSchemes('both');
clear xlbl;
lw = 4;
FontSize = 10;
yticks = [0.0, 0.4, 0.8, 1.2];
maxY = 1.4;

is2d = strcmp(data.params.dotmode, '2d');
is3d = strcmp(data.params.dotmode, '3d');
m02d = data.params.m0(is2d);
m12d = data.params.m1(is2d);
m03d = data.params.m0(is3d);
m13d = data.params.m1(is3d);

m02d = prctile(m02d, [34.05, 50, 65.95]);
m12d = prctile(m12d, [34.05, 50, 65.95]);
m03d = prctile(m03d, [34.05, 50, 65.95]);
m13d = prctile(m13d, [34.05, 50, 65.95]);

%%

fig = figure(1); clf; hold on;
bar(0, m02d(2), 'FaceColor', cmap{1}, 'LineWidth', lw);
bar(1, m03d(2), 'FaceColor', cmap{2}, 'LineWidth', lw);
h1 = errorbar(0, m02d(2), m02d(2) - m02d(1), m02d(3) - m02d(2), 'Color', 'k', 'LineWidth', lw, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
h2 = errorbar(1, m03d(2), m03d(2) - m03d(1), m03d(3) - m03d(2), 'Color', 'k', 'LineWidth', lw, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
errorbar_tick(h1, 0);
errorbar_tick(h2, 0);

ylim([min(yticks), maxY]);
set(gca, 'XTick', []);
set(gca, 'XTickLabel', []);
set(gca, 'YTick', yticks);

% awful hack to avoid destructive formatting
skipExtras = true; plotFormats; clear skipExtras;
FontSize = 36;
set(gca, 'FontSize', FontSize);

set(gca, 'LineWidth', lw);
print(fig, ['-d' fig_ext], outfile1);

%%

fig = figure(1); clf; hold on;
bar(0, m12d(2), 'FaceColor', cmap{1}, 'LineWidth', lw);
bar(1, m13d(2), 'FaceColor', cmap{2}, 'LineWidth', lw);
h1 = errorbar(0, m12d(2), m12d(2) - m12d(1), m12d(3) - m12d(2), 'Color', 'k', 'LineWidth', lw, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
h2 = errorbar(1, m13d(2), m13d(2) - m13d(1), m13d(3) - m13d(2), 'Color', 'k', 'LineWidth', lw, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
errorbar_tick(h1, 0);
errorbar_tick(h2, 0);

ylim([min(yticks), maxY]);
set(gca, 'XTick', []);
set(gca, 'XTickLabel', []);
set(gca, 'YTick', yticks);

% awful hack to avoid destructive formatting
skipExtras = true; plotFormats; clear skipExtras;
FontSize = 36;
set(gca, 'FontSize', FontSize);

set(gca, 'LineWidth', lw);
print(fig, ['-d' fig_ext], outfile2);

