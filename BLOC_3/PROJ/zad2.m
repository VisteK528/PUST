clear;

Upp = 0.0;
Ypp = 0.0;
du_max = 1.0;
n = 50;
n_plots = 5;
y_stat = zeros(1, n_plots);
u = zeros(1, n_plots);

for i=1:n_plots
    du = -du_max + 2 * du_max * (i-1) / (n_plots-1);
    y = stepResponse(Upp, Ypp, du, n);

    hold on;
    stairs(y, 'DisplayName', "Skok na u=" + (Upp + du));
    xlabel("k");
    ylabel("y(k)");

    y_stat(i) = y(n);
    u(i) = Upp + du;
end
lgd = legend;
lgd.Position = [0.65, 0.3, 0.25, 0.15];
hold off;

% Charakterystyka statyczna
figure;
plot(u, y_stat);
xlabel("u");
ylabel("y(u)");

exportgraphics(gcf, 'images/proj_static_char.pdf', 'ContentType', 'vector');