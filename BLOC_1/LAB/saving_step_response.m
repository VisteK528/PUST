addpath('D:\SerialCommunication'); 
initSerialControl COM7

N = 1000;
step_value_1 = 75; % u(k) value after step
T1 = zeros(N, 1);

name = "data/zad2_step_value=" + string(step_value_1) + ".csv";
file_id = fopen(name, 'a');
fprintf(file_id, "heater_temp, environment_temp\n");

sendControls([1, 5], [50, step_value_1]);

buffer_size = 15;
buffer = zeros(buffer_size, 2);
buffer_index = 1;

for k=1:N
    measurements = readMeasurements([1 5]);
  
    disp(measurements);
    
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
sendControls([1, 5], [50, 26]); 