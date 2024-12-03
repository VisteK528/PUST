clear all;

export_pictures = 1;
tuning_iteration_number = 5;

% Paramaters
start = 20;
kend = 600;
N = 400;
Nu = 400;
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

x0 = 80;
y0 = 80;
width = 710;
height = 400;

figure;
hold on;
stairs(1:len, y, 'DisplayName', '$y(k)$');
stairs(1:len, y_zad, '--', 'DisplayName', '$y_{zad}(k)$');
xline(z_start, '--', 'DisplayName', 'z\_step moment');
title('Process output', 'Interpreter', 'latex', 'FontSize', 12);
xlabel('k', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$y(k)$', 'Interpreter', 'latex', 'FontSize', 12);
hold off;
legend('Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast');
grid on;
grid(gca, 'minor');

set(gcf, 'position', [x0, y0, width, height]);
file_name = sprintf("images/ex4_DMC_tuning_y_%d.pdf", tuning_iteration_number);

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end


figure;
hold on;
stairs(u, 'DisplayName', '$u(k)$');
xline(z_start, '--', 'DisplayName', 'z\_step moment');
hold off;
title('Process input', 'Interpreter', 'latex', 'FontSize', 12);
xlabel('k', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$u(k)$', 'Interpreter', 'latex', 'FontSize', 12);
grid on;
grid(gca, 'minor');

set(gcf, 'position', [x0, y0, width, height]);
file_name = sprintf("images/ex4_DMC_tuning_u_%d.pdf", tuning_iteration_number);

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end
