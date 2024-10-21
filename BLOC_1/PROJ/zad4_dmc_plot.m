clear all;
set(0, 'defaulttextinterpreter','latex');
set(0, 'DefaultLineLineWidth',1);
set(0, 'DefaultStairLineWidth',1);

D = 150;
N = 25;
Nu = 1;
lambda = 5;
start = 20;
kend = 100;


[y, u] = zad4_dmc(N, Nu, D, lambda, start, kend, 5.3, start);
len = length(y);
yzad = ones(kend, 1) * 5;
yzad(start:end) = 5.3;

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