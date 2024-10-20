Upp = 0.5;
Ypp = 4;
du = 0.05;
n = 100;

y = stepResponse(Upp, Ypp, du, n);

y_norm = (y - Ypp) / du;

plot(y_norm);
title("Odpowiedź na skok jednostkowy");
xlabel("k");
ylabel("y(k)");