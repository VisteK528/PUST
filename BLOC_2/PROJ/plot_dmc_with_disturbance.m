
Upp = 0;
Ypp = 0;
start = 20;
kend = 200;
D = 200;
N = 100;
Nu = 100;
lambda = 1;
Dz = 50;
u_set_time = 40;
u_set_value = 1;



%% Disturbance
consider_distrubance = true;
noise = "gaussian";
disturbance_jump = 4.8;
z = zeros(kend, 1);

sine_wave = false;
frequency = 5;          % Frequency in Hz
amplitude = 0.05;       % Amplitude of the sine wave
sampling_rate = 100;    % Sampling rate in Hz
duration = 2;           % Duration in seconds
t = 0:1/sampling_rate:duration;   % Time vector
sine_wave_array = amplitude * sin(2 * pi * frequency * t);  % Sine wave values


if sine_wave
    z(100:end) = sine_wave_array(101:end);
else
    z(100:end) = disturbance_jump;
end


y_zad = zeros(kend-start, 1);
y_zad(u_set_time:end) = u_set_value;


[y, u, z, z_measured] = dmc_with_disturbance(start, kend, Upp, Ypp, N, Nu, D, lambda, Dz, u_set_time, u_set_value, z, consider_distrubance, noise);

% Create a figure
figure;

% Plot first subplot (top)
subplot(2, 1, 1); % 2 rows, 1 column, 1st plot
stairs(u);
grid on;
grid(gca, 'minor');
title('Sterowanie obiektu');
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('$u$', 'fontsize', 14, 'Interpreter', 'latex');

subplot(2, 1, 2); % 2 rows, 1 column, 1st plot
stairs(z);
hold on;
stairs(z_measured);
grid on;
grid(gca, 'minor');
title('Zakłócenie obiektu');
legend("Zakłócenie", "Zmierzone zakłócenie");
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('$z$', 'fontsize', 14, 'Interpreter', 'latex');
% Set figure size and position
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);


figure;
stairs(y); % Replace with other data if needed
hold on;
stairs(y_zad);


grid on;
grid(gca, 'minor');
title('Wyjście obiektu');
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('y', 'fontsize', 14, 'Interpreter', 'latex');
legend("y", "y_{zad}")

% Set figure size and position
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);


