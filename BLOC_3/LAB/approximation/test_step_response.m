clear;

D = 400;
working_point = 0;
step_value = 20;

name = "data/zad2_disturbance2_step=" + string(step_value) + ".csv";
% name = "../data/l2_step_value=45.csv";
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
s = step_response(0, 0, D, K, T1, T2, td);

figure;
hold on;
stairs(1:D, s);
stairs(heater_temp_normalized);
hold off;
legend("Step response", "Measured", "Location","northwest");