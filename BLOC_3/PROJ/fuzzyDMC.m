function [y, u, e_sum] = fuzzyDMC(N, Nu, D, lambda, working_points, yzad)
    start = 10;
    kend = 800;

    y = zeros(kend, 1);
    u = zeros(kend, 1);
    e_sum = 0;

    num_regulators = length(working_points);
    regulators = [];

    % Initialize local regulators
    for i=1:num_regulators
        regulators = [regulators localDMC(N(i), Nu(i), D, lambda(i), ...
            working_points(i), yzad, kend)];
    end

    % Main loop
    for k=start:kend
        y(k) = symulacja_obiektu11y_p3(u(k-5), u(k-6), y(k-1), y(k-2));

        % Compute error
        ek = yzad(k) - y(k);
        e_sum = e_sum + ek^2;

        membership_weights = membershipFunction(working_points, u(k-1));

        % Get u from local regulators
        for i=1:num_regulators
            if membership_weights(i) == 0
                continue;
            end

            u_reg = regulators(i).iterationDMC(k, y(k));
            u(k) = u(k) + membership_weights(i) * u_reg;
        end

        % Update local regulators
        for i=1:num_regulators
            regulators(i) = regulators(i).updateAfterIteration(u(k), k);
        end
    end
end