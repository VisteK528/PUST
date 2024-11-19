%% Ogolne
Upp = 0;
Ypp = 0;

%% Tor u -> y
U = [1 5 10];
figure;
for u=U
    y = step_response(Upp, Ypp, 100, 1, u, "u");
    stairs(y);
    hold on;
end

name = "images/zad_tor_u_y.png";
grid on;
grid(gca, 'minor');
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('y', 'fontsize', 14, 'Interpreter', 'latex');
legend("U=1", "U=5", "U=10");

% Set figure size and position
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);
exportgraphics(gcf, name, 'Resolution', 400);


%% Tor z -> y
Z = [1 5 10];
figure;
for z=Z
    y = step_response(Upp, Ypp, 30, 1, z, "z");
    stairs(y);
    hold on;
end

name = "images/zad_tor_z_y.png";
grid on;
grid(gca, 'minor');
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('y', 'fontsize', 14, 'Interpreter', 'latex');
legend("Z=1", "Z=5", "Z=10");

% Set figure size and position
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);
exportgraphics(gcf, name, 'Resolution', 400);