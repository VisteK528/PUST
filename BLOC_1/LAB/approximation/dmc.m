function [y, u] = dmc(N, Nu, D, lambda, start, kend, set_value, set_time)
    Upp = 26;
    du = 9;
    du_min = -50;
    du_max = 50;
    
    u_min = 0;
    u_max = 100;

    name = "data/zad2_step_value=" + string(Upp + du) + ".csv";
    raw_data = load(name);
    Ypp = 33;

    % Process approximation
    [xopt, td] = approximation(Upp + du, Upp, raw_data);
    Kp = xopt(1);
    T1 = xopt(2);
    T2 = xopt(3);

    % Step response normalized of approximated process
    s = stepResponseNormalized(Upp, Ypp, du, D, Kp, T1, T2, td);
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
    u = ones(kend, 1) * Upp;
    deltauk_p = zeros(D-1, 1);
    
    y_zad(1:set_time) = Ypp;
    y_zad(set_time:kend) = set_value;
    
    error = 0;


    % Main loop
    for k=start:kend
        % Generate process output
        y(k) = heating_station_simulation(u(k-td-1), u(k-td-2), y(k-1), y(k-2), a, b);

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
    end

    fprintf("DMC error: %f\r\n", error);
end