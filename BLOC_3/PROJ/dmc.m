function [y, u, e_sum] = dmc(N, Nu, D, lambda, Upp, step1_value, ...
    step2_value, step3_value, step4_value)
    du_min = -2;
    du_max = 2;
    
    u_min = -1;
    u_max = 1;

    start = 10;
    kend = 800;

    % Set trajectory
    step1_time = 10;
    step2_time = 200;
    step3_time = 400;
    step4_time = 600;
    
    yzad(1:step1_time) = 0;
    yzad(step1_time:step2_time) = step1_value;
    yzad(step2_time:step3_time) = step2_value;
    yzad(step3_time:step4_time) = step3_value;
    yzad(step4_time:kend) = step4_value;

    Yodp = stepResponse(0, 0, Upp, 50);
    Ypp = Yodp(50);

    % Step response
    s = stepResponseNormalized(Upp, Ypp, 0.01, D+1);
    s = s(2:end);
    
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

    e_sum = 0;
    
    % Main loop
    for k=start:kend
        if k >= 2
          Ykm1 = y(k-1);
        else
          Ykm1 = Ypp;
        end
        if k >= 3
          Ykm2 = y(k-2);
        else
          Ykm2 = Ypp;
        end
        if k >= 6
          Ukm5 = u(k-5);
        else
          Ukm5 = Upp;
        end
        if k >= 7
          Ukm6 = u(k-6);
        else
          Ukm6 = Upp;
        end
        
        y(k) = symulacja_obiektu11y_p3(Ukm5,Ukm6,Ykm1,Ykm2);

        % Compute error
        ek = yzad(k) - y(k);
        e_sum = e_sum + ek^2;

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
    end
end