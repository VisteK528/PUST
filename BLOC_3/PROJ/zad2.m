Upp = 0.0;
Ypp = 0.0;
du_max = 1.0;
n = 50;
n_plots = 100;
y_stat = zeros(1, n_plots);
u = zeros(1, n_plots);

for i=1:n_plots
    du = -du_max + 2 * du_max * (i-1) / (n_plots-1);
    y = stepResponse(Upp, Ypp, du, n);

    %hold on;
    %stairs(y, 'DisplayName', "Skok na u=" + (Upp + du));
    %xlabel("k");
    %ylabel("y(k)");

    y_stat(i) = y(n);
    u(i) = Upp + du;
end
%legend;
%hold off;

% Charakterystyka statyczna
figure;
title("Charakterystyka statyczna");
plot(u, y_stat);
xlabel("u");
ylabel("y(u)");