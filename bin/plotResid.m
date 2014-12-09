%%
data = loadFiles('pcorVsCohByDur_elbow', subj);
data2 = loadFiles('pcorVsCohByDur_0elbow', subj);
tmp = loadFiles('pcorVsCohByDur_thresh', subj);
data.pts = tmp.params;
data.params2 = data2.params;
outfile = @(dotmode) fullfile('..', 'plots', ['elbowResiduals0' '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 180;
lw1 = 2;
lw2 = 6;
lw3 = 2;
cmap = colorSchemes('resid');
dotmodes = {'2d', '3d'};

%%

noResid = false;
for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    i3 = strcmp(data.params2.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    m0 = median(data.params.m0(i2));
    m1 = median(data.params.m1(i2));
    m2 = median(data.params.m2(i2));
    b0 = median(data.params.b0(i2));
    b1 = median(data.params.b1(i2));
    b2 = median(data.params.b2(i2));
    x0 = median(data.params.x0(i2));
    x1 = median(data.params.x1(i2));
    
    maxdi = round(1.2*max(data.pts.di));
    colorOrder = colorSchemes(dotmode, 'dur', max(data.pts.di));
    
    fig = figure(i); clf; hold on;
    set(gca, 'XScale', 'log');
    xlbl = xlabel('Duration (msec)');
    ylabel('Motion sensitivity residual');
    yl = [max(min(data.pts.sens), 1e-1) max(data.pts.sens)];
    
    xs = data.pts.dur(i1);
    ys = data.pts.sens(i1);
    [ys, errs] = grpstats(ys, xs, {'mean', 'std'});
    xs = unique(xs);
    
    % ignore first 2 in 3d
    if strcmp(dotmode, '3d')
        xs = xs(3:end);
        ys = ys(3:end);
        errs = errs(3:end);
    end
    
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
    b0 = median(data.params2.b0(i3));
    
    xs0 = xs;
    yfB = xs0.^m0*exp(b0);
    
    valsA = (ys - yfA)./errs;
    valsB = (ys - yfB)./errs;
    vals = [valsA; valsB];
    vals_rng = [min(vals) max(vals)];

    lbl = dotmode;
    lblA = 'tri-limb fit';
    lblB = 'bi-limb fit';
    zer = plot([min(xs) max(xs)], [0 0], ':', 'Color', [0.8 0.8 0.8], 'LineWidth', lw3, 'HandleVisibility', 'off');
    dt1 = scatter(xs, valsA, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{2*(i-1)+2}, 'LineWidth', lw1, 'HandleVisibility', 'off');
    dt2 = scatter(xs, valsB, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{2*(i-1)+1}, 'LineWidth', lw1, 'HandleVisibility', 'off');
    ln1 = plot(xs, valsA, 'Color', cmap{2*(i-1)+2}, 'LineWidth', lw1, 'DisplayName', lblA);
    ln2 = plot(xs, valsB, 'Color', cmap{2*(i-1)+1}, 'LineWidth', lw1, 'DisplayName', lblB);

    xrng = [30.0, 1025.0];
    yrng = [-17 10];
    xlim(xrng);
    ylim(yrng);
    elb = plot([exp(x0) exp(x0)], yrng, '--', 'Color', cmap{2*(i-1)+2}, 'LineWidth', lw1, 'HandleVisibility', 'off');
    
    uistack(dt1, 'bottom');
    uistack(dt2, 'bottom');
    uistack(ln1, 'bottom');
    uistack(ln2, 'bottom');
    uistack(elb, 'bottom');
    uistack(zer, 'bottom');

    xticks = [33, 200, 1000];
    xtf = @(x) sprintf('%.0f', x);
    xticklbls = arrayfun(xtf, xticks, 'UniformOutput', false);

    yticks = [33, 200, 1000];
    ytf = @(x) sprintf('%.0f', x);
    yticklbls = arrayfun(ytf, yticks, 'UniformOutput', false);

    set(gca, 'XTick', xticks);
    set(gca, 'XTickLabel', xticklbls);
    
    leg = legend('Location', 'NorthWest');
    plotFormats;
    print(fig, ['-d' fig_ext], outfile(dotmode));
end
