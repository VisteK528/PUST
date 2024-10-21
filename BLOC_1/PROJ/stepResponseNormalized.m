function y = stepResponseNormalized(Upp, Ypp, du, n)
    u = (Upp + du) * ones(1, n);
    y = zeros(1, n);
    
    for i=1:n
      if i >= 2
          Ykm1 = y(i-1);
      else
          Ykm1 = Ypp;
      end
      
      if i >= 3
          Ykm2 = y(i-2);
      else
          Ykm2 = Ypp;
      end
    
      if i >= 11
          Ukm10 = u(i-10);
      else
          Ukm10 = Upp;
      end
    
      if i >= 12
          Ukm11 = u(i-11);
      else
          Ukm11 = Upp;
      end
    
      y(i) = symulacja_obiektu11y_p1(Ukm10,Ukm11,Ykm1,Ykm2);
    end

    y = (y - ones(1, n) * Ypp) / du;
end
