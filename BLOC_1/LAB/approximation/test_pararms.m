clear all;

working_point = 26;
step_value = 45;

name = "data/zad2_step_value=" + string(step_value) + ".csv";
raw_data = load(name);
[xopt, td] = approximation(step_value, working_point, raw_data);


heater_temp = raw_data(:, 1);
environment_temp = raw_data(:, 2);

K = xopt(1);
T1 = xopt(2);
T2 = xopt(3);
% error = approx_goal_func(td, working_point, step_value, heater_temp, xopt(1), xopt(2), xopt(3));
% disp(error);
N = length(heater_temp);
u = ones(N, 1) * step_value;
y = ones(N, 1) * heater_temp(1);

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
        ykm1 = heater_temp(1);
    else
        ykm1 = y(k-1);
    end

    if(k - 2 < 1)
        ykm2 = heater_temp(1);
    else
        ykm2 = y(k-2);
    end

    y(k) = heating_station_simulation(K, T1, T2, uktdm1, uktdm2, ykm1, ykm2);
    error = error + (y(k) - heater_temp(k))^2;
end

figure;
stairs(y);
hold on;
stairs(heater_temp);
legend("Approximated", "Measured");