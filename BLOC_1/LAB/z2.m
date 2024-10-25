addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM7 % initialise com port

N = 1000;
step_value_1 = 75;
data = zeros(N, 2);

name = "data/zad2_step_value=" + string(step_value_1) + ".csv";
fileId = fopen(name, 'a');
fprintf(fileId, "heater_temp, environment_temp\n");

sendControls([ 1,5], ... send for these elements
                 [ 50,step_value_1]);  % new corresponding control values
for k=1:N
    measurements = readMeasurements([1 5]);
  
    disp(measurements);
    
    data(k, :) = measurements;
    d = data(1:k, 1);
    
    stairs(1:k, d);
    drawnow;
    
    fprintf(fileId, "%f, %f\n", measurements);
    waitForNewIteration();
    
end
fclose(fileId);
sendControls([ 1,5], ... send for these elements
                 [ 50,26]);  % new corresponding control values