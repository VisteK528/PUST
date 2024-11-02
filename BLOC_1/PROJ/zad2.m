clear;

Upp = 0.8;
Ypp = 5;
du_max = 0.05;
n = 100;
n_plots = 5;
y_stat = zeros(1, n_plots);
u = zeros(1, n_plots);

y_skok = zeros(n, n_plots);

figure;
hold on;

for i=1:n_plots
    du = du_max * i / n_plots;
    y = stepResponse(Upp, Ypp, du, n);

    % Odpowiedź skokowa
    plot(y, 'DisplayName', "du=" + du);
    title("Odpowiedzi skokowe");
    xlabel("k");
    ylabel("y(k)");

    y_stat(i) = y(n);
    y_skok(:, i) = y;
    u(i) = Upp + du;
end

hold off;
legend;

% Charakterystyka statyczna
figure;
title("Charakterystyka statyczna");
plot(u, y_stat);
xlabel("u");
ylabel("y(u)");

% Save to files
name1 = "plot_data/z2_skok.txt";
name2 = "plot_data/z2_ystat.txt";
writematrix(y_skok, name1);
writematrix([u; y_stat]', name2);
