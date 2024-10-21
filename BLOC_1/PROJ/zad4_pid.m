clear all;

% Process constants
du_min = -5e-02;
du_max = 5e-02;

u_min = 6e-01;
u_max = 1e+00;

upp = 8e-01;
ypp = 5e+00;

% Digital PID parameters
% Kk - critical gain
% Tk - critical period
% Tp - sampling period

Kk = 0.661505;
Tk = 19.6;
Tp = 0.5;
[r2, r1, r0] = discrete_pid_parameters(Kk, Tk, Tp);

% General settings
iterations = 600;
kstart = 12;


u = ones(1, iterations) * upp;
y = ones(1, iterations) * ypp;
e = zeros(1, iterations);

% Set trajectory
step1_time = 10;
step2_time = 150;
step3_time = 300;
step4_time = 450;

step1_value = ypp + 0.05;
step2_value = ypp + 0.15;
step3_value = ypp + 0.01;
step4_value = ypp + 0.19;

yzad(1:step1_time) = ypp;
yzad(step1_time:step2_time) = step1_value;
yzad(step2_time:step3_time) = step2_value;
yzad(step3_time:step4_time) = step3_value;
yzad(step4_time:iterations) = step4_value;

% Validation
e_sum = 0;


% Main loop
for k=kstart:iterations

    % Generate process output
    y(k) = symulacja_obiektu11y_p1(u(k-10), u(k-11), y(k-1), y(k-2));
    
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

figure;
stairs(1:len, u);