%%
basename = 'pcorVsCohByDur_elbow';
data = loadFiles(basename, subj);
basenameB = 'pcorVsCohByDur_1elbow';
dataB = loadFiles(basenameB, subj);
tmp = loadFiles('pcorVsCohByDur_thresh', subj);
data.pts = tmp.params;
data.paramsB = dataB.params;
outfile = fullfile('..', 'plots', ['blochByFit' '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 180;
lw1 = 2;
lw2 = 6;
lw3 = 3;
cmap = colorSchemes('resid');
i = 2*strcmp(dotmode, '3d') + 1;
cmap = {cmap{i}, cmap{i+1}};

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

% threshold lines - 2 elbs
is2d = strcmp(data.params.dotmode, '2d');
is3d = strcmp(data.params.dotmode, '3d');
x02d = median(data.params.x0(is2d));
x12d = median(data.params.x1(is2d));
x03d = median(data.params.x0(is3d));
x13d = median(data.params.x1(is3d));
% threshold lines - 1 elb
is2db = strcmp(data.paramsB.dotmode, '2d');
is3db = strcmp(data.paramsB.dotmode, '3d');
x02db = median(data.paramsB.x0(is2db));
x03db = median(data.paramsB.x0(is3db));

xthresh = [];

i1 = strcmp(data.pts.dotmode, dotmode);
i2 = strcmp(data.params.dotmode, dotmode);
i2b = strcmp(data.paramsB.dotmode, dotmode);
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
xs = unique(xs);
lerrs = abs(ys - errs(:,1));
uerrs = abs(ys - errs(:,2));

% line params - 2 elbs
m0 = median(data.params.m0(i2));
m1 = median(data.params.m1(i2));
m2 = median(data.params.m2(i2));
b0 = median(data.params.b0(i2));
b1 = median(data.params.b1(i2));
b2 = median(data.params.b2(i2));
% line params - 1 elb
m0b = median(data.paramsB.m0(i2b));
m1b = median(data.paramsB.m1(i2b));
b0b = median(data.paramsB.b0(i2b));
b1b = median(data.paramsB.b1(i2b));

% elbows where the median params intercept
x0 = abs((b1-b0)/(m1-m0));
x1 = abs((b2-b1)/(m2-m1));
x0b = abs((b1b-b0b)/(m1b-m0b));

% lines - 2 elbs
xs0 = linspace(minDur, exp(x0));
xs1 = linspace(exp(x0), exp(x1));
xs2 = linspace(exp(x1), max(xs));
yf0 = (xs0.^m0)*exp(b0);
yf1 = (xs1.^m1)*exp(b1);
yf2 = (xs2.^m2)*exp(b2);
% lines - 1 elb
xs0b = linspace(minDur, exp(x0b));
xs1b = linspace(exp(x0b), max(xs));
yf0b = (xs0b.^m0b)*exp(b0b);
yf1b = (xs1b.^m1b)*exp(b1b);

% don't extrapolate sensitivities below 1
xs0 = xs0(yf0 >= 1);
yf0 = yf0(yf0 >= 1);
xs0b = xs0b(yf0b >= 1);
yf0b = yf0b(yf0b >= 1);

lblA = 'tri-limb';
lblB = 'bi-limb';
plot(xs0b, yf0b, '-', 'Color', cmap{2}, 'LineWidth', lw2, 'DisplayName', lblB);
plot(xs1b, yf1b, '-', 'Color', cmap{2}, 'LineWidth', lw2, 'HandleVisibility', 'off');
plot(xs0, yf0, '-', 'Color', cmap{1}, 'LineWidth', lw2, 'DisplayName', lblA);
plot(xs1, yf1, '-', 'Color', cmap{1}, 'LineWidth', lw2, 'HandleVisibility', 'off');
plot(xs2, yf2, '-', 'Color', cmap{1}, 'LineWidth', lw2, 'HandleVisibility', 'off');

h = errorbar(xs, ys, lerrs, uerrs, 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
errorbar_tick(h, 0);
pts = [xs ys];
scatter(xs, ys, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{1}, 'LineWidth', lw1, 'HandleVisibility', 'off');

%     xthresh = [xthresh exp(x0) exp(x1)];
%     text(exp(x0), 50 + 20*(i-1), ['\leftarrow  ' sprintf('%.0f', exp(x0)) ' msec'], 'FontSize', 14, 'FontWeight', 'bold');
%     text(exp(x1), 50 + 20*(i-1), ['\leftarrow  ' sprintf('%.0f', exp(x1)) ' msec'], 'FontSize', 14, 'FontWeight', 'bold');

% text(35, 12 + 6*strcmp(dotmode, '2d'), ['m_1 = ' sprintf('%.2f', m0)], 'Color', cmap{1}, 'FontSize', 14, 'FontWeight', 'bold');
% text(350, 2 + 1*strcmp(dotmode, '2d'), ['m2=' sprintf('%.2f', m1)], 'Color', cmap{1}, 'FontSize', 14, 'FontWeight', 'bold');

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
