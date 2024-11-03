clear all;

D = 600;
N = 50;
Nu = 6;
lambda = 0.01;
iterations = 600;
start = 20;
set_value = 45;
set_time = 100;

[y, u] = dmc(N, Nu, D, lambda, start, iterations, set_value, set_time);
len = length(y);

% Plot graphs
y_zad(1:set_time) = y(1);
y_zad(set_time:iterations) = set_value;


set(0, 'defaulttextinterpreter','latex');
set(0, 'DefaultLineLineWidth',1);
set(0, 'DefaultStairLineWidth',1);
resolution_dpi = 400;

figure;
stairs(1:len, y);
hold on;
stairs(1:len, y_zad, '--');
grid(gca,'minor');
title('');

legend("$y(k)$", "$y_{zad}(k)$", 'fontsize', 12, 'Interpreter','latex', ...
    'Location','southeast');
xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter','latex');

figure;
stairs(1:len, u);
grid(gca,'minor');
title('');

xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$u$', 'fontsize', 14, 'Interpreter','latex');