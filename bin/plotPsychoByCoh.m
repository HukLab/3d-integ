%%
basename = 'pcorVsCohByDur_thresh';
data = loadFiles(basename, subj);
outfile = @(dotmode) fullfile('..', 'plots', [basename '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 100;
lw1 = 2;
lw2 = 3;
lw3 = 3;
dotmodes = {'2d', '3d'};

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
    title([dotmode ': percent correct vs. motion coherence']);
    xlabel('% coherence');
    ylabel('% correct');
    plot([0.02, 0.7], [0.75, 0.75], '--', 'Color', 'k', 'LineWidth', lw3, 'HandleVisibility', 'off');
    
    maxdi = max(data.params.di);
    dis = 1:maxdi; %4:5:maxdi;
    dis = [5 10 15 20];
    colorOrder = summer(maxdi + 2);
    if i == 1
        colorOrder(:,1) = colorOrder(:,2)*2 - 1;
        colorOrder(:,2) = 0.8;
        colorOrder(:,3) = 0.0;
    elseif i == 2
        colorOrder(:,1) = 0.9;
        colorOrder(:,2) = colorOrder(:,2)*2 - 1;
        colorOrder(:,3) = 0.0;
    end
    for jj = 1:numel(dis)
        dii = dis(jj);
        xb = f1.x(f1.di == dii);
        yb = f1.y(f1.di == dii);
        ns = f1.ntrials(f1.di == dii);
%         errs = abs(pcorBootstrap(xb, yb, ns) - repmat(yb, 1, 2));
        xf = linspace(min(xb), max(xb));
        
        scales = f2.scale(f2.di == dii);
        locs = f2.loc(f2.di == dii);
        threshes = f2.thresh(f2.di == dii);
        lapses = f2.lapse(f2.di == dii);
        
%         figure(4); subplot(numel(dis), 1, jj); hist(locs, linspace(0, 1)); xlim([0 0.8]);
%         figure(5); subplot(numel(dis), 1, jj); hist(scales, linspace(0, 1)); xlim([0 1.0]);
%         figure(6); subplot(numel(dis), 1, jj); hist(threshes, linspace(0, 1)); xlim([0 1.0]);
        
        figure(i);
        
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
        
        color = colorOrder(maxdi-dii+1, :);
        dur = f2.dur(f2.di == dii);
        lbl = num2str(sprintf('%.0f', dur(1)));
%         plot([thresh, thresh], [0.4, 0.75], '--', 'Color', color, 'LineWidth', lw3, 'HandleVisibility', 'off');
%         text(thresh, 0.48, [sprintf('%.0f%%', thresh*100)], 'FontSize', 14, 'FontWeight', 'bold');
        plot(xf, yf, '-', 'Color', color, 'LineWidth', lw2, 'DisplayName', [num2str(lbl) ' msec']);
%         errorbar(xb, yb, errs(:,1), errs(:,2), 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
%         k = waitforbuttonpress
        scatter(xb, yb, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', color, 'LineWidth', lw1, 'HandleVisibility', 'off');
    end
    set(gca, 'XTick', [1e-2, 1e-1, 0.5]);
    set(gca, 'XTickLabel', {'1', '10', '50'});
    set(gca, 'YTick', [0.5, 0.75, 1.0]);
    set(gca, 'YTickLabel', {'50', '75', '100'});
    legend('Location', 'NorthWest');
    xlim([0.02, 0.7]);
    ylim([.5, 1.0]);
    plotFormats;
    print(fig, ['-d' fig_ext], outfile(dotmode));
end
