clear;

D = 250;
N = 50;
Nu = 1;
lambda = 0.1;
start = 20;
kend = 400;

zad_value = 40;

[y, u] = dmc(N, Nu, D, lambda, start, kend, zad_value, start);

yzad = ones(kend, 1) * y(1);
yzad(start:end) = zad_value;

figure;
stairs(1:kend, y);
hold on;
stairs(1:kend, yzad, '--');

figure;
stairs(1:kend, u);