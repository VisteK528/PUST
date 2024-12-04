clear all;

tuning_proces = 0;

working_point_u = 60;
step_value = 70;

data_table = readtable("data/stepResponse_u=" + string(step_value) + ".csv");
heater_temp = data_table.heater_temp; % kolumna 'y'
enviroment_temp = data_table.environment_temp;
raw_data = [heater_temp enviroment_temp];

Upp_normalized = 0;
step_value_normalized = 1;
Ypp_normalized = 0;

[xopt, td] = approximation(step_value, working_point_u, raw_data);


% Process constants
du_min = -20 / (step_value - working_point_u);
du_max = 20 / (step_value - working_point_u);

u_min = 0 / (step_value - working_point_u);
u_max = 100 / (step_value - working_point_u);

% Model coefficients
K = xopt(1);
T1 = xopt(2);
T2 = xopt(3);

[a, b] = calculate_coefficients(T1, T2, K);

% Digital PID parameters
Tp = 1;         % sampling period
Kp = 92;      % gain (using in tuning Ziegler-Nichols method)
Kk = 92;      % critical gain
Tk = 32;        % critical period

if tuning_proces == 1
    [r2, r1, r0] = discrete_pid_parameters(Kp, inf, 0, Tp);
    iterations = 20000;
elseif tuning_proces == 0
    [r2, r1, r0] = discrete_pid_parameters_ziegler_nichols(Kk, Tk, Tp); 
    iterations = 800;
end

% Set trajectory
% Step times
step1_time = 200;
step2_time = 400;
step3_time = 600;
step4_time = 800;

% Step values and normalization
step1_value = 65;
step2_value = 80;
step3_value = 60;
step4_value = 80;

if tuning_proces == 0
    yzad(1:step1_time) = heater_temp(1);
    yzad(step1_time:iterations) = step1_value;
    yzad(step2_time:step3_time) = step2_value;
    yzad(step3_time:step4_time) = step3_value;
    yzad(step4_time:iterations) = step4_value;
    
    yzad_normalized(1:step1_time) = Ypp_normalized;
    yzad_normalized(step1_time:iterations) = (step1_value - heater_temp(1)) ...
        / (step_value - working_point_u);
    yzad_normalized(step2_time:step3_time) = (step2_value - heater_temp(1)) ...
        / (step_value - working_point_u);
    yzad_normalized(step3_time:step4_time) = (step3_value - heater_temp(1)) ...
        / (step_value - working_point_u);
    yzad_normalized(step4_time:iterations) = (step4_value - heater_temp(1)) ...
        / (step_value - working_point_u);

elseif tuning_proces == 1
    yzad(1:30) = heater_temp(1);
    yzad(30:iterations) = heater_temp(1) + 10;

    yzad_normalized(1:30) = Ypp_normalized;
    yzad_normalized(30:iterations) = 10 / (step_value - working_point_u);
end


% General settings
kstart = 12;

u_normalized = ones(1, iterations) * Upp_normalized;
y_normalized = ones(1, iterations) * Ypp_normalized;
e = zeros(1, iterations);

% Validation
e_sum = 0;

% Main loop
for k=kstart:iterations
    if(k - td - 1 < 1)
        uktdm1 = Upp_normalized;
    else
        uktdm1 = u_normalized(k - td - 1);
    end
    
    if(k - td - 2 < 1)
        uktdm2 = Upp_normalized;
    else
        uktdm2 = u_normalized(k - td - 2);
    end
    
    if(k - 1 < 1)
        ykm1 = Ypp_normalized;
    else
        ykm1 = y_normalized(k-1);
    end
    
    if(k - 2 < 1)
        ykm2 = Ypp_normalized;
    else
        ykm2 = y_normalized(k-2);
    end
    
    y_normalized(k) = heating_station_simulation(uktdm1, uktdm2, ...
        ykm1, ykm2, a, b);
    
    % Compute error
    e(k) = yzad_normalized(k) - y_normalized(k);
    e_sum = e_sum + e(k)^2;
    
    % Compute manipulate variable for discrete time k
    u_normalized(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u_normalized(k-1);

    % Constrains on speed and value
    du = u_normalized(k) - u_normalized(k-1);

    if(du < du_min)
        du = du_min;
    elseif(du > du_max)
        du = du_max;
    end

    u_normalized(k) = u_normalized(k-1) + du;

    if(u_normalized(k) < u_min)
        u_normalized(k) = u_min;
    elseif(u_normalized(k) > u_max)
        u_normalized(k) = u_max;
    end

end

y = y_normalized * (step_value - working_point_u) + heater_temp(1);
u = u_normalized * (step_value - working_point_u);

len = length(y);

fprintf("Error sum: %02f \r\n", e_sum);

figure;
stairs(1:len, y);
hold on;
stairs(1:len, yzad, '--');
ylabel("y, yzad")
xlabel("k")

figure;
stairs(1:len, u);
ylabel("u")
xlabel("k")