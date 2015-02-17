function ticks = uncrowdTicks(ticks, cutoff, isLogScale)
    if nargin < 3
        isLogScale = true;
    end
    if nargin < 2
        if isLogScale
            cutoff = 10;
        else
            cutoff = 5;
        end
    end
    if isLogScale
        df = @(x) x(2:end) ./ x(1:end-1);
    else
        df = @(x) diff(x);
    end
    while ~all(df(ticks) > cutoff)
        ticks = ticks([true df(ticks) > cutoff]);
    end
end
