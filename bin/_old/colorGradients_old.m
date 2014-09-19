n = 20;
xs = 1:n;
ys = ones(1,n);

N = 20;
minN = N-n;
colors2d = summer(N);
colors2d = colors2d(end:-1:1,:);

colors2d(:,1) = logspace(0.1, 1, N)/10;
% colors2d(:,1) = colors2d(:,2)*2 - 1;
colors2d(:,2) = 0.8;
colors2d(:,3) = 0.0;

colors3d = autumn(N);
% colors3d = colors3d(end:-1:1,:);
colors3d(:,1) = 0.9;
colors3d(:,2) = logspace(1.0, 0.1, N)/10;
% colors3d(:,2) = colors3d(:,2)*2 - 1;
% colors3d(:,3) = 0.0;


% s1 = [0.7 1.0 0.7];
s1 = [0.9 1.0 1.0];
s2 = [0.0 0.8 0.0];
ds = s2 - s1;
dsd = zeros(N, 3);
for ii = 1:numel(s1)
    dsd(:,ii) = linspace(0, ds(ii), N);
end
colors2d = repmat(s1, N, 1) + dsd;

% s1 = [1.0 0.7 0.7];
s1 = [1.0 1.0 0.8];
s2 = [0.8 0.0 0.0];
ds = s2 - s1;
dsd = zeros(N, 3);
for ii = 1:numel(s1)
    dsd(:,ii) = linspace(0, ds(ii), N);
end
colors3d = repmat(s1, N, 1) + dsd;

figure(1); clf; hold on;
lw = 1.5;
for ii = 1:n
    color = colors2d(ii+minN,:);
    scatter(xs(ii), ys(ii), 100, 'MarkerEdgeColor', color, 'MarkerFaceColor', color, 'LineWidth', lw); 
end
for ii = 1:n
    color = colors3d(ii+minN,:);
    scatter(xs(ii), ys(ii)+1, 100, 'MarkerEdgeColor', color, 'MarkerFaceColor', color, 'LineWidth', lw); 
end
xlim([0, n+1]);
ylim([0, 10]);
