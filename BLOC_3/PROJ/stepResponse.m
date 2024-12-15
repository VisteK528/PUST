function y = stepResponse(Upp, Ypp, du, n)
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
    
      if i >= 6
          Ukm5 = u(i-5);
      else
          Ukm5 = Upp;
      end
    
      if i >= 7
          Ukm6 = u(i-6);
      else
          Ukm6 = Upp;
      end
    
      y(i) = symulacja_obiektu11y_p3(Ukm5,Ukm6,Ykm1,Ykm2);
    end
end