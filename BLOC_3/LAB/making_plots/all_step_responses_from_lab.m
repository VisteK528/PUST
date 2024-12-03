export_pictures = 0;

% Zdefiniowane wartości z_step
z_step1 = 20;
z_step2 = 30;
z_step3 = 40;
z_step4 = 50;
z_step5 = 60;
z_step6 = 70;

% Wczytanie danych
raw_data1 = readtable("data/stepResponse_u=" + string(z_step1) + ".csv");
yz1 = raw_data1{:, 1}; 
raw_data2 = readtable("data/stepResponse_u=" + string(z_step2) + ".csv");
yz2 = raw_data2{:, 1};
raw_data3 = readtable("data/stepResponse_u=" + string(z_step3) + ".csv");
yz3 = raw_data3{:, 1};
raw_data4 = readtable("data/stepResponse_u=" + string(z_step4) + ".csv");
yz4 = raw_data4{:, 1};
raw_data5 = readtable("data/stepResponse_u=" + string(z_step5) + ".csv");
yz5 = raw_data5{:, 1};
raw_data6 = readtable("data/stepResponse_u=" + string(z_step6) + ".csv");
yz6 = raw_data6{:, 1};

% Tworzenie wykresu
figure;
hold on;
stairs(yz1, 'DisplayName', ['$z\_step = ', num2str(z_step1), '$']);
stairs(yz2, 'DisplayName', ['$z\_step = ', num2str(z_step2), '$']);
stairs(yz3, 'DisplayName', ['$z\_step = ', num2str(z_step3), '$']);
stairs(yz4, 'DisplayName', ['$z\_step = ', num2str(z_step4), '$']);
stairs(yz5, 'DisplayName', ['$z\_step = ', num2str(z_step5), '$']);
stairs(yz6, 'DisplayName', ['$z\_step = ', num2str(z_step6), '$']);
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
