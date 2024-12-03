clear all;

export_pictures = 1;

working_point = 0;
step_value = 45;

% name = "data/zad2_disturbance2_step=" + string(step_value) + ".csv";
name = "data/l2_step_value=45.csv";
raw_data = load(name);

% Process approximation
[xopt, td] = approximation(step_value, working_point, raw_data);
K = xopt(1);
T1 = xopt(2);
T2 = xopt(3);

heater_temp = raw_data(:, 1);
heater_temp_normalized = (heater_temp - ones(size(heater_temp))* ...
    heater_temp(1))/(step_value - working_point);

% Step response normalized of approximated process
s_normalized = step_response(0, 0, length(heater_temp_normalized), K, T1, T2, td);

figure;
hold on;
stairs(s_normalized, 'DisplayName', 'approximated');
stairs(heater_temp_normalized, 'DisplayName', 'measured');
hold off;

xlabel('k', 'Interpreter', 'latex', 'FontSize', 12);
ylabel('$y(k)$', 'Interpreter', 'latex', 'FontSize', 12);
title('Result of approximation for step\_value=' + string(step_value), ...
    'Interpreter', 'latex', 'FontSize', 12);
legend('Interpreter', 'latex', 'FontSize', 10, 'Location', 'northwest');

grid on;
grid(gca, 'minor');

x0 = 20;
y0 = 70;
width = 710;
height = 400;
set(gcf, 'position', [x0, y0, width, height]);
% file_name = sprintf("images/ex3_approximated_step_responses_" + ...
%     "normalized_step=%d.pdf", step_value);
file_name = sprintf("images/ex3_approximated_u_step_responses_" + ...
    "normalized_step=%d.pdf", step_value);

if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end
