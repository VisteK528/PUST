function [s, y_out] = step_response_lab(D)
    working_point_u = 55;
    step_value_u = 26;
    
    name1 = "data/dmc_u=" + string(working_point_u) + ".csv";
    raw_data1 = load(name1);
    Ypp = raw_data1(1);
    Upp = working_point_u;
    
    [xopt1, td1] = approximation(step_value_u, working_point_u, raw_data1);
    K1 = xopt1(1);
    T11 = xopt1(2);
    T21 = xopt1(3);
    
    s = step_response(0, 0, D+1, K1, T11, T21, td1);
    s = s(2:end);
    y_out = raw_data1(200);
    %[a1, b1] = calculate_coefficients(T11, T21, K1);
end