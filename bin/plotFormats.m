FontName = 'Helvetica Neue';
FontSize = 14;
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
