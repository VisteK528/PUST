function [error] = approx_goal_func(td, working_point_u, step_value, y_measured, K, T1, T2)
    [a, b] = calculate_coefficients(T1, T2, K);

    N = length(y_measured);
    u = ones(N, 1) * step_value;
    y = ones(N, 1) * 32.87;
    
    error = 0;
    for k=2:500
        if(k - td - 1 < 1)
            uktdm1 = working_point_u;
        else
            uktdm1 = u(k - td - 1);
        end
        
        if(k - td - 2 < 1)
            uktdm2 = working_point_u;
        else
            uktdm2 = u(k - td - 2);
        end
        
        if(k - 1 < 1)
            ykm1 = 32.87;
        else
            ykm1 = y(k-1);
        end
        
        if(k - 2 < 1)
            ykm2 = 32.87;
        else
            ykm2 = y(k-2);
        end
        
        y(k) = heating_station_simulation(uktdm1, uktdm2, ykm1, ykm2, a, b);
        error = error + (y(k) - y_measured(k))*(y(k) - y_measured(k));
    end
end