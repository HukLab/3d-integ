%%
basename = 'pcorVsCohByDur_elbow';
data = tempint_csvs(basename, subj);
dotmodes = {'2d', '3d'};
params = {'b0', 'b1', 'b2', 'm0', 'm1', 'm2', 'x0', 'x1'};
nboots = 1000;
bootfcn = @median;

%%

for ii = 1:length(dotmodes)
    dotmode = dotmodes{ii};
    inds = strcmp(data.params.dotmode, dotmode);
    if sum(inds) == 0 || sum(inds) == 0
        continue
    end
    for j = 1:numel(params)
        param = params{j};
        xx = getfield(data.params, param);
        x = xx(inds);
        mu = bootfcn(x);
        e = bootci(nboots, bootfcn, x); % default alpha of 0.05
%         e = bootci(nboots, {bootfcn, x}, 'alpha', 1-0.6827);
        figure; clf; hold on;
        hist(x, 50);
        
        plot([mu mu], ylim(), 'r-');
        plot([e(1) e(1)], ylim(), 'r--');
        plot([e(2) e(2)], ylim(), 'r--');
        title(param);
        disp([dotmode ',' param ',' num2str(e(1)) ',' num2str(mu) ',' num2str(e(2))]);
    end
end
