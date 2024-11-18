
Upp = 0;
Zpp = 0;
Ypp = 0;

[y] = step_response(Upp, Ypp, 50, 1, 0, "u");

figure;
stairs(y);

grid on;
grid(gca, 'minor');
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('y', 'fontsize', 14, 'Interpreter', 'latex');

% Set figure size and position
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);
name = "images/zad1_check_object.png";
exportgraphics(gcf, name, 'Resolution', 400);
