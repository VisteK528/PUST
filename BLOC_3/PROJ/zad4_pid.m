clear;

% Process constants
u_min = -1;
u_max = 1;
Upp = 0;
Ypp = 0;

% Digital PID parameters
Kp = 0.6;
Ti = 3;
Td = 1;
[r2, r1, r0] = discrete_pid_parameters(Kp, Ti, Td, 0.5);

% General settings
iterations = 800;
kstart = 10;

u = ones(1, iterations) * Upp;
y = ones(1, iterations) * Ypp;
e = zeros(1, iterations);

% Set trajectory
step1_time = 10;
step2_time = 200;
step3_time = 400;
step4_time = 600;

step1_value = 0.02;
step2_value = 0.06;
step3_value = -0.05;
step4_value = -0.2;

yzad(1:step1_time) = Ypp;
yzad(step1_time:iterations) = step4_value;
%yzad(step2_time:step3_time) = step2_value;
%yzad(step3_time:step4_time) = step3_value;
%yzad(step4_time:iterations) = step4_value;

% Validation
e_sum = 0;

% Main loop
for k=kstart:iterations

    % Generate process output
    y(k) = symulacja_obiektu11y_p3(u(k-5), u(k-6), y(k-1), y(k-2));
    
    % Compute error
    e(k) = yzad(k) - y(k);
    e_sum = e_sum + e(k)^2;
    
    % Compute manipulate variable for discrete time k
    u(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u(k-1);

    % Constrains on value
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
xlabel("k");
ylabel("y");
hold on;
stairs(1:len, yzad, '--');

figure;
stairs(1:len, u);
xlabel("k");
ylabel("u");