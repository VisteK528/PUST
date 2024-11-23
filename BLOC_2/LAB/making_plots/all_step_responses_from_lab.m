export_pictures = 0;

% Zdefiniowane wartości z_step
z_step1 = 5;
z_step2 = 10;
z_step3 = 20;
z_step4 = 30;

% Wczytanie danych
raw_data1 = load("data/zad2_disturbance2_step=" + string(z_step1) + ".csv");
yz1 = raw_data1(:, 1);
raw_data2 = load("data/zad2_disturbance2_step=" + string(z_step2) + ".csv");
yz2 = raw_data2(:, 1);
raw_data3 = load("data/zad2_disturbance2_step=" + string(z_step3) + ".csv");
yz3 = raw_data3(:, 1);
raw_data4 = load("data/zad2_disturbance2_step=" + string(z_step4) + ".csv");
yz4 = raw_data4(:, 1);

% Tworzenie wykresu
figure;
hold on;
stairs(yz1, 'DisplayName', ['$z\_step = ', num2str(z_step1), '$']);
stairs(yz2, 'DisplayName', ['$z\_step = ', num2str(z_step2), '$']);
stairs(yz3, 'DisplayName', ['$z\_step = ', num2str(z_step3), '$']);
stairs(yz4, 'DisplayName', ['$z\_step = ', num2str(z_step4), '$']);
hold off;

xlabel('k', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$y(k)$', 'Interpreter', 'latex', 'FontSize', 12);
title('Response for different z\_step values', 'Interpreter', 'latex', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 10, 'Location', 'best');

grid on;
grid(gca, 'minor');

x0 = 20;
y0 = 20;
width = 710;
height = 400;
set(gcf, 'position', [x0, y0, width, height]);
file_name = "images/ex2_all_step_responses.pdf";

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end
