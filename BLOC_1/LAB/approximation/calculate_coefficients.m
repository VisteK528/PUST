function [a1, a2, b1, b2] = calculate_coefficients(T1, T2, K)

alpha_1 = exp(-1/T1);
alpha_2 = exp(-1/T2);

a1 = - alpha_1 - alpha_2;
a2 = alpha_1*alpha_2;

b1 = K/(T1 - T2)*(T1*(1 - alpha_1) - T2*(1 - alpha_2));
b2 = K/(T1 - T2)*(alpha_1*T2*(1 - alpha_2) - alpha_2*T1*(1 - alpha_1));

end