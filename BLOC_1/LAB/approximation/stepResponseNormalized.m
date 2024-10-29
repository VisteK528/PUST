function y = stepResponseNormalized(Upp, Ypp, du, D, K, T1, T2, td)
    u = ones(D, 1) * (Upp + du);
    y = ones(D, 1) * Ypp;
    [a, b] = calculate_coefficients(T1, T2, K);
    
    for k=2:D
        if(k - td - 1 < 1)
            uktdm1 = Upp;
        else
            uktdm1 = u(k - td - 1);
        end
    
        if(k - td - 2 < 1)
            uktdm2 = Upp;
        else
            uktdm2 = u(k - td - 2);
        end
    
        if(k - 1 < 1)
            ykm1 = Ypp;
        else
            ykm1 = y(k-1);
        end
    
        if(k - 2 < 1)
            ykm2 = Ypp;
        else
            ykm2 = y(k-2);
        end
    
        y(k) = heating_station_simulation(uktdm1, uktdm2, ykm1, ykm2, a, b);
    end

    y = (y - ones(D, 1) * Ypp) / du;
end