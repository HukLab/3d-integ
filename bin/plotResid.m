%%
data = loadFiles('pcorVsCohByDur_elbow', subj);
data2 = loadFiles('pcorVsCohByDur_1elbow', subj);
tmp = loadFiles('pcorVsCohByDur_thresh', subj);
data.pts = tmp.params;
data.params2 = data2.params;
outfile = @(dotmode) fullfile('..', 'plots', ['elbowResiduals' '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 100;
lw1 = 2;
lw2 = 3;
lw3 = 3;
cmap = colorSchemes('both');
dotmodes = {'2d', '3d'};

%%

for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    i3 = strcmp(data.params2.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    maxdi = round(1.2*max(data.pts.di));
    colorOrder = colorSchemes(dotmode, 'dur', max(data.pts.di));
    
    fig = figure(i); clf; hold on;
    set(gca, 'XScale', 'log');
%     set(gca, 'YScale', 'log');
    title('motion threshold vs. duration (ms)');
    xlabel('duration (ms)');
    ylabel('motion sensitivity');
    yl = [max(min(data.pts.sens), 1e-1) max(data.pts.sens)];
    
    xs = data.pts.dur(i1);
    ys = data.pts.sens(i1);
    [ys, errs] = grpstats(ys, xs, {'mean', 'std'});
    xs = unique(xs);
    
    if strcmp(dotmode, '3d')
        xs = xs(2:end);
        ys = ys(2:end);
        errs = errs(2:end);
    end

    m0 = median(data.params.m0(i2));
    m1 = median(data.params.m1(i2));
    m2 = median(data.params.m2(i2));
    b0 = median(data.params.b0(i2));
    b1 = median(data.params.b1(i2));
    b2 = median(data.params.b2(i2));
    x0 = median(data.params.x0(i2));
    x1 = median(data.params.x1(i2));
    
    % ignore xs past second elbow
    xs = xs(xs <= exp(x1));
    ys = ys(xs <= exp(x1));
    errs = errs(xs <= exp(x1));
    
    xs0 = xs(xs < exp(x0));
    xs1 = xs(xs >= exp(x0) & xs < exp(x1));
    yf0 = xs0.^m0*exp(b0);
    yf1 = xs1.^m1*exp(b1);
    xsA = [xs0; xs1];
    yfA = [yf0; yf1];
    
    m0 = median(data.params2.m0(i3));
    m1 = median(data.params2.m1(i3));
    b0 = median(data.params2.b0(i3));
    b1 = median(data.params2.b1(i3));
    x02 = median(data.params2.x0(i3));
    
    xs0 = xs(xs < exp(x02));
    xs1 = xs(xs >= exp(x02));
    yf0 = xs0.^m0*exp(b0);
    yf1 = xs1.^m1*exp(b1);
    yfB = [yf0; yf1];
    
    valsA = (yfA - ys)./errs;
    valsB = (yfB - ys)./errs;
    vals = [valsA; valsB];
    vals_rng = [min(vals) max(vals)];
        
    lbl = dotmode;
%     scatter(xs, yfA, sz, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
%     scatter(xs, yfB, sz, 'MarkerFaceColor', cmap{i}, 'MarkerEdgeColor', 'k');
%     plot(xs, ys, '-', 'LineWidth', lw2, 'Color', cmap{i});
    lblA = '2-elb';
    lblB = '1-elb';
    plot([min(xs) max(xs)], [0 0], '--', 'LineWidth', lw2, 'Color', [0.5 0.5 0.5], 'HandleVisibility', 'off');
    plot(xs, valsB, 'Color', cmap{i}, 'LineWidth', lw2, 'DisplayName', lblB);
    plot(xs, valsA, 'Color', 'k', 'LineWidth', lw2, 'DisplayName', lblA);
    
    
    xlim([min(xs)-10, max(xs)+50]);
    yrng = [-12 12];
    ylim(yrng);
    plot([exp(x02) exp(x02)], yrng, '--', 'Color', cmap{i}, 'LineWidth', lw2, 'HandleVisibility', 'off');
    plot([exp(x0) exp(x0)], yrng, '--', 'Color', 'k', 'LineWidth', lw2, 'HandleVisibility', 'off');

    xticks = [10, 100, 200, 1000];
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
    % set(gca, 'YTick', yticks);
    % set(gca, 'YTickLabel', yticklbls);

    legend('Location', 'NorthWest');
    plotFormats;
    print(fig, ['-d' fig_ext], outfile(dotmode));
end
