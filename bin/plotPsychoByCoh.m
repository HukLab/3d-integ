%%
basename = 'pcorVsCohByDur_thresh';
data = loadFiles(basename, subj);
outfile = @(dotmode) fullfile('..', 'plots', ['psychoByCoh' '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 100;
lw1 = 2;
lw2 = 6;
lw3 = 2;
dotmodes = {'2d', '3d'};
maxDur = 6000;

%%
for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    f1.x = data.pts.x(i1);
    f1.y = data.pts.y(i1);
    f1.di = data.pts.di(i1);
    f1.ntrials = data.pts.ntrials(i1);
    f2.di = data.params.di(i2);
    f2.scale = data.params.scale(i2);
    f2.loc = data.params.loc(i2);
    f2.thresh = data.params.thresh(i2);
    f2.lapse = data.params.lapse(i2);
    f2.dur = data.params.dur(i2);

    fig = figure(i); clf; hold on;
    set(gca, 'XScale', 'log');
%     title([dotmode ': percent correct vs. motion coherence']);
    xlabel('% Coherence');
    ylabel('% Correct');
    ln = plot([0.022, 0.7], [0.75, 0.75], ':', 'Color', [0.8 0.8 0.8], 'LineWidth', lw3, 'HandleVisibility', 'off');
    
    maxdi = max(data.params.di);
    dis = 1:maxdi; %4:5:maxdi;
    dis = [3 5 10 20];
    colorOrder = colorSchemes(dotmode, 'dur', max(data.params.di));
    
    ebrs = [];
    dots = [];
    crvs = [];
    for jj = 1:numel(dis)
        dii = dis(jj);
        xb = f1.x(f1.di == dii);
        yb = f1.y(f1.di == dii);
        ns = f1.ntrials(f1.di == dii);
        xf = linspace(0.027, 0.55);%min(xb), max(xb)+0.5);
        
        scales = f2.scale(f2.di == dii);
        locs = f2.loc(f2.di == dii);
        threshes = f2.thresh(f2.di == dii);
        lapses = f2.lapse(f2.di == dii);
        
%         figure(4); subplot(numel(dis), 1, jj); hist(locs, linspace(0, 1)); xlim([0 0.8]);
%         figure(5); subplot(numel(dis), 1, jj); hist(scales, linspace(0, 1)); xlim([0 1.0]);
%         figure(6); subplot(numel(dis), 1, jj); hist(threshes, linspace(0, 1)); xlim([0 1.0]);
%         figure(i);
        
        % take first entry as mean (others are bootstrap)
        scale = scales(1);
        loc = locs(1);
        thresh = threshes(1);
        lapse = lapses(1);
        
        scale = median(scales);
        loc = median(locs);
        thresh = median(threshes);
        lapse = median(lapses);
        
        yf = 0.5 + (1 - 0.5 - lapse)*cdf('logistic', xf, loc, scale);
        
        color = colorOrder(dii, :);
        dur1 = f2.dur(f2.di == dii);
        dur2 = f2.dur(f2.di == dii+1);
        if isempty(dur2)
            dur2 = [maxDur];
        end
        lbl1 = num2str(sprintf('%.0f', dur1(1)));
        lbl2 = num2str(sprintf('%.0f', dur2(1)));
        lbl = [num2str(lbl1) '-' num2str(lbl2) ' msec'];
%         plot([thresh, thresh], [0.4, 0.75], '--', 'Color', color, 'LineWidth', lw3, 'HandleVisibility', 'off');
%         text(thresh, 0.48, [sprintf('%.0f%%', thresh*100)], 'FontSize', 14, 'FontWeight', 'bold');
        crv = plot(xf, yf, '-', 'Color', color, 'LineWidth', lw2, 'DisplayName', lbl);
        
        disp([dotmode ' ' num2str(dii) ' ' num2str(thresh) ' ' num2str(100*mean(threshes(~isnan(threshes))))])
        
%         plot([thresh, thresh], [0.5, 0.75], '--', 'Color', color, 'LineWidth', lw3, 'HandleVisibility', 'off');
        err = sqrt((yb.*(1-yb))./ns);
        errs = [err err];
%         errs = abs(pcorBootstrap(xb, yb, ns) - repmat(yb, 1, 2));
        ebr = errorbar(xb, yb, errs(:,1), errs(:,2), 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
        errorbar_tick(ebr, 0);
%         k = waitforbuttonpress
        dts = scatter(xb, yb, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', color, 'LineWidth', lw1, 'HandleVisibility', 'off');
        
        ebrs = [ebrs; ebr];
        crvs = [crvs; crv];
        dots = [dots; dts];
    end
    crvs = crvs(end:-1:1);
    uistack(dots, 'bottom');
    uistack(ebrs, 'bottom');
    uistack(crvs, 'bottom');
    uistack(ln, 'bottom');
    
    xticks = [0.03, 0.06, 0.12, 0.25, 0.5];
    xtf = @(x) sprintf('%.0f', x);
    xticklbls = arrayfun(xtf, 100*xticks, 'UniformOutput', false);
    set(gca, 'XTick', xticks);
    set(gca, 'XTickLabel', xticklbls);
    set(gca, 'YTick', [0.5, 0.75, 1.0]);
    set(gca, 'YTickLabel', {'50', '75', '100'});
    legend('Location', 'NorthWest');
    xlim([0.02, 0.7]);
    ylim([.5, 1.0]);
    plotFormats;
    print(fig, ['-d' fig_ext], outfile(dotmode));
end
