function [best_params, best_td] = approximation(step_value, working_point, raw_data)    
    heater_temp = raw_data(:, 1);
    environment_temp = raw_data(:, 2);
    
    td = 1;
    K = 50;
    T1 = 2;
    T2 = 3;

    
    % error = approx_goal_func(td, working_point, step_value, heater_temp, K, T1, T2);
    
    best_error = inf;
    best_params = [];
    best_td = 0;
    for td = 1:30
        x_pocz = [K, T1, T2];
        upper_constraint = [1000 1000 1000];
        bottom_constraint = [0 1 1];
    
        xopt = fmincon(@(x_pocz) approx_goal_func(td, working_point, step_value, heater_temp, x_pocz(1), x_pocz(2), x_pocz(3)), ...
                       x_pocz, [], [], [], [], bottom_constraint, upper_constraint);
    
        error = approx_goal_func(td, working_point, step_value, heater_temp, xopt(1), xopt(2), xopt(3));
        
    
        if(error < best_error)
            best_error = error;
            best_params = xopt;
            best_td = td;
        end
    end
    
    fprintf("Error: %f\r\n", best_error);
    fprintf("Td=%d\r\n", best_td);
    fprintf("K=%f\r\n", xopt(1));
    fprintf("T1=%f\r\n", xopt(2));
    fprintf("T2=%f\r\n", xopt(3));

end
