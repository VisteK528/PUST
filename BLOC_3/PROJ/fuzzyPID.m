function [y, u, e_sum] = fuzzyPID(Kp, Ti, Td, start, kend, working_points, yzad)
    u = zeros(1, kend);
    y = zeros(1, kend);
    e = zeros(1, kend);
    up = zeros(1, kend);
    ui = zeros(1, kend);
    ud = zeros(1, kend);

    u_min = -1;
    u_max = 1;

    e_sum = 0;
    num_regulators = length(working_points);

    for k=start:kend
        y(k) = symulacja_obiektu11y_p3(u(k-5), u(k-6), y(k-1), y(k-2));

        % Compute error
        e(k) = yzad(k) - y(k);
        e_sum = e_sum + e(k)^2;

        membership_weights = membershipFunction(working_points, u(k-1));

        for i=1:num_regulators
            if membership_weights(i) == 0
                continue;
            end

            up(k) = Kp(i) * e(k);
            ui(k) = ui(k-1) + Kp(i) * (e(k-1) + e(k)) / (2 * Ti(i));
            ud(k) = Kp(i) * Td(i) * (e(k) - e(k-1));
            u_reg = up(k) + ui(k) + ud(k);

            u(k) = u(k) + membership_weights(i) * u_reg;
        end

        if(u(k) < u_min)
            u(k) = u_min;
        elseif(u(k) > u_max)
            u(k) = u_max;
        end
    end
end