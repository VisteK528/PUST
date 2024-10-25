function MinimalWorkingExample()
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM7 % initialise com port
    while(1)
       
        %% obtaining measurements
        measurements = readMeasurements(1:7); % read measurements from 1 to 7
        measurements1 = readMeasurements(1);
        measurements5 = readMeasurements(5);
        %% processing of the measurements and new control values calculation

        %% sending new values of control signals
        sendControls([ 1,5], ... send for these elements
                     [ 50,26]);  % new corresponding control values
%         sendControlsToG1AndDisturbance(28,0)
        
         disp(measurements1);
         
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end