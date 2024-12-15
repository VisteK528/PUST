function [r2, r1, r0] = discrete_pid_parameters(Kp, Ti, Td, T)
% KK - critical gain
% Tk - critical oscillations [s]
% T - sample time [s]

r2 = Kp*Td/T;
r1 = Kp*(T/(2*Ti) - 2*(Td/T) - 1);
r0 = Kp*(1+(T/(2*Ti)+Td/T));
end