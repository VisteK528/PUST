function [y, u, e_sum] = simulatePid(x, step1_value, step2_value, step3_value, step4_value)
    r2 = x(1);
    r1 = x(2);
    r0 = x(3);

    % Process constants
    du_min = -5e-02;
    du_max = 5e-02;
    u_min = 6e-01;
    u_max = 1e+00; 
    upp = 8e-01;
    ypp = 5e+00;

    iterations = 800;
    
    u = ones(1, iterations) * upp;
    y = ones(1, iterations) * ypp;
    e = zeros(1, iterations);
    
    % Set trajectory
    step1_time = 10;
    step2_time = 200;
    step3_time = 400;
    step4_time = 600;
    
    yzad(1:step1_time) = ypp;
    yzad(step1_time:step2_time) = ypp + step1_value;
    yzad(step2_time:step3_time) = ypp + step2_value;
    yzad(step3_time:step4_time) = ypp + step3_value;
    yzad(step4_time:iterations) = ypp + step4_value;
    
    % Validation
    e_sum = 0;
    
    % Main loop
    for k=step1_time:iterations
        if k >= 2
          Ykm1 = y(k-1);
        else
          Ykm1 = ypp;
        end
        
        if k >= 3
          Ykm2 = y(k-2);
        else
          Ykm2 = ypp;
        end
        
        if k >= 11
          Ukm10 = u(k-10);
        else
          Ukm10 = upp;
        end
        
        if k >= 12
          Ukm11 = u(k-11);
        else
          Ukm11 = upp;
        end
        
        y(k) = symulacja_obiektu11y_p1(Ukm10,Ukm11,Ykm1,Ykm2);
        
        % Compute error
        e(k) = yzad(k) - y(k);
        e_sum = e_sum + e(k)^2;
        
        % Compute manipulate variable for discrete time k
        u(k) = r2*e(k-2) + r1*e(k-1) + r0*e(k) + u(k-1);
    
        % Constrains on speed and value
        du = u(k) - u(k-1);
        if(du < du_min)
            du = du_min;
        elseif(du > du_max)
            du = du_max;
        end
    
        u(k) = u(k-1) + du;
    
        if(u(k) < u_min)
            u(k) = u_min;
        elseif(u(k) > u_max)
            u(k) = u_max;
        end
    end
end