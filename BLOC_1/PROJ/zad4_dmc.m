function [y, u] = zad4_dmc(N, Nu, D, lambda, start, kend, set_value, set_time)
    Upp = 0.8;
    Ypp = 5;
    du = 0.15   ;
    du_min = -5e-02;
    du_max = 5e-02;
    
    u_min = 6e-01;
    u_max = 1e+00;

    s = stepResponseNormalized(Upp, Ypp, du, D+1);
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
    
    y_zad(1:set_time) = Ypp;
    y_zad(set_time:kend) = set_value;
    
    % Main loop
    for k=start:kend
        % Generate process output
        y(k) = symulacja_obiektu11y_p1(u(k-10), u(k-11), y(k-1), y(k-2));

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
    
        
    end
end