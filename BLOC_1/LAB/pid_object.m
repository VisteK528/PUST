clear all;

% Initialize communication with the heating station
addpath('D:\SerialCommunication'); 
initSerialControl COM7 

% Selecting and creating a model
working_point = 26;
step_value = 35;

name = "data/zad2_step_value=" + string(step_value) + ".csv";
raw_data = load(name);

Ypp = raw_data(1, 1);
Upp = working_point;

[xopt, td] = approximation(step_value, working_point, raw_data);
K = xopt(1);
T1 = xopt(2);
T2 = xopt(3);

[a, b] = calculate_coefficients(T1, T2, K);

% File name to acquired data
test_number = 4;
name = "data/PID_object_" + string(test_number) + ".csv";


% Process constants
du_min = -20;
du_max = 20;

u_min = 0;
u_max = 100;


% Digital PID parameters
Tp = 1;         % sampling period
Kp = 69.4;      % gain (using in tuning Ziegler-Nichols method)
Kk = 30;        % critical gain
Tk = 80;        % critical period

[r2, r1, r0] = discrete_pid_parameters_ziegler_nichols(Kk, Tk, Tp);

% [r2, r1, r0] = discrete_pid_parameters(Kp, inf, 0, Tp);

% Set trajectory
step1_time = 30;
step2_time = 350;

step1_value = 42;
step2_value = 37;


yzad(1:step1_time) = Ypp;
yzad(step1_time:iterations) = step1_value;
yzad(step2_time:end) = step2_value;

% General settings
iterations = 600;
kstart = 12;

u = ones(1, iterations) * Upp;
y = ones(1, iterations) * Ypp;
y_simulation = ones(1, iterations) * Ypp;
e = zeros(1, iterations);

% Validation
e_sum = 0;

% Preparing files
file_id = fopen(name, 'a');
fprintf(file_id, "u(k), yzad(k), y(k), y_simulation(k)\n");

buffer_size = 15;
buffer = zeros(buffer_size, 4);
buffer_index = 1;

% Make window with plots
figure;
hold on;
h_y = stairs(1:kstart, y(1:kstart), 'DisplayName', 'y');
h_y_sim = stairs(1:kstart, y_simulation(1:kstart), 'DisplayName', ...
    'y\_simulation');
h_y_zad = stairs(1:kstart, yzad(1:kstart), 'DisplayName', 'y\_zad');
hold off;

title("Wykres sterowania i odpowiedzi stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;


figure;
hold on;
h_u = stairs(1:kstart, u(1:kstart), 'DisplayName', 'u');
hold off;

title("Wykres sterowania i odpowiedzi stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;


% Main loop
for k=kstart:iterations
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

    y(k) = readMeasurements(1);
    y_normalized = heating_station_simulation( ...
        (uktdm1 - Upp) / (step_value - working_point), ...
        (uktdm2 - Upp) / (step_value - working_point), ...
        (ykm1 - Ypp) / (step_value - working_point), ...
        (ykm2 - Ypp) / (step_value - working_point), ...
        a, b);
    y_simulation(k) = y_normalized * (step_value - working_point) + Ypp;
    
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

    % Control the physical object
    sendControls([1, 5], [50, u(k)]);

    % Add data to buffer
    buffer(buffer_index, :) = [u(k), yzad(k), y(k), y_simulation(k)];
    buffer_index = buffer_index + 1;

    % Write data to file
    if buffer_index > buffer_size
        fprintf(file_id, '%f, %f, %f, %f\n', buffer');
        buffer_index = 1;
    end

    % Update plots
    set(h_u, 'XData', 1:k, 'YData', u(1:k));
    set(h_y, 'XData', 1:k, 'YData', y(1:k));
    set(h_y_sim, 'XData', 1:k, 'YData', y_simulation(1:k));
    set(h_y_zad, 'XData', 1:k, 'YData', yzad(1:k));
    drawnow;

    waitForNewIteration();

end

fclose(file_id);
sendControls([1, 5], [50, 26]);

fprintf("Error sum: %02f \r\n", e_sum);