function [r2, r1, r0] = discrete_pid_parameters_ziegler_nichols(Kk, Tk, Tp)
% KK - critical gain
% Tk - critical oscillations [s]
% Tp - sample time [s]

Kp = 0.6*Kk; Ti = 0.5*Tk; Td = 0.12*Tk;

r2 = Kp*Td/Tp;
r1 = Kp*(Tp/(2*Ti) - 2*(Td/Tp) - 1);
r0 = Kp*(1+(Tp/(2*Ti)+Td/Tp));
end