Upp = 8e-01;
Ypp = 5;
du_max = 0.2;
n = 100;
n_plots = 50;
y_stat = zeros(1, n_plots);
u = zeros(1, n_plots);

for i=1:n_plots
    du = du_max * i / n_plots;
    y = stepResponse(Upp, Ypp, du, n);

    % Odpowiedź skokowa
    % figure;
    % plot(y);
    % title("Odpowiedź skokowa: skok z u=" + Upp + " na u=" + (Upp + du));
    % xlabel("k");
    % ylabel("y(k)");

    y_stat(i) = y(n);
    u(i) = Upp + du;
end

% Charakterystyka statyczna
figure;
title("Charakterystyka statyczna");
plot(u, y_stat);
xlabel("u");
ylabel("y(u)");
