x_pocz = [0 0 0];
upper_constaint = [1.0 1.0 1.0];
bottom_constraint = [-1.0 -1.0 -1.0];

xopt = fmincon(@simulate_pid, x_pocz, [], [], [], [], bottom_constraint, upper_constaint);
r2 = xopt(1);
r1 = xopt(2);
r0 = xopt(3);