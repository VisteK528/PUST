clear;

Ypp = 5;

% Digital PID parameters
% Kk - critical gain
% Tk - critical period
% Tp - sampling period
Kk = 0.661505;
Tk = 19.6;
Tp = 0.5;
[r2, r1, r0] = discretePidParameters(Kk, Tk, Tp);
% r0 = 0.3358; r1 = -0.0416; r2 = -0.2739;

x = [r2, r1, r0];

% Set trajectory
step1_value = 0.05;
step2_value = -0.05;
step3_value = 0.12;
step4_value = 0.19;

yzad(1:10) = Ypp;
yzad(10:200) = Ypp + step1_value;
yzad(200:400) = Ypp+ step2_value;
yzad(400:600) = Ypp + step3_value;
yzad(600:800) = Ypp + step4_value;

[y, u, e_sum] = simulatePid(x, step1_value, step2_value, step3_value, step4_value);
len = length(y);

fprintf("Error sum: %02f \r\n", e_sum);

figure;
stairs(1:len, y);
hold on;
stairs(1:len, yzad, '--');

figure;
stairs(1:len, u);

% Save to file
name1 = "plot_data/z5_pid_u.txt";
writematrix(u', name1);
name2 = "plot_data/z5_pid_y.txt";
writematrix([yzad; y]', name2);