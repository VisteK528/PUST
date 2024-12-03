step_response = [33.25 37.81 42.25 46.93 48.43 49.25 51.56 52.67 53.75];
u = [20 30 40 50 55 60 70 75 80];

figure;
title("Charakterystyka statyczna");
plot(u, step_response);
grid on;
xlabel("u");
ylabel("y(u)");

