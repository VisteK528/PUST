clear all;
D = 600 ;
working_point = 26;
step_value = 35;

name = "data/zad2_step_value=" + string(step_value) + ".csv";
raw_data = load(name);
Ypp = raw_data(1, 1);

% Process approximation
[xopt, td] = approximation(step_value, working_point, raw_data);
% td = 1;
% K = 0.735047;
% T1 = 11.604024;
% T2 = 83.947848;
K = xopt(1);
T1 = xopt(2);
T2 = xopt(3);

% Step response normalized of approximated process
s = step_response(working_point, Ypp, D, K, T1, T2, td);
[a, b] = calculate_coefficients(T1, T2, K);


heater_temp = raw_data(:, 1);
heater_temp_normalized = (heater_temp - ones(size(heater_temp))* ...
    heater_temp(1))/(step_value - working_point);

working_point_normalized = 0;
step_value_normalized = 1;

N = length(heater_temp_normalized);
u = ones(N, 1) * step_value_normalized;
y = ones(N, 1) * heater_tempworking_point_normalized = 0;
step_value_normalized = 1;(1);

error = 0;
for k=2:N
    if(k - td - 1 < 1)
        uktdm1 = working_point;
    else
        uktdm1 = u(k - td - 1);
    end

    if(k - td - 2 < 1)
        uktdm2 = working_point;
    else
        uktdm2 = u(k - td - 2);
    end

    if(k - 1 < 1)
        ykm1 = Ypp;
    else
        ykm1 = y(k-1);
    end

    if(k - 2 < 1)
        ykm2 = Ypp;
    else
        ykm2 = y(k-2);
    end

    y(k) = heating_station_simulation(uktdm1 - working_point, uktdm2 - working_point, ...
        ykm1 - Ypp, ykm2 - Ypp, a, b);
    error = error + (y(k) - heater_temp(k))^2;
end

figure;
stairs(y);
hold on;
stairs(heater_temp);
stairs(1:D, s);
hold off;
legend("Approximated", "Measured", "Step response vector");