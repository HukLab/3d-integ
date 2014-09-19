%%
basename = 'pcorVsCohByDur_elbow';
data = tempint_csvs(basename, subj);
tmp = tempint_csvs('pcorVsCohByDur_thresh', subj);
data.pts = tmp.params;
outfile = @(dotmode) fullfile('..', 'plots', [basename '-' subj '-' dotmode '-' 'params' '.' fig_ext]);

%%

sz = 20;
lw1 = 1;
lw2 = 2;
lw3 = 1.2;
cmap = {[0 0.8 0], [0.9 0 0]};
dotmodes = {'2d', '3d'};

%%

xs = exp(data.params.x0);
ys = exp(data.params.x1);
xlbl = 'x0';
ylbl = 'x1';
% ys = data.params.m0;
xl = [min(xs) max(xs)];
yl = [min(ys) max(ys)];
figure(3); ha1 = tight_subplot(2,1,0.05);
figure(4); ha2 = tight_subplot(2,1,0.05);

for i = 1:length(dotmodes)
    dotmode = dotmodes{i};
    i1 = strcmp(data.pts.dotmode, dotmode);
    i2 = strcmp(data.params.dotmode, dotmode);
    if sum(i1) == 0 || sum(i2) == 0
        continue
    end
    
    nbins = 30;
    lbl = dotmode;
    m0 = xs(i2);
    m1 = ys(i2);
    [n0, b0] = hist(m0, linspace(xl(1), xl(2), nbins));
    [n1, b1] = hist(m1, linspace(yl(1), yl(2), nbins));
    
    figure(3); axes(ha1(i));
    bar(b0, n0, 'FaceColor', cmap{i});
    ylim([0 500]);
    h(i) = findobj(gca,'Type','patch');
    set(h(i),'FaceColor',cmap{i},'EdgeColor','w');
    title(xlbl);
    if i == 2
        set(gca,'YDir','reverse');
    end
    
    figure(4); axes(ha2(i));
    bar(b1, n1, 'FaceColor', cmap{i});
    ylim([0 500]);
    h(i) = findobj(gca,'Type','patch');
    set(h(i),'FaceColor',cmap{i},'EdgeColor','w');
    title(ylbl);
    if i == 2
        set(gca,'YDir','reverse');
%         xlabel('m1');
    end
    
    fig = figure(i); clf; hold on;
    title('m0 vs. m1');
    subplot(2,2,3);
    scatter(m0, m1, sz, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', cmap{i});
    xlim(xl);
    ylim(yl);
    xlabel(xlbl);
    ylabel(ylbl);
%     xl = xlim();
%     yl = ylim();
    subplot(2,2,1);
    bar(b0, n0, 'FaceColor', cmap{i});
    xlim(xl);
    subplot(2,2,4);
    barh(b1, n1, 'FaceColor', cmap{i});
    ylim(yl);
    print(fig, ['-d' fig_ext], outfile(dotmode));
end
