%% Test1


%% Test2
N = 100;
Upp = 0;
Ypp = 0;
Z = 0;

u = zeros(N, 1);
y = zeros(N, 1);
z = zeros(N, 1);

u(10:end) = 5;
for k=1:N
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

figure;
stairs(y);