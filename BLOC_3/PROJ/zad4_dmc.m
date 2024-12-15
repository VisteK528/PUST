clear;
set(0, 'defaulttextinterpreter','latex');
set(0, 'DefaultLineLineWidth',1);
set(0, 'DefaultStairLineWidth',1);

Ypp = 0;

D = 50;
N = 50;
Nu = 1;
lambda = 1;

start = 10;
kend = 800;

% Set trajectory
step1_value = 0.02;
step2_value = 0.06;
step3_value = -0.05;
step4_value = -0.2;

[y, u, e_sum] = dmc(N, Nu, D, lambda, 0, step1_value, step2_value, step3_value, step4_value);

len = length(y);

step1_time = 10;
step2_time = 200;
step3_time = 400;
step4_time = 600;

yzad(1:step1_time) = Ypp;
yzad(step1_time:step2_time) = step1_value;
yzad(step2_time:step3_time) = step2_value;
yzad(step3_time:step4_time) = step3_value;
yzad(step4_time:kend) = step4_value;

fprintf("Error sum: %02f \r\n", e_sum);

figure;
stairs(1:len, y);
hold on;
stairs(1:len, yzad, '--');

% legend("$y(k)$", "$y_{zad}(k)$", 'fontsize', 12, 'Interpreter','latex');
xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter','latex');

%exportgraphics(gcf, 'images/proj_lin_dmc_y.pdf', 'ContentType', 'vector');

figure;
stairs(1:len, u);

xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$u$', 'fontsize', 14, 'Interpreter','latex');

%exportgraphics(gcf, 'images/proj_lin_dmc_u.pdf', 'ContentType', 'vector');