clear all;
Upp = 0;
Ypp = 0;

y = step_response(Upp, Ypp, 100, 1, 1, "u");
y_z = step_response(Upp, Ypp, 30, 1, 1, "z");

figure;
stairs(y);
hold on;
scatter(1:length(y), y, 30, 'filled');
grid on;
grid(gca, 'minor');
xlabel('$k$', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter', 'latex');
name = "images/zad2_s_numbers.png";
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);
exportgraphics(gcf, name, 'Resolution', 400);

figure;
stairs(y_z);
hold on;
scatter(1:length(y_z), y_z, 30, 'filled');
grid on;
grid(gca, 'minor');
xlabel('$k$', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter', 'latex');
name = "images/zad2_sz_numbers.png";
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);
exportgraphics(gcf, name, 'Resolution', 400);

