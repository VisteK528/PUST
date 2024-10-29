clear;

D = 600;
N = 45;
Nu = 3;
lambda = 3;
start = 20;
kend = 600;

zad_value = 36;

[y, u] = dmc(N, Nu, D, lambda, start, kend, zad_value, start);

yzad = ones(kend, 1) * y(1);
yzad(start:end) = zad_value;

figure;
stairs(1:kend, y);
hold on;
stairs(1:kend, yzad, '--');

figure;
stairs(1:kend, u);