clear;

working_points = [-0.8 0 0.4]; 

u_min = -1; 
u_max = 1; 
u_values = linspace(u_min, u_max, 500); 

membership_values = zeros(length(working_points), length(u_values));
for i = 1:length(u_values)
    u = u_values(i);
    membership_values(:, i) = membershipFunction(working_points, u);
end

figure;
hold on;
colors = lines(length(working_points)); % Generowanie unikalnych kolorów
for i = 1:length(working_points)
    plot(u_values, membership_values(i, :), 'Color', colors(i, :));
end

xlabel('u');
ylabel('w');
legend(arrayfun(@(x) sprintf('Regulator %d', x), 1:length(working_points)));
grid on;
hold off;

exportgraphics(gcf, 'images/proj_fuzzy_fun.pdf', 'ContentType', 'vector');
