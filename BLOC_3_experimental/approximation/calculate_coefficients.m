function [a, b] = calculate_coefficients(T1, T2, K)

alpha_1 = exp(-1/T1);
alpha_2 = exp(-1/T2);

a = zeros(2, 1);
b = zeros(2, 1);

a(1) = - alpha_1 - alpha_2;
a(2) = alpha_1*alpha_2;

b(1) = K/(T1 - T2)*(T1*(1 - alpha_1) - T2*(1 - alpha_2));
b(2) = K/(T1 - T2)*(alpha_1*T2*(1 - alpha_2) - alpha_2*T1*(1 - alpha_1));

end