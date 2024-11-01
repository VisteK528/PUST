function heating_station_test()
    addpath('D:\SerialCommunication'); 
    initSerialControl COM7 
    while(1)
       
        %% obtaining measurements
        measurements1 = readMeasurements(1); % T1 temperature
        measurements5 = readMeasurements(5); % T2 ambient temperature

        fprintf('%.2f\t%.2f\n', measurements1, measurements5);

        %% sending new values of control signals
        sendControls([1, 5], [50, 26]);
         
        %% synchronising with the control process
        waitForNewIteration();
    end
end