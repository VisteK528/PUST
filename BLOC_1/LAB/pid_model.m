clear all;

% Process constants
du_min = -20;
du_max = 20;

u_min = 0;
u_max = 100;

upp = 26;
ypp = 33.18;

% Model coefficients
td = 2;
K = 0.892852;
T1 = 1.000002;
T2 = 85.439497;

[a, b] = calculate_coefficients(T1, T2, K);

% Digital PID parameters
Tp = 1; % sampling period
Kk = 49.48; %critical gain
Tk = 13; % critical period

[r2, r1, r0] = discrete_pid_parameters(Kk, Tk, Tp);

% [r2, r1, r0] = discrete_pid_parameters_tuning(Kp, inf, 0, Tp);


% General settings
iterations = 600;
kstart = 12;

u = ones(1, iterations) * upp;
y = ones(1, iterations) * ypp;
e = zeros(1, iterations);

% Set trajectory
step1_time = 20;
step2_time = 150;
step3_time = 300;
step4_time = 450;

step1_value = 40;
step2_value = 45;
step3_value = 60;
step4_value = 50;

yzad(1:step1_time) = ypp;
yzad(step1_time:iterations) = step1_value;
yzad(step2_time:step3_time) = step2_value;
yzad(step3_time:step4_time) = step3_value;
yzad(step4_time:iterations) = step4_value;

% Validation
e_sum = 0;


% Main loop
for k=kstart:iterations
    if(k - td - 1 < 1)
        uktdm1 = upp;
    else
        uktdm1 = u(k - td - 1);
    end
    
    if(k - td - 2 < 1)
        uktdm2 = upp;
    else
        uktdm2 = u(k - td - 2);
    end
    
    if(k - 1 < 1)
        ykm1 = ypp;
    else
        ykm1 = y(k-1);
    end
    
    if(k - 2 < 1)
        ykm2 = ypp;
    else
        ykm2 = y(k-2);
    end
    
    y(k) = heating_station_simulation(uktdm1, uktdm2, ykm1, ykm2, a, b);
    
    % Compute error
    e(k) = yzad(k) - y(k);
    e_sum = e_sum + e(k)^2;
    
    % Compute manipulate variable for discrete time k
    u(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u(k-1);

    % Constrains on speed and value
    du = u(k) - u(k-1);

    if(du < du_min)
        du = du_min;
    elseif(du > du_max)
        du = du_max;
    end

    u(k) = u(k-1) + du;

    if(u(k) < u_min)
        u(k) = u_min;
    elseif(u(k) > u_max)
        u(k) = u_max;
    end

end
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