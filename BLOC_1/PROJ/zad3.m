clear;

Upp = 0.8;
Ypp = 5;
du = 0.05;
n = 150;

u = ones(1, n);
y_norm = stepResponseNormalized(Upp, Ypp, du, n);

% Plot
figure;
plot(y_norm);
hold on;
plot(u, '--');
title("Odpowiedź na skok jednostkowy");
xlabel("k");
ylabel("y(k) / u(k)");

% Save to file
name = "plot_data/z3_skok.txt";
writematrix([u; y_norm]', name);