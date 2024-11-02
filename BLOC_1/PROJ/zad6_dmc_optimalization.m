clear;

step1_value = 0.05;
step2_value = -0.05;
step3_value = 0.12;
step4_value = 0.19;

D = 150;  

% Define constraints
upper_constraint = [200 20 100];   % N, Nu, lambda
lower_constraint = [1 1 0.001];    % N, Nu, lambda

lambda_initial = 0.1;

best_e_sum = Inf;
best_N = 0;
best_Nu = 0;
best_lambda = 0;

for N_initial = 10:10:100
    for Nu_initial = 1:2:10
        x_initial = [N_initial Nu_initial lambda_initial];

        options = optimoptions('fmincon', 'Display', 'off');
        xopt = fmincon(@(x) objectiveFunction(x, D, step1_value, step2_value, step3_value, step4_value), ...
                       x_initial, [], [], [], [], lower_constraint, upper_constraint, [], options);

        e_sum_opt = objectiveFunction(xopt, D, step1_value, step2_value, step3_value, step4_value);

        % Check if this is the best result found
        if e_sum_opt < best_e_sum
            best_e_sum = e_sum_opt;
            best_N = round(xopt(1));
            best_Nu = round(xopt(2));
            best_lambda = xopt(3);
        end
    end
end

fprintf('Best Optimized N: %d\n', best_N);
fprintf('Best Optimized Nu: %d\n', best_Nu);
fprintf('Best Optimized lambda: %.4f\n', best_lambda);

function e = objectiveFunction(x, D, step1_value, step2_value, step3_value, step4_value)
    N = round(x(1));      
    Nu = round(x(2));       
    lambda = x(3);          
    [~, ~, e_sum] = simulateDMC(N, Nu, D, lambda, step1_value, step2_value, step3_value, step4_value);
    e = e_sum;               
end
