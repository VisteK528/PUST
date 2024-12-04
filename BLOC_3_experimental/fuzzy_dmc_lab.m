%% Konfiguracja
addpath('D:\SerialCommunication');
initSerialControl COM7
sendControls(1, 50);

start = 10;
kend = 800;
Upp = 26;
Ypp = 35.81;

y = zeros(kend, 1);
u = zeros(kend, 1);
e_sum = 0;

D = 50;
N = 20;
Nu = 1;
lambda = 1;
start = 10;
kend = 800;
working_points = [-0.3 -0.1 0.0 0.2 0.5];

step1_time = 10;
step2_time = 200;
step3_time = 400;
step4_time = 600;

% Set trajectory
step1_value = 0.02;
step2_value = 0.07;
step3_value = -0.05;
step4_value = -0.2;

yzad(1:step1_time) = Ypp;
yzad(step1_time:step2_time) = step1_value;
yzad(step2_time:step3_time) = step2_value;
yzad(step3_time:step4_time) = step3_value;
yzad(step4_time:kend) = step4_value;

%y_simulation = ones(kend, 1) * Ypp;

%% Odpowiedzi skokowe
% TODO - working_points
working_points = [50];

num_regulators = length(working_points);
regulators = [];

for i=1:num_regulators
    regulators = [regulators localDMC_lab(N, Nu, D, lambda, working_points(i), yzad, kend)];
end
%% Pliki
% File name to acquired data
test_number = 1;
name = "data/DMC_object_" + string(test_number) + ".csv";

% Preparing files
file_id = fopen(name, 'a');
fprintf(file_id, "u(k), y(k), y_simulation(k)\n");

buffer_size = 15;
buffer = zeros(buffer_size, 3);
buffer_index = 1;

% Make window with plots
figure;
hold on;
h_y = stairs(1:start, y_simulation(1:start), 'DisplayName', 'y');
h_y_sim = stairs(1:start, y_simulation(1:start), 'DisplayName', 'y\_simulation');
h_y_zad = stairs(1:start, y_zad(1:start), 'DisplayName', 'y\_zad');
hold off;

title("Wykres sterowania i odpowiedzi stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;

figure;
hold on;
h_u = stairs(1:start, u(1:start), 'DisplayName', 'u');
hold off;

title("Wykres sterowania i odpowiedzi stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;

% Main loop
for k=start:kend
    y(k) = readMeasurements(1);
    %y_simulation(k) = Ypp + heating_station_simulation(u(k-td1-1) - Upp, ...
    %    u(k-td1-2) - Upp, y_u(k-1) - Ypp, y_u(k-2) - Ypp, a1, b1);

    % Compute error
    ek = yzad(k) - y(k);
    e_sum = e_sum + ek^2;

    membership_weights = membershipFunction(working_points, u(k-1));

    % Get u from local regulators
    for i=1:num_regulators
        if membership_weights(i) == 0
            continue;
        end

        u_reg = regulators(i).iterationDMC(k, y(k));
        u(k) = u(k) + membership_weights(i) * u_reg;
    end

    % Update local regulators
    for i=1:num_regulators
        regulators(i) = regulators(i).updateAfterIteration(u(k), k);
    end
    
    % Control the physical object
    sendNonlinearControls(u(k))

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
    %set(h_y_sim, 'XData', 1:k, 'YData', y_simulation(1:k));
    set(h_y_zad, 'XData', 1:k, 'YData', y_zad(1:k));
    drawnow;

    waitForNewIteration();
end

fclose(file_id);
sendControlsToG1AndDisturbance(Upp, 0);

fprintf("Error: %f\r\n", e_sum);