clear all;

working_point = 26;
step_value = 35;

name = "data/zad2_step_value=" + string(step_value) + ".csv";
raw_data = load(name);

heater_temp = raw_data(1:500, 1);
heater_temp_normalized = (heater_temp - ones(size(heater_temp))* ...
    heater_temp(1))/(step_value - working_point);

working_point_normalized = 0;
step_value_normalized = 1;

[xopt, td] = approximation(step_value, working_point, raw_data);

K = xopt(1);
T1 = xopt(2);
T2 = xopt(3);

N = length(heater_temp_normalized);
u = ones(N, 1) * step_value_normalized;
y_normalized = ones(N, 1) * heater_temp_normalized(1);
[a, b] = calculate_coefficients(T1, T2, K);

error = 0;
for k=1:N
    if(k - td - 1 < 1)
        uktdm1 = working_point_normalized;
    else
        uktdm1 = u(k - td - 1);
    end

    if(k - td - 2 < 1)
        uktdm2 = working_point_normalized;
    else
        uktdm2 = u(k - td - 2);
    end

    if(k - 1 < 1)
        ykm1 = heater_temp_normalized(1);
    else
        ykm1 = y_normalized(k-1);
    end

    if(k - 2 < 1)
        ykm2 = heater_temp_normalized(1);
    else
        ykm2 = y_normalized(k-2);
    end

    y_normalized(k) = heating_station_simulation(uktdm1, uktdm2, ...
        ykm1, ykm2, a, b);
    error = error + (y_normalized(k) - heater_temp_normalized(k))^2;
end

y = y_normalized * (step_value - working_point) + heater_temp(1);

fprintf("Td=%d\r\n", best_td);
fprintf("K=%f\r\n", xopt(1));
fprintf("T1=%f\r\n", xopt(2));
fprintf("T2=%f\r\n", xopt(3));
fprintf("Error: %f\r\n", error);

figure;
stairs(y);
hold on;
stairs(heater_temp);
legend("Approximated", "Measured", "Location","northwest");

figure;
stairs(y_normalized);
hold on;
stairs(heater_temp_normalized);
legend("Approximated", "Measured", "Location","northwest");