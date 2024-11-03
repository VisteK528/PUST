function [y, u] = dmc(N, Nu, D, lambda, start, iterations, set_value, set_time)
    
    working_point = 26;
    step_value = 35;

    du_min = -70;
    du_max = 70;
    
    u_min = 0;
    u_max = 100;

    name = "data/zad2_step_value=" + string(step_value) + ".csv";
    raw_data = load(name);
    Ypp = raw_data(1);
    Upp = working_point;

    % Process approximation
    [xopt, td] = approximation(step_value, Upp, raw_data);
    Kp = xopt(1);
    T1 = xopt(2);
    T2 = xopt(3);

    % Step response normalized of approximated process
    s = step_response(0, 0, D, Kp, T1, T2, td);
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
    y = ones(iterations, 1) * Ypp;
    u = ones(iterations, 1) * Upp;
    deltauk_p = zeros(D-1, 1);
    
    y_zad(1:set_time) = Ypp;
    y_zad(set_time:iterations) = set_value;
    
    error = 0;


    % Main loop
    for k=start:iterations
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
        
        y(k) = Ypp + heating_station_simulation(uktdm1 - Upp, ...
            uktdm2 - Upp, ykm1 - Ypp, ykm2 - Ypp, a, b);

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