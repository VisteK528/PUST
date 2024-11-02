clear;

step1_value = 0.05;
step2_value = -0.05;
step3_value = 0.12;
step4_value = 0.19;

x_pocz = [0 0 0];
upper_constraint = [1.0 1.0 1.0];
bottom_constraint = [-1.0 -1.0 -1.0];

xopt = fmincon(@(x) objectiveFunction(x, step1_value, step2_value, step3_value, step4_value), ...
               x_pocz, [], [], [], [], bottom_constraint, upper_constraint);
r2 = xopt(1);
r1 = xopt(2);
r0 = xopt(3);

fprintf('Optimized r0: %.4f\n', r0);
fprintf('Optimized r1: %.4f\n', r1);
fprintf('Optimized r2: %.4f\n', r2);

function e = objectiveFunction(x, step1_value, step2_value, step3_value, step4_value)
    [~, ~, e] = simulatePid(x, step1_value, step2_value, step3_value, step4_value);
end