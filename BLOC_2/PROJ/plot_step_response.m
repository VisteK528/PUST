%% Dane ogólne
clear all;
export_pictures = true;
Upp = 0;
Ypp = 0;
D = 90;
Dz = 30;



%% Odpowiedź skokowa toru u -> y
y_u = step_response(Upp, Ypp, D, 1, 1, "u");

figure;
stairs(y_u);
hold on;
scatter(1:(D-1), y_u, 'filled');
grid on;
grid(gca, 'minor');
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter', 'latex');

% Set figure size and position
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);
file_name = "images/ex3_step_response_u.pdf";
if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end

%% Odpowiedź skokowa toru z -> y
y_z = step_response(Upp, Ypp, Dz, 1, 1, "z");


figure;
stairs(y_z);
hold on;
scatter(1:(Dz-1), y_z, 'filled');
grid on;
grid(gca, 'minor');
xlabel('k', 'fontsize', 14, 'Interpreter', 'latex');
ylabel('$y$', 'fontsize', 14, 'Interpreter', 'latex');


% Set figure size and position
x0 = 10;
y0 = 10;
width = 1280;
height = 720;
set(gcf, 'position', [x0, y0, width, height]);

file_name = "images/ex3_step_response_z.pdf";
if export_pictures
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end