clear;

%% Konfiguracja
% Initialize communication with the heating station
addpath('D:\SerialCommunication'); 
initSerialControl COM7 
sendControls(1, 50);

% General settings
start = 10;
kend = 1000;

% PID parameters
working_points = [30 40 70];
Kp = [96 18.6 55];
Ti = [13 25 16];
Td = [3.25 6.25 4];

% Set trajectory
Ypp = 35;

step1_value = 40;
step2_value = 50;
step3_value = 60;

step1_time = 50;
step2_time = 200;
step3_time = 400;

yzad(1:step1_time) = Ypp;
yzad(step1_time:step2_time) = Ypp + 5;
yzad(step2_time:step3_time) = Ypp + 15;
yzad(step3_time:kend) = Ypp;

% Validation
u_min = -1;
u_max = 1;
e_sum = 0;

%% Pliki
% Preparing files
file_id = fopen(name, 'a');
fprintf(file_id, "u(k), yzad(k), y(k)\n");

buffer_size = 15;
buffer = zeros(buffer_size, 4);
buffer_index = 1;

% Make window with plots
figure;
hold on;
h_y = stairs(1:kstart, y(1:kstart), 'DisplayName', 'y');
h_y_zad = stairs(1:kstart, yzad(1:kstart), 'DisplayName', 'y\_zad');
hold off;

title("Wykres odpowiedzi stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;


figure;
hold on;
h_u = stairs(1:kstart, u(1:kstart), 'DisplayName', 'u');
hold off;

title("Wykres sterowania stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;

%% Algorytm
u = zeros(1, kend);
y = zeros(1, kend);
e = zeros(1, kend);
up = zeros(1, kend);
ui = zeros(1, kend);
ud = zeros(1, kend);

for k=start:kend
    y(k) = readMeasurements(1);

    % Compute error
    e(k) = yzad(k) - y(k);
    e_sum = e_sum + e(k)^2;

    membership_weights = membershipFunction(working_points, u(k-1));

    for i=1:num_regulators
        if membership_weights(i) == 0
            continue;
        end

        up(k) = Kp(i) * e(k);
        ui(k) = ui(k-1) + Kp(i) * (e(k-1) + e(k)) / (2 * Ti(i));
        ud(k) = Kp(i) * Td(i) * (e(k) - e(k-1));
        u_reg = up(k) + ui(k) + ud(k);

        u(k) = u(k) + membership_weights(i) * u_reg;
    end

    if(u(k) < u_min)
        u(k) = u_min;
    elseif(u(k) > u_max)
        u(k) = u_max;
    end

    % Control the physical object
    sendNonlinearControls(u(k))

    % Add data to buffer
    buffer(buffer_index, :) = [u(k), yzad(k), y(k)];
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

fprintf("Error: %f\r\n", e_sum);