function colors = colorGradient(N, startColor, endColor)
    dsd = zeros(N, 3);
    ds = endColor - startColor;
    for ii = 1:numel(startColor)
        dsd(:,ii) = linspace(0, ds(ii), N);
    end
    colors = repmat(startColor, N, 1) + dsd;
end
