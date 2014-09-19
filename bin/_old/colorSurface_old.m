[x,y] = meshgrid([-2:.2:2]);
N = size(x,1);

% s1 = [1.0 0.7 0.7];
s1 = [1.0 1.0 0.8];
s2 = [0.8 0.0 0.0];
ds = s2 - s1;
dsd = zeros(N, 3);
for ii = 1:numel(s1)
    dsd(:,ii) = linspace(0, ds(ii), N);
end
colors3d = repmat(s1, N, 1) + dsd;

% s1 = [0.7 1.0 0.7];
s1 = [0.9 1.0 1.0];
s2 = [0.0 0.8 0.0];
ds = s2 - s1;
dsd = zeros(N, 3);
for ii = 1:numel(s1)
    dsd(:,ii) = linspace(0, ds(ii), N);
end
colors2d = repmat(s1, N, 1) + dsd;

colormap(colors2d);
Z = x.*exp(-x.^2-y.^2);
cm = repmat(1:N, N, 1);
surf(x, y, Z, cm);
