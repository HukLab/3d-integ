FontName = 'Helvetica';
FontSize = 22;
FontSizeLegend = 20;
FontSizeAxisLabels = 26;
FontWeight = 'bold';

set(gca, 'FontName', FontName);
set(gca, 'FontSize', FontSize);
set(gca, 'FontWeight', FontWeight);

set(gca, 'LineWidth', 2.0);
set(gca, 'Box', 'off');
set(gca, 'TickDir', 'out');
set(gca, 'TickLength', [.02 .02]);
set(gca, 'XMinorTick', 'off');
set(gca, 'YMinorTick', 'off');
set(gca, 'ZMinorTick', 'off');

set(findall(gcf, 'Type', 'text'), 'FontName', FontName);
set(findall(gcf, 'Type', 'text'), 'FontSize', FontSize);
set(findall(gcf, 'Type', 'text'), 'FontWeight', FontWeight);
set(gcf, 'Color', 'white');

bnd = get(gca, 'Position');
bnd(2) = 0.16;
bnd(4) = bnd(3);
set(gca, 'Position', bnd);
if exist('xlbl', 'var')
    set(xlbl, 'Units', 'normalized');
    bnd = get(xlbl, 'Position');
    bnd(2) = -0.12;
    set(xlbl, 'Position', bnd);
end

set(findobj(gcf, 'Type', 'axes', 'Tag', 'legend'), 'FontSize', FontSizeLegend);
set(get(gca, 'xlabel'), 'FontSize', FontSizeAxisLabels);
set(get(gca, 'ylabel'), 'FontSize', FontSizeAxisLabels);
set(get(gca, 'zlabel'), 'FontSize', FontSizeAxisLabels);

pos = [8 8]; %[3.5 3.5]; % [8 7];
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', pos, 'PaperPosition', [0 0 pos]);
