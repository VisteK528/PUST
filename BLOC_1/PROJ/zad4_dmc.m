clear;
set(0, 'defaulttextinterpreter','latex');
set(0, 'DefaultLineLineWidth',1);
set(0, 'DefaultStairLineWidth',1);

Ypp = 5;

D = 150;
N = 30;
Nu = 3;
lambda = 0.0116;
start = 10;
kend = 800;

% Set trajectory
step1_value = 0.05;
step2_value = -0.05;
step3_value = 0.12;
step4_value = 0.19;

[y, u, e_sum] = simulateDMC(N, Nu, D, lambda, step1_value, step2_value, step3_value, step4_value);

len = length(y);

step1_time = 10;
step2_time = 200;
step3_time = 400;
step4_time = 600;

yzad(1:step1_time) = Ypp;
yzad(step1_time:step2_time) = Ypp + step1_value;
yzad(step2_time:step3_time) = Ypp + step2_value;
yzad(step3_time:step4_time) = Ypp + step3_value;
yzad(step4_time:kend) = Ypp + step4_value;

fprintf("Error sum: %02f \r\n", e_sum);

% Plot graphs
set(0, 'defaulttextinterpreter','latex');
set(0, 'DefaultLineLineWidth',1);
set(0, 'DefaultStairLineWidth',1);
resolution_dpi = 300;
export_pictures = true;

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

% Save to file
name1 = "plot_data/z6_dmc_u.txt";
writematrix(u, name1);
name2 = "plot_data/z6_dmc_y.txt";
writematrix([yzad; y']', name2);