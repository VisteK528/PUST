function [y] = heating_station_simulation(K, T1, T2, uktdm1, uktdm2, ykm1, ykm2)

[a1, a2, b1, b2] = calculate_coefficients(T1, T2, K);
y = b1*uktdm1 + b2*uktdm2 - a1*ykm1 - a2*ykm2;

end