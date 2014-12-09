%%
basename = 'pcorVsCohByDur_1elbow';
data = loadFiles(basename, subj);
tmp = loadFiles('pcorVsCohByDur_thresh', subj);
data.pts = tmp.params;
outfile = fullfile('..', 'plots', ['bloch1Elb' '-' subj '.' fig_ext]);

%%

sz = 180;
lw1 = 2;
lw2 = 6;
lw3 = 3;
cmap = colorSchemes('both');
dotmodes = {'2d', '3d'};

minDi = @(dotmode) 2*strcmp(dotmode, '3d') + 1;
minDur = 33;

%%

fig = figure(1); clf; hold on;
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
% title('motion threshold vs. duration (msec)');
xlbl = xlabel('Duration (msec)');
ylabel('Motion sensitivity (1/threshold)');
yl = [max(min(data.pts.sens), 1e-1) max(data.pts.sens)];

% threshold lines
is2d = strcmp(data.params.dotmode, '2d');
is3d = strcmp(data.params.dotmode, '3d');
x02d = median(data.params.x0(is2d));
% x12d = median(data.params.x1(is2d));
x03d = median(data.params.x0(is3d));
% x13d = median(data.params.x1(is3d));
i = 1;
% plot(exp([x02d, x02d]), yl, '--', 'Color', cmap{i}, 'LineWidth', lw3, 'HandleVisibility', 'off');
% plot(exp([x12d, x12d]), yl, '--', 'Color', cmap{i}, 'LineWidth', lw3, 'HandleVisibility', 'off');
i = 2;
% plot(exp([x03d, x03d]), yl, '--', 'Color', cmap{i}, 'LineWidth', lw3, 'HandleVisibility', 'off');
% plot(exp([x13d, x13d]), yl, '--', 'Color', cmap{i}, 'LineWidth', lw3, 'HandleVisibility', 'off');

xthresh = [];
for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    i3 = data.pts.di >= minDi(dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    i1 = i1 & i3;
    maxdi = round(1.2*max(data.pts.di));
    colorOrder = colorSchemes(dotmode, 'dur', max(data.pts.di));
    
    xs = data.pts.dur(i1);
    ys = data.pts.sens(i1);
    [ys, errs] = grpstats(ys, xs, {'mean', 'predci'}, 'Alpha', 0.319);
%     [ys, errs, ns] = grpstats(ys, xs, {'mean', 'std', 'numel'});
%     errs = errs./sqrt(ns);
    xs = unique(xs);
    lerrs = abs(ys - errs(:,1));
    uerrs = abs(ys - errs(:,2));

    m0 = median(data.params.m0(i2));
    m1 = median(data.params.m1(i2));
%     m2 = median(data.params.m2(i2));
    b0 = median(data.params.b0(i2));
    b1 = median(data.params.b1(i2));
%     b2 = median(data.params.b2(i2));
    
    % elbows where the median params intercept
    x0 = abs((b1-b0)/(m1-m0));
%     x1 = abs((b2-b1)/(m2-m1));
%     x0 = median(data.params.x0(i2));
%     x1 = median(data.params.x1(i2));
    
    xs0 = linspace(minDur, exp(x0));
    xs1 = linspace(exp(x0), max(xs));
%     xs2 = linspace(exp(x1), max(xs));
    yf0 = (xs0.^m0)*exp(b0);
    yf1 = (xs1.^m1)*exp(b1);
%     yf2 = (xs2.^m2)*exp(b2);
    
    % don't extrapolate sensitivities below 1
    xs0 = xs0(yf0 >= 1);
    yf0 = yf0(yf0 >= 1);
    
    lbl = dotmode;
    plot(xs0, yf0, '-', 'Color', cmap{i}, 'LineWidth', lw2, 'DisplayName', lbl);
    plot(xs1, yf1, '-', 'Color', cmap{i}, 'LineWidth', lw2, 'HandleVisibility', 'off');
%     plot(xs2, yf2, '-', 'Color', cmap{i}, 'LineWidth', lw2, 'HandleVisibility', 'off');
    
%     h = errorbar(xs, ys, errs(:,1), 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
    h = errorbar(xs, ys, lerrs, uerrs, 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
    errorbar_tick(h, 0);
    pts = [xs ys];
%     for j = 1:numel(xs)
%         color = colorOrder(j,:);
%         scatter(xs(j), ys(j), sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', color, 'LineWidth', lw1, 'HandleVisibility', 'off');
%     end
    scatter(xs, ys, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{i}, 'LineWidth', lw1, 'HandleVisibility', 'off');
    
%     xthresh = [xthresh exp(x0) exp(x1)];
%     text(exp(x0), 50 + 20*(i-1), ['\leftarrow  ' sprintf('%.0f', exp(x0)) ' msec'], 'FontSize', 14, 'FontWeight', 'bold');
%     text(exp(x1), 50 + 20*(i-1), ['\leftarrow  ' sprintf('%.0f', exp(x1)) ' msec'], 'FontSize', 14, 'FontWeight', 'bold');
    
    text(35, 12 + 6*strcmp(dotmode, '2d'), ['m_1 = ' sprintf('%.2f', m0)], 'Color', cmap{i}, 'FontSize', 14, 'FontWeight', 'bold');
%     text(350, 2 + 1*strcmp(dotmode, '2d'), ['m2=' sprintf('%.2f', m1)], 'Color', cmap{i}, 'FontSize', 14, 'FontWeight', 'bold');
%     text(mean(xs2), 0.8*mean(yf2), sprintf('%.2f', m2), 'FontSize', 14, 'FontWeight', 'bold');
    
%     errorbar_tick(h, 1e-2); % problem with log
end

xlim([20, 6000]);
ylim([0.5, 100]);

xticks = [33, 200, 1000, 6000];
xtf = @(x) sprintf('%.0f', x);
xticklbls = arrayfun(xtf, xticks, 'UniformOutput', false);

yticks = [1, 10, 100];
ytf = @(x) sprintf('%.0f', x);
yticklbls = arrayfun(ytf, yticks, 'UniformOutput', false);

% xticks = sort([xthresh [10, 100, 1000]]);
% xticks = uncrowdTicks(xthresh, 1, true);
% set(gca, 'XTick', xticks);
% set(gca, 'XTickLabel', xticklbls);

set(gca, 'XTick', xticks);
set(gca, 'XTickLabel', xticklbls);
set(gca, 'YTick', yticks);
set(gca, 'YTickLabel', yticklbls);

leg = legend('Location', 'NorthWest');
plotFormats;
print(fig, ['-d' fig_ext], outfile);
