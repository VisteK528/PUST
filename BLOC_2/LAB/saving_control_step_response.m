%% Communication with heating station setup
addpath('D:\SerialCommunication'); 
initSerialControl COM7

%% Experiment parameters
N = 1000;
Upp = 26;
FanPower = 50;
step_value_1 = 1; % u(k) value after step
T1 = zeros(N, 1);

%% Data export setup
name = "data/zad2_control_step=" + string(step_value_1) + ".csv";
file_id = fopen(name, 'a');
fprintf(file_id, "heater_temp, environment_temp\n");
buffer_size = 15;
buffer = zeros(buffer_size, 2);
buffer_index = 1;

%% Make the jump
sendControls([1, 5], [FanPower, step_value_1]);

for k=1:N
    measurements = readMeasurements([1 5]);
    fprintf('Heater temp: %.2f *C\tEnvironment temp: %.2f *C\n', ...
        measurements(1), measurements(2));
    
    T1(k) = measurements(1);
    stairs(1:k, T1(1:k));
    drawnow;

    % saving to buffer
    buffer(buffer_index, :) = measurements;
    buffer_index = buffer_index + 1;

    if buffer_index > buffer_size
        fprintf(file_id, '%f, %f\n', buffer');
        buffer_index = 1;
    end
    
    waitForNewIteration();
    
end

% saving buffer if it isn't empty
if buffer_index > 1
    fprintf(file_id, '%f, %f\n', buffer(1:buffer_index-1, :)');
end
fclose(file_id);

%% Send working point parameters
sendControls([1, 5], [FanPower, Upp]); 