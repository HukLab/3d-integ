function ci = pcorBootstrap(xs, ps, ntrials, nboots)
% ps is a vector of probabilities
% xs, ps, ntrials are all the same length
%
% returns the bootstrap s.e. for each p in ps
%   after bootstrapping data nboots times

    if nargin < 4
        nboots = 10000;
    end
    nt = max(ntrials);
    nc = floor(ps .* ntrials);
    nd = ntrials - nc;
    data = zeros(nt, numel(xs));
    for ii = 1:numel(xs)
        data(:,ii) = [ones(nc(ii), 1); zeros(nd(ii), 1); nan(nt - nd(ii) - nc(ii), 1)];
    end
    ci = bootci(nboots, @nanmean, data)';

end
