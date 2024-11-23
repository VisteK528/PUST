export_pictures = 1;

% Wektor wartości wejściowych
u = [5, 10, 20, 30];
y = [36.61, 36.62, 38.68, 40.75]; 

% Tworzenie wykresu
figure;
plot(u, y, '-o', 'MarkerSize', 4, 'MarkerFaceColor', 'b');
grid on;
grid(gca, 'minor');

xlabel('$u$', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$y(u)$', 'Interpreter', 'latex', 'FontSize', 12);
title('Static characteristics', 'Interpreter', 'latex', 'FontSize', 12);

x0 = 20;
y0 = 60;
width = 710;
height = 400;
set(gcf, 'position', [x0, y0, width, height]);
file_name = "images/ex2_static_characteristics.pdf";

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end