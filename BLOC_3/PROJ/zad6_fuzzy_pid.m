clear;
set(0, 'defaulttextinterpreter','latex');
set(0, 'DefaultLineLineWidth',1);
set(0, 'DefaultStairLineWidth',1);

Ypp = 0;

Kp = [0.1 2];
Ti = [1 15];
Td = [1 2];
start = 10;
kend = 800;
working_points = [-0.3 0.2];

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

[y, u, e_sum] = fuzzyPID(Kp, Ti, Td, start, kend, working_points, yzad);

len = length(y);

fprintf("Error sum: %02f \r\n", e_sum);

figure;
stairs(1:len, y);
hold on;
stairs(1:len, yzad, '--');

x0=10;
y0=10;
width=1280;
height=720;
set(gcf,'position',[x0,y0,width,height]);
grid(gca,'minor');
title('');

legend("$y(k)$", "$y_{zad}(k)$", 'fontsize', 12, 'Interpreter','latex');
xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter','latex');

figure;
stairs(1:len, u);

x0=10;
y0=10;
width=1280;
height=720;
set(gcf,'position',[x0,y0,width,height]);
grid(gca,'minor');
title('');

xlabel('$k$', 'fontsize', 14, 'Interpreter','latex');
ylabel('$u$', 'fontsize', 14, 'Interpreter','latex');