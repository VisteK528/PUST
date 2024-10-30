clear all;
D = 600 ;
Upp = 26;
du = 19;
du_min = -100;
du_max = 100;

u_min = 0;
u_max = 100;

name = "data/zad2_step_value=" + string(Upp + du) + ".csv";
raw_data = load(name);
Ypp = raw_data(1, 1);

% Process approximation
[xopt, td] = approximation2(Upp + du, Upp, raw_data);
% td = 1;
% K = 0.735047;
% T1 = 11.604024;
% T2=83.947848;
K = xopt(1);
T1 = xopt(2);
T2 = xopt(3);

% Step response normalized of approximated process
s = stepResponseNormalized(Upp, Ypp, du, D, K, T1, T2, td);
[a, b] = calculate_coefficients(T1, T2, K);


heater_temp = raw_data(:, 1);
N = length(heater_temp);
u = ones(N, 1) * (Upp + du);
y = ones(N, 1) * heater_temp(1);

error = 0;
for k=2:N
    if(k - td - 1 < 1)
        uktdm1 = Upp;
    else
        uktdm1 = u(k - td - 1);
    end

    if(k - td - 2 < 1)
        uktdm2 = Upp;
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

    y(k) = heating_station_simulation(uktdm1, uktdm2, ykm1, ykm2, a, b);
    error = error + (y(k) - heater_temp(k))^2;
end

figure;
stairs(y);
hold on;
stairs(heater_temp);
%hold on;
%scatter(1:D, s);
legend("Approximated", "Measured")