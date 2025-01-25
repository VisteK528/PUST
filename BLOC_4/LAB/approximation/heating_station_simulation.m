function [y] = heating_station_simulation(uktdm1, uktdm2, ykm1, ykm2, a, b)

y = b(1)*uktdm1 + b(2)*uktdm2 - a(1)*ykm1 - a(2)*ykm2;

end