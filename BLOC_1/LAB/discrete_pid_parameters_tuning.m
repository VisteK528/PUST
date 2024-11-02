function [r2, r1, r0] = discrete_pid_parameters_tuning(Kp, Ti, Td, T)

r2 = Kp*Td/T;
r1 = Kp*(T/(2*Ti) - 2*(Td/T) - 1);
r0 = Kp*(1+(T/(2*Ti)+Td/T));
end