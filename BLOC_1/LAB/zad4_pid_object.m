clear all;

% Initialize communication with the heating station
addpath('D:\SerialCommunication'); 
initSerialControl COM7 

% File name to acquired data
test_number = 1;
name = "data/PID_object_" + string(test_number) + ".csv";

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
% Kk - critical gain
% Tk - critical period
% Tp - sampling period
Tp = 1;

Kk = 49.48;
Tk = 13;

[r2, r1, r0] = discrete_pid_parameters(Kk, Tk, Tp);

% [r2, r1, r0] = discrete_pid_parameters_tuning(Kp, inf, 0, Tp);


% General settings
iterations = 600;
kstart = 12;


u = ones(1, iterations) * upp;
y = ones(1, iterations) * ypp;
y_simulation = ones(1, iterations) * ypp;
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

% Preparing files
file_id = fopen(name, 'a');
fprintf(file_id, "u(k), y(k), y_simulation(k)\n");

buffer_size = 15;
buffer = zeros(buffer_size, 3);
buffer_index = 1;

% Make window with plots
figure;
hold on;
h_u = stairs(1:kstart, u(1:kstart), 'DisplayName', 'u');
h_y = stairs(1:kstart, y(1:kstart), 'DisplayName', 'y');
h_y_sim = stairs(1:kstart, y_simulation(1:kstart), 'DisplayName', 'y\_simulation');
hold off;

title("Wykres sterowania i odpowiedzi stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;


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

    y(k) = readMeasurements(1);
    y_simulation(k) = heating_station_simulation(uktdm1, uktdm2, ykm1, ykm2, a, b);
    
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

    sendControls([1, 5], [50, u(k)]);

    % Add data to buffer
    buffer(buffer_index, :) = [u(k), y(k), y_simulation(k)];
    buffer_index = buffer_index + 1;

    % Write data to file
    if buffer_index > buffer_size
        fprintf(file_id, '%f, %f, %f\n', buffer');
        buffer_index = 1;
    end

    % Update plots
    set(h_u, 'XData', 1:k, 'YData', u(1:k));
    set(h_y, 'XData', 1:k, 'YData', y(1:k));
    set(h_y_sim, 'XData', 1:k, 'YData', y_simulation(1:k));
    drawnow;

    waitForNewIteration();

end

fclose(fileId);
sendControls([1, 5], [50, 26]);

fprintf("Error sum: %02f \r\n", e_sum);

% % Print plots
% len = length(y);
% 
% figure;
% stairs(1:len, y);
% hold on;
% stairs(1:len, yzad, '--');
% ylabel("y, yzad")
% xlabel("k")
% 
% figure;
% stairs(1:len, u);
% ylabel("u")
% xlabel("k")