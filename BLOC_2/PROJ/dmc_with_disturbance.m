function [y, u, z, z_measured] = dmc_with_disturbance(start, kend, Upp, Ypp, N, Nu, D, lambda, Dz, u_set_time, u_set_value, z, consider_disturbannce, noise)
    %% Dodanie szumu do pomiaru zakłócenia
    % Dostępne typy szumu
    % noise = none - brak szumu
    % noise = gaussian - biały szum gaussowski
    % noise = uniform - szum równomierny
    % noise = quantization - szum kwantyzacji (np. wprowadzony przez
    % przetwornik ADC)

    z_measured = z;

    if noise == "gaussian"
        noise_mean = 0;
        noise_std_dev = 0.2;
        gaussian_noise = noise_mean + noise_std_dev * randn(size(z_measured));
        z_measured = z_measured + gaussian_noise;
    elseif noise == "uniform"
        noise_min = -0.1;
        noise_max = 0.1;
        uniform_noise = noise_min + (noise_max - noise_min) * rand(size(z));
        z_measured = z_measured + uniform_noise;
    elseif noise == "quantization"
        q = 0.1;
        z_measured = round(z_measured ./ q) .*q;
    end



    %% Ograniczenia sterowania - w tym przypadku brak
    du_min = -1e3;
    du_max = 1e3;
    
    u_min = -1e3;
    u_max = 1e3;

    %% Odpowiedzi skokowe
    s = step_response(Upp, Ypp, D+1, 1, 1, "u");
    s = s(2:end);

    sz = step_response(Upp, Ypp, Dz+1, 1, 1, "z");
    sz = sz(2:end);
    
    
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

    % Fill MZP matrix
    MZP = zeros(N, Dz);
    for j = 1:Dz
        for i=1:N
            if j == 1
                if i <= Dz
                    MZP(i, j) = sz(i);
                else
                    MZP(i, j) = sz(Dz);
                end
            else
                 if i + j - 1 <= Dz
                    MZP(i, j) = sz(i+j-1) - sz(j - 1);
                else
                    MZP(i, j) = sz(Dz) - sz(j - 1);
                 end
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
    u = ones(kend, 1) * Upp;
    deltauk_p = zeros(D-1, 1);
    deltaz_p = zeros(Dz, 1);
    
    y_zad(1:u_set_time) = Ypp;
    y_zad(u_set_time:kend) = u_set_value;
    
    accumulated_error = 0;
    % Main loop
    for k=start:kend
        % Generate process output
        y(k) = symulacja_obiektu11y_p2(u(k-7), u(k-8), z(k-3), z(k-4), y(k-1), y(k-2));

        % Compute error
        ek = y_zad(k) - y(k);
        accumulated_error = accumulated_error + ek^2;

        % Disturbance effect
        z_part = 0;
        for j=0:(Dz-1)
            z_part = z_part + K(1, :)*MZP(:, j+1)*deltaz_p(1+j);
        end

        % Compute deltau variable for given control horizon
        if consider_disturbannce
            deltauk = Ke*ek-Ku*deltauk_p- z_part;
        else
            deltauk = Ke*ek-Ku*deltauk_p;
        end
        
        % Back deltau window
        for n=D-1:-1:2
            deltauk_p(n) = deltauk_p(n-1);
        end

        % Calculate deltaz window
         for n=Dz:-1:2
            deltaz_p(n) = deltaz_p(n-1);
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
        deltaz_p(1) = z_measured(k) - z_measured(k-1);
    end

    fprintf("Error: %f\r\n", accumulated_error);
end