clear all;
D = 600;
N = 200;
Nu = 3;
lambda = 0.1;
kend = 600;
start = 20;
set_value = 40;

% Initialize communication with the heating station
addpath('D:\SerialCommunication'); 
initSerialControl COM7 

Upp = 26;
du = 19;
du_min = -100;
du_max = 100;

u_min = 0;
u_max = 100;

name = "data\zad2_step_value=" + string(Upp + du) + ".csv";
raw_data = csvread(name);
Ypp = raw_data(1);

% Process approximation
[xopt, td] = approximation(Upp + du, Upp, raw_data);
Kp = xopt(1);
T1 = xopt(2);
T2 = xopt(3);

% Step response normalized of approximated process
s = stepResponseNormalized(0, 0, 0, D, Kp, T1, T2, td);
[a, b] = calculate_coefficients(T1, T2, Kp);

% Fill M matrix
M = zeros(N, Nu);
for i=1:Nu
M(i:end,i)=s(1:N-i + 1);
end

% Fill MP matrix
MP = zeros(N, D-1);
for i = 1:N
for j = 1:D-1
    if i+j <= D    
        MP(i, j) = s(i+j) - s(j);
    else
        MP(i, j) = s(D) - s(j);
    end
end
end

% Regulator parameters
I = eye(Nu);
K = ((M'*M+lambda*I)^(-1))*M';
Ku = K(1,:)*MP;
Ke = sum(K(1, :));

% Variables initialization
y = ones(kend, 1) * Ypp;
y_simulation = ones(kend, 1) * Ypp;
u = ones(kend, 1) * Upp;
deltauk_p = zeros(D-1, 1);

% Set trajectory
step1_time = 30;
step2_time = 350;

step1_value = 37;
step2_value = 37;


y_zad(1:step1_time) = Ypp;
y_zad(step1_time:kend) = step1_value;
% y_zad(step2_time:end) = step2_value;

% File name to acquired data
test_number = 4;
name = "dmc_data/DMC_object_" + string(test_number) + ".csv";

% Preparing files
file_id = fopen(name, 'a');
fprintf(file_id, "u(k), y(k), y_simulation(k)\n");

buffer_size = 15;
buffer = zeros(buffer_size, 3);
buffer_index = 1;

% Make window with plots
figure;
hold on;
h_y = stairs(1:start, y(1:start), 'DisplayName', 'y');
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

error = 0;
% Main loop
for k=start:kend
    if(k - td - 1 < 1)
        uktdm1 = Upp;
    else
        uktdm1 = u(k - td - 1);
    end
    
    if(k - td - 2 < 1)
        uktdm2 = Upp;
    else
        uktdm2 = u(k - td - 2);
    end
    
    if(k - 1 < 1)
        ykm1 = Ypp;
    else
        ykm1 = y(k-1);
    end
    
    if(k - 2 < 1)
        ykm2 = Ypp;
    else
        ykm2 = y(k-2);
    end
    
    y(k) = readMeasurements(1);
    y_simulation(k) = Ypp + heating_station_simulation(uktdm1 - Upp, uktdm2 - Upp, ykm1 - Ypp, ykm2 - Ypp, a, b);
    
    % Compute error
    ek = y_zad(k) - y(k);
    
    % Compute deltau variable for given control horizon
    deltauk = Ke*ek-Ku*deltauk_p;
    
    % Back deltau window
    for n=D-1:-1:2
        deltauk_p(n) = deltauk_p(n-1);
    end  
    
    if(deltauk < du_min)
        deltauk = du_min;
    elseif(deltauk > du_max)
        deltauk = du_max;
    end
    
    % Manipulate variable for time k
    u(k) = u(k-1) + deltauk;
    
    if(u(k) < u_min)
        u(k) = u_min;
    elseif(u(k) > u_max)
        u(k) = u_max;
    end
    
    % Delta u for time k
    deltauk_p(1) = u(k) - u(k-1);
    error  = error + ek*ek;
    
    sendControls([1, 5], [50, u(k)]);

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
    set(h_y_sim, 'XData', 1:k, 'YData', y_simulation(1:k));
    set(h_y_zad, 'XData', 1:k, 'YData', y_zad(1:k));
    drawnow;

    waitForNewIteration();
end
fclose(file_id);
sendControls([1, 5], [50, 26]);

fprintf("DMC error: %f\r\n", error);