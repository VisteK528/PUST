function [s, y_out] = step_response_lab(D, Upp, U)    
    name1 = "data/dmc_u=" + string(Upp) + ".csv";
    raw_data1 = load(name1);
    Ypp = raw_data1(1);
    
    [xopt1, td1] = approximation(U, Upp, raw_data1);
    K1 = xopt1(1);
    T11 = xopt1(2);
    T21 = xopt1(3);
    
    s = step_response(0, 0, D+1, K1, T11, T21, td1);
    s = s(2:end);
    y_out = raw_data1(200);
    %[a1, b1] = calculate_coefficients(T11, T21, K1);
end