%% Script used in order to settle working point on the process output

Upp = 26;
FanPower = 50;
Z = 0;
kstart = 1;

%% Communication with heating station setup
addpath('D:\SerialCommunication');
initSerialControl COM7

y = zeros(100, 1);
environment = zeros(100, 1);

%% Configure plot
figure;
hold on;
h_y = stairs(1:kstart, y(1:kstart), 'DisplayName', 'y');
h_environment = stairs(1:kstart, environment(1:kstart), 'DisplayName', ...
    'environment');

title("Wykres sterowania i odpowiedzi stanowiska grzewczego");
xlabel("Iteracje [k]");
ylabel("Wartości");
legend;
grid on;

k = 1;
while(1)
    %% obtaining measurements
    measurements1 = readMeasurements(1); % T1 temperature
    measurements5 = readMeasurements(5); % T5 ambient temperature
    y(k) = measurements1;
    environment(k) = measurements5;

    fprintf('Heater temp: %.2f *C\tEnvironment temp: %.2f *C\n', measurements1, measurements5);

    %% sending new values of control signals
    sendControls(1,FanPower);
    sendControlsToG1AndDisturbance(Upp, 0);

    % Update plots
    set(h_y, 'XData', 1:k, 'YData', y(1:k));
    set(h_environment, 'XData', 1:k, 'YData', environment(1:k));
    drawnow;
    k = k + 1;

    %% synchronising with the control process
    waitForNewIteration();
end

