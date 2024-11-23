function [y, u] = dmc_with_disturbance_heating_station(start, kend, ...
    N, Nu, D, lambda, Dz, y_set_time, y_set_value, z, consider_disturbance)

    %% Configuration
    addpath("approximation\");

    % Controls limits
    du_min = -100;
    du_max = 100;    
    u_min = 0;
    u_max = 100;

    %% Step responses

    working_point_u = 26;
    working_point_z = 0;
    step_value_u = 45;
    step_value_z = 20;

    % Input - output path
    name1 = "data/l2_step_value=" + string(step_value_u) + ".csv";
    raw_data1 = load(name1);
    Ypp = raw_data1(1);
    Upp = working_point_u;

    [xopt1, td1] = approximation(step_value_u, working_point_u, raw_data1);
    K1 = xopt1(1);
    T11 = xopt1(2);
    T21 = xopt1(3);

    s = step_response(0, 0, D+1, K1, T11, T21, td1);
    s = s(2:end);
    [a1, b1] = calculate_coefficients(T11, T21, K1);

    % Disturbance - output path
    name2 = "data/zad2_disturbance2_step=" + string(step_value_z) + ".csv";
    raw_data2 = load(name2);
    Yzpp = raw_data2(1);

    [xopt2, td2] = approximation(step_value_z, working_point_z, raw_data2);
    K2 = xopt2(1);
    T12 = xopt2(2);
    T22 = xopt2(3);

    sz = step_response(0, 0, Dz+1, K2, T12, T22, td2);
    sz = sz(2:end);
    [a2, b2] = calculate_coefficients(T12, T22, K2);
    
    %% Algorithm

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
    y_u = ones(kend, 1) * Ypp;
    y_z = ones(kend, 1) * Yzpp;
    y = ones(kend, 1) * Ypp;
    u = ones(kend, 1) * Upp;
    deltauk_p = zeros(D-1, 1);
    deltaz_p = zeros(Dz, 1);
    
    y_zad(1:y_set_time) = Ypp;
    y_zad(y_set_time:kend) = y_set_value;
    
    accumulated_error = 0;

    % Main loop
    for k=start:kend
        % Generate process output
        y_u(k) = Ypp + heating_station_simulation(u(k-td1-1) - Upp, ...
            u(k-td1-2) - Upp, y_u(k-1) - Ypp, y_u(k-2) - Ypp, a1, b1);
        y_z(k) = Yzpp + heating_station_simulation(z(k-td2-1), ...
            z(k-td2-2), y_z(k-1) - Yzpp, y_z(k-2) - Yzpp, a2, b2);
        y(k) = y_u(k) + y_z(k) - Yzpp;

        % Compute error
        ek = y_zad(k) - y(k);
        accumulated_error = accumulated_error + ek^2;

        % Disturbance effect
        z_part = 0;
        for j=0:(Dz-1)
            z_part = z_part + K(1, :)*MZP(:, j+1)*deltaz_p(1+j);
        end

        % Compute deltau variable for given control horizon
        if consider_disturbance
            deltauk = Ke*ek-Ku*deltauk_p - z_part;
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
        deltaz_p(1) = z(k) - z(k-1);
    end

    fprintf("Error: %f\r\n", accumulated_error);
end