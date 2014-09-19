function colors = colorGradient(N, startColor, endColor)
    if nargin < 2
        startColor = [1.0 1.0 0.8];
        endColor = [0.8 0.0 0.0];
    end

    dsd = zeros(N, 3);
    ds = endColor - startColor;
    for ii = 1:numel(startColor)
        dsd(:,ii) = linspace(0, ds(ii), N);
    end
    colors = repmat(startColor, N, 1) + dsd;
end
