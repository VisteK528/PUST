function [best_params, best_td] = approximation2(step_value, working_point, raw_data)    
    heater_temp = raw_data(:, 1);
    % Initial guesses and bounds for K, T1, T2
    K_init = 50;
    T1_init = 2;
    T2_init = 3;
    
    lower_bounds = [0.1, 0.1, 0.15, 1];     % Lower bounds for [K, T1, T2, Td]
    upper_bounds = [150, 100, 100, 15];     % Upper bounds for [K, T1, T2, Td]
    
    % Define the anonymous function for the GA optimization
    objective_fn = @(x) approx_goal_func(round(x(4)), working_point, step_value, heater_temp, x(1), x(2), x(3));
    
    % Specify options for GA, including integer constraints on Td (4th variable)
    ga_options = optimoptions('ga', 'Display', 'iter', 'MaxGenerations', 100, 'PopulationSize', 50, ...
                              'UseParallel', true, 'PlotFcn', @gaplotbestf);
    
    % Run GA with integer constraints on Td
    [xopt, best_error] = ga(objective_fn, 4, [], [], [], [], lower_bounds, upper_bounds, [], [4], ga_options);
    
    % Extract optimized parameters
    best_params = xopt(1:3);       % K, T1, T2
    best_td = round(xopt(4));      % Td, rounded to ensure it's an integer
    
    % Display results
    fprintf("Error: %f\n", best_error);
    fprintf("Td=%d\n", best_td);
    fprintf("K=%f\n", best_params(1));
    fprintf("T1=%f\n", best_params(2));
    fprintf("T2=%f\n", best_params(3));
end
