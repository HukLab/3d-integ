%%
basename = 'fitCurveVsDurByCoh';
data = loadFiles(basename, subj);
outfile = @(dotmode) fullfile('..', 'plots', [basename '-' subj '-' dotmode '.' fig_ext]);

%%

sz = 100;
lw1 = 2;
lw2 = 3;
lw3 = 3;
x_delay = 30; % (ms)
dotmodes = {'2d', '3d'};

%%

for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end

    fig = figure(i); clf; hold on;
    tempint_pltfmts;
    title([dotmode ': percent correct vs. duration (ms)']);
    xlabel('duration (ms)');
    ylabel('% correct');
    xlim([30, 1000]);
    ylim([0.45, 1.0]);
    set(gca,'XScale','log');
    
    cohs = unique(data.params.coh);
    colorOrder = summer(length(cohs) + 1);
    if i == 1
        tmp1 = colorOrder(:,1);
        tmp2 = colorOrder(:,2);
        colorOrder(:,1) = 0.8*tmp1;
        colorOrder(:,2) = 0.8*tmp2;
        colorOrder(:,3) = 0.8*tmp1;
    elseif i == 2
        colorOrder(:,1) = 0.9;
        colorOrder(:,2) = colorOrder(:,2)*2 - 1;
        colorOrder(:,3) = colorOrder(:,2);
    end
    for ci = 1:length(cohs)
        coh = cohs(ci);
        isCoh1 = data.pts.coh == coh;
        isCoh2 = data.params.coh == coh;
        
        xb = 1000*data.pts.dur(isCoh1 & i1);
        yb = data.pts.pc(isCoh1 & i1);
        ns = data.pts.ntrials(isCoh1 & i1);
        er = data.pts.se(isCoh1 & i1);
        errs = [er er];
        
        A = data.params.A(isCoh2 & i2);
        B = data.params.B(isCoh2 & i2);
        T = data.params.T(isCoh2 & i2);
        
        % use mean of parameters to plot line
        A = mean(A);
        B = mean(B);
        T = mean(T);
        xf = linspace(min(xb), max(xb));
        yf = A - (A - B)*exp(-(xf - x_delay)./T);
        
        color = colorOrder(length(cohs)-ci+1, :);
        lbl = num2str(sprintf('%.2f', coh));
%         plot([T+x_delay, T+x_delay], [0.4, 1.0], '--', 'Color', color, 'LineWidth', lw3, 'HandleVisibility', 'off');
        plot(xf, yf, '-', 'Color', color, 'LineWidth', lw2, 'DisplayName', num2str(lbl));
        h = errorbar(xb, yb, errs(:,1), errs(:,2), 'Color', 'k', 'LineWidth', lw1, 'LineStyle', 'none', 'Marker', 'none', 'HandleVisibility', 'off');
        scatter(xb, yb, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', color, 'LineWidth', lw1, 'HandleVisibility', 'off');
        errorbar_tick(h, 1e-2); % problem with log
    end
    set(gca, 'XTick', [10, 100, 1000]);
    set(gca, 'XTickLabel', {'10', '100', '1000'});
    set(gca, 'YTick', [0.5, 0.75, 1.0]);
    set(gca, 'YTickLabel', {'50', '75', '100'});
    lh = legend('Location', 'NorthEastOutside');
    set(lh, 'LineWidth', lw1);
    plotFormats;
    print(fig, ['-d' fig_ext], outfile(dotmode));
end
