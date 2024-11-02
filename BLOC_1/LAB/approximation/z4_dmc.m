clear;

D = 600;
N = 35;
Nu = 1;
lambda = 0.1;
start = 20;
kend = 600;

zad_value = 38;

[y, u] = dmc(N, Nu, D, lambda, start, kend, zad_value, start);

yzad = ones(kend, 1) * y(1);
yzad(start:end) = zad_value;

figure;
stairs(1:kend, y);
hold on;
stairs(1:kend, yzad, '--');

figure;
stairs(1:kend, u);