clear all;

kstart = 50;
kend = 500;

% Liczba wejść i wyjść
nu = 4; 
ny = 3; 

% Inicjalizacja sygnałów
yzad = zeros(kend, ny);
yzad(50:end, 1) = 2.5;
yzad(50:end, 2) = 5.5;
yzad(50:end, 3) = 1.75;

u = zeros(kend, nu); 
y = zeros(kend, ny); 

% parametry PID
Kp = [0.5, 0.3, 0.3; 
       0.3, 0.45, 0.3; 
       0.3, 0.3, 0.4; 
       0.3, 0.3, 0.35];
Ki = [0.02, 0.01, 0.01; 
       0.01, 0.015, 0.01; 
       0.01, 0.01, 0.02; 
       0.01, 0.01, 0.008];
Kd = [0.8, 0.7, 0.7; 
       0.7, 0.75, 0.7; 
       0.7, 0.7, 0.7; 
       0.7, 0.7, 0.65];



% Uchyby PID
e = zeros(kend, ny);       
e_prev = zeros(kend, ny);  
e_int = zeros(kend, ny);  
e_diff = zeros(kend, ny);  

for k = kstart:kend
    [y1, y2, y3] = symulacja_obiektu11y_p4(...
        u(k-1, 1), u(k-2, 1), u(k-3, 1), u(k-4, 1), ...
        u(k-1, 2), u(k-2, 2), u(k-3, 2), u(k-4, 2), ...
        u(k-1, 3), u(k-2, 3), u(k-3, 3), u(k-4, 3), ...
        u(k-1, 4), u(k-2, 4), u(k-3, 4), u(k-4, 4), ...
        y(k-1, 1), y(k-2, 1), y(k-3, 1), y(k-4, 1), ...
        y(k-1, 2), y(k-2, 2), y(k-3, 2), y(k-4, 2), ...
        y(k-1, 3), y(k-2, 3), y(k-3, 3), y(k-4, 3));
    
    y(k, 1) = y1;
    y(k, 2) = y2;
    y(k, 3) = y3;

    e(k, :) = yzad(k, :) - y(k, :);
    
    % Obliczenia PID dla każdego kanału wejście-wyjście
    for i = 1:ny 
        for j = 1:nu
            P = Kp(j, i) * e(k, i);
            I = Ki(j, i) * e_int(k-1, i);
            D = Kd(j, i) * (e(k, i) - e_prev(k-1, i));

            % Sygnał sterujący
            u(k, j) = u(k-1, j) + P + I + D;
        end
    end
    
    % Aktualizacja uchybu
    e_int(k, :) = e_int(k-1, :) + e(k, :);
    e_prev(k, :) = e(k, :);
end

% Rysowanie wykresów
figure;
for i = 1:ny
    subplot(3, 1, i);
    stairs(y(:, i), 'b'); hold on;
    stairs(yzad(:, i), 'r--');
    title(['Wyjście ' num2str(i)]);
    xlabel('Krok czasu');
    ylabel('Wartość');
    legend('y', 'yzad');
end
