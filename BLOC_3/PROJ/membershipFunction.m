function [values] = membershipFunction(working_points, u)
    % Constraint: values in working_points vector should be greater 
    % than u_min, smaller than u_max and be in the ascending order

    num_regulators = length(working_points);
    values = zeros(num_regulators, 1);

    if num_regulators == 1
        values = 1;
        return;
    end

    for i=1:num_regulators-1
        working_point_1 = working_points(i);
        working_point_2 = working_points(i+1);

        if u <= working_point_2
            distance_1_2 = working_point_2 - working_point_1;
            if u <= working_point_1 + distance_1_2 * 0.25
                values(i) = 1;
                return;
            elseif u >= working_point_2 - distance_1_2 * 0.25
                values(i+1) = 1;
                return;
            else
                values(i) = (working_point_2 - distance_1_2 * 0.25 - u) / (distance_1_2 * 0.5);
                values(i+1) = 1 - values(i);
                return;
            end
        end
    end

    if u >= working_points(num_regulators)
        values(num_regulators) = 1;
    end
end