function [best_params, best_td] = approximation(step_value, ...
    working_point, raw_data)

    output = raw_data(:, 1);

    % Initial values of the searched transfer function
    K = 50;
    T1 = 2;
    T2 = 3;
    
    output = (output - ones(size(output))* ...
        output(1))/(step_value - working_point);

    best_error = inf;
    best_params = [];
    best_td = 0;

    for td = 1:15
        x_pocz = [K, T1, T2];
        upper_constraint = [150 100 100];
        bottom_constraint = [0.1 1.2 1];
    
        xopt = fmincon(@(x_init) approx_goal_func(td, 0, 1, ...
            output, x_init(1), x_init(2), x_init(3)), ...
            x_pocz, [], [], [], [], ...
            bottom_constraint, upper_constraint);
    
        error = approx_goal_func(td, 0, 1, ...
            output, xopt(1), xopt(2), xopt(3));
    
        if(error <= best_error)
            best_error = error;
            best_params = xopt;
            best_td = td;
        end
    end
    
%     fprintf("Error: %f\r\n", best_error);
%     fprintf("Td=%d\r\n", best_td);
%     fprintf("K=%f\r\n", xopt(1));
%     fprintf("T1=%f\r\n", xopt(2));
%     fprintf("T2=%f\r\n", xopt(3));

end