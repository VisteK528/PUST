clear all;

export_pictures = 0;
file_number = 11;

% Wczytanie danych
file_path = "lab2_dmc_data/DMC_object_" + string(file_number) + ".csv";
raw_data = readmatrix(file_path, 'NumHeaderLines', 1);

u = raw_data(:, 1);
y = raw_data(:, 2);
k_number = length(u);

% Trajektoria y_zad oraz z
Ypp = 34.1;
y_set_value = 45;
y_set_time = 20;

z_time_step_1 = 250;
z_time_step_2 = 425;
z_step_1 = 30;
z_step_2 = 10;

z = zeros(k_number, 1);
z(z_time_step_1:z_time_step_2) = z_step_1;
z(z_time_step_2:k_number) = z_step_2;

y_zad = zeros(k_number, 1);
y_zad(1:y_set_time) = Ypp;
y_zad(y_set_time:k_number) = y_set_value;

%% Obliczenie sumy kwadratów błędów
errors = (y - y_zad).^2; 
SSE = sum(errors);        

% Wyświetlenie SSE w terminalu
fprintf("Sum of Squared Errors: %.6f \n", SSE);


%% Tworzenie wykresów
x0 = 80;
y0 = 80;
width = 710;
height = 400;

% y(k)
figure;
hold on;
stairs(y, 'DisplayName', '$y(k)$');
stairs(y_zad, '--', 'DisplayName', '$y_{zad}(k)$');
xline(z_time_step_1, '--', 'HandleVisibility', 'off'); % Ukrycie tej linii w legendzie
xline(z_time_step_2, '--', 'HandleVisibility', 'off'); % Ukrycie tej linii w legendzie
plot(nan, nan, 'black--', 'DisplayName', 'z\_step moments'); % Dodanie linii tylko do legendy
hold off;

xlabel('k', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$y(k)$', 'Interpreter', 'latex', 'FontSize', 12);
title('Process output', 'Interpreter', 'latex', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast');

grid on;
grid(gca, 'minor');

set(gcf, 'position', [x0, y0, width, height]);
file_name = sprintf("images/ex5_dmc_lab_y_%d.pdf", file_number);

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end

% u(k)
figure;
hold on;
stairs(u, 'DisplayName', '$u(k)$');
xline(z_time_step_1, '--', 'HandleVisibility', 'off');
xline(z_time_step_2, '--', 'HandleVisibility', 'off'); 
plot(nan, nan, 'black--', 'DisplayName', 'z\_step moments'); 
hold off;

xlabel('k', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$u(k)$', 'Interpreter', 'latex', 'FontSize', 12);
title('Process input', 'Interpreter', 'latex', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 10, 'Location', 'southeast');

grid on;
grid(gca, 'minor');

set(gcf, 'position', [x0, y0, width, height]);
file_name = sprintf("images/ex5_dmc_lab_u_%d.pdf", file_number);

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end

% z(k)
figure;
hold on;
stairs(z, 'DisplayName', '$z(k)$');
xline(z_time_step_1, '--', 'HandleVisibility', 'off');
xline(z_time_step_2, '--', 'HandleVisibility', 'off'); 
plot(nan, nan, 'black--', 'DisplayName', 'z\_step moments');
hold off;

xlabel('k', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$u(k)$', 'Interpreter', 'latex', 'FontSize', 12);
title('Disturbance', 'Interpreter', 'latex', 'FontSize', 12);

ylim([-5 35]);

grid on;
grid(gca, 'minor');

set(gcf, 'position', [x0, y0, width, height]);
file_name = sprintf("images/ex5_dmc_lab_z_%d.pdf", file_number);

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end