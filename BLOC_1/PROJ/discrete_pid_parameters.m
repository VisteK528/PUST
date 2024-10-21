function [r2, r1, r0] = discrete_pid_parameters(Kk, Tk, T)
% KK - critical gain
% Tk - critical oscillations [s]
% T - sample time [s]

Kp = 0.6*Kk; Ti = 0.5*Tk; Td = 0.12*Tk;

r2 = Kp*Td/T;
r1 = Kp*(T/(2*Ti) - 2*(Td/T) - 1);
r0 = Kp*(1+(T/(2*Ti)+Td/T));
end