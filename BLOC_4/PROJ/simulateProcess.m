clear all;

kstart = 50;
kend = 500;

D = 250;
N = 100;
Nu = 100;
psi = [1 1 1]';
lambda = [1 1 1 1]';

nu = 4;
ny = 3;
[S, H] = stepResponses(D, nu, ny);


u = zeros(kend, nu);
y = zeros(kend, ny);
yzad = zeros(kend, ny);

% TODO - yzad trajectory

yzad(50:end, 1) = 2.5;
yzad(50:end, 2) = 5.5;
yzad(50:end, 3) = 1.75;

%

deltauk_p = zeros((D-1)*nu, 1);

[K, MP, Ke, Ku] = offlineMIMO_DMC(H, psi, lambda, N, Nu);

for k=kstart:kend
    [y1, y2, y3] = symulacja_obiektu11y_p4(u(k-1, 1), u(k-2, 1), ...
        u(k-3, 1), u(k-4, 1), u(k-1, 2), u(k-2, 2), u(k-3, 2), ...
        u(k-4, 2), u(k-1, 3), u(k-2, 3), u(k-3, 3), u(k-4, 3), ...
        u(k-1, 4), u(k-2, 4), u(k-3, 4), u(k-4, 4), y(k-1, 1), ...
        y(k-2, 1), y(k-3, 1), y(k-4, 1), y(k-1, 2), y(k-2, 2), ...
        y(k-3, 2), y(k-4, 2), y(k-1, 3), y(k-2, 3), y(k-3, 3), ...
        y(k-4, 3));

    y(k, 1) = y1;
    y(k, 2) = y2;
    y(k, 3) = y3;

    yzad_rep = repmat(yzad(k, :)', N, 1);
    y_rep = repmat(y(k, :)', N, 1);

    deltaU = K*(yzad_rep - y_rep - MP*deltauk_p);

    for n=(D-1)*nu:-nu:2*nu
        array = deltauk_p(n-4-nu+1:n-nu);
        deltauk_p(n-3:n) = array;
    end

    u(k, :) = u(k-1, :) + deltaU(1:4)';

    deltauk_p(1:4) = deltaU(1:4);

    
end

figure;
for i=1:ny
    subplot(3, 1, i);
    stairs(y(:, i));
end