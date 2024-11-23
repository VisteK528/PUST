clear;

% Paramaters
start = 20;
kend = 600;
N = 50;
Nu = 6;
D = 400;
Dz = 400;
lambda = 0.01;

% Set value parameters
set_value = 45;
set_time = 50;

% Disturbance parameters
z_start = 300;
z_step = 30;
z = zeros(kend, 1);
z(z_start:kend) = z_step;

consider_disturbance = true;

% Simulation
[y, u] = dmc_with_disturbance_heating_station(start, kend, N, Nu, D, ...
    lambda, Dz, set_time, set_value, z, consider_disturbance);

% Plot graphs
y_zad(1:set_time) = y(1);
y_zad(set_time:kend) = set_value;
len = length(y);

figure;
stairs(1:len, y);
hold on;
stairs(1:len, y_zad, '--');
xline(z_start, 'r--');
title("Wyjście procesu");
xlabel("k");
ylabel("Y / Y_{zad}");
hold off;

figure;
stairs(u);
xline(z_start, 'r--');
title("Sygnał sterujący");
xlabel("k");
ylabel("u");
