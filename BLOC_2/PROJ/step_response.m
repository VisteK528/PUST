function [y] = step_response(Upp, Ypp, kend, step_time, step_value, step_type)

u = zeros(kend, 1);
y = zeros(kend, 1);
z = zeros(kend, 1);
Z = 0;

if(step_type == "u")
    u(step_time:kend) = step_value;
elseif(step_type == "z")
    z(step_time:kend) = step_value;
end


for k=1:kend
    if(k - 8 < 1)
        ukm8 = Upp;
    else
        ukm8 = u(k-8);
    end

    if(k - 7 < 1)
        ukm7 = Upp;
    else
        ukm7 = u(k-7);
    end

    if(k - 4 < 1)
        zkm4 = Z;
    else
        zkm4 = z(k-4);
    end

    if(k - 3 < 1)
        zkm3 = Z;
    else
        zkm3 = z(k-3);
    end

    if(k - 2 < 1)
        ykm2 = Ypp;
    else
        ykm2 = y(k-2);
    end

    if(k - 1 < 1)
        ykm1 = Ypp;
    else
        ykm1 = y(k-1);
    end

    y(k) = symulacja_obiektu11y_p2(ukm7, ukm8, zkm3, zkm4, ykm1, ykm2);
end

% Zakładam, że dla czasu step_time=1, chcemy mieć zestaw liczb s dla DMC, 
% a więc należy odrzucić pierwszy element.
% if(step_time == 1)
%     y = y(2:end);
% end

end