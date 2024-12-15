clear;
set(0, 'defaulttextinterpreter','latex');
set(0, 'DefaultLineLineWidth',1);
set(0, 'DefaultStairLineWidth',1);

Ypp = 0;

D = 50;
N = [50 50 50 50];
Nu = [1 1 1 1];
lambda = [10 10 10 10];
start = 10;
kend = 800;
working_points = [-0.3 -0.05 0.2 0.5];

step1_time = 10;
step2_time = 200;
step3_time = 400;
step4_time = 600;

% Set trajectory
step1_value = 0.02;
step2_value = 0.07;
step3_value = -0.05;
step4_value = -0.2;

yzad(1:step1_time) = Ypp;
yzad(step1_time:step2_time) = step1_value;
yzad(step2_time:step3_time) = step2_value;
yzad(step3_time:step4_time) = step3_value;
yzad(step4_time:kend) = step4_value;

[y, u, e_sum] = fuzzyDMC(N, Nu, D, lambda, working_points, yzad);

len = length(y);

fprintf("Error sum: %02f \r\n", e_sum);

figure;
stairs(1:len, y);
hold on;
stairs(1:len, yzad, '--');

legend("$y(k)$", "$y_{zad}(k)$", 'fontsize', 12, 'Interpreter','latex');
xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter','latex');

%exportgraphics(gcf, 'images/proj_fuzzy_dmcl10_y.pdf', 'ContentType', 'vector');

figure;
stairs(1:len, u);

xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$u$', 'fontsize', 14, 'Interpreter','latex');

%exportgraphics(gcf, 'images/proj_fuzzy_dmcl10_u.pdf', 'ContentType', 'vector');