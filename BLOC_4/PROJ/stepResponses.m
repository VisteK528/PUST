clear all;

D = 250;
nu = 4;
ny = 3;

kstart = 10;

y_step = cell(nu, ny);
for i=1:nu
    u = zeros(D+kstart, nu);
    u(kstart:end, i) = 1;
    y = zeros(D+kstart, ny);

    for k=kstart:(D+kstart)
        [y1, y2, y3] = symulacja_obiektu11y_p4(u(k-1, 1), u(k-2, 1), ...
            u(k-3, 1), u(k-4, 1), u(k-1, 2), u(k-2, 2), u(k-3, 2), ...
            u(k-4, 2), u(k-1, 3), u(k-2, 3), u(k-3, 3), u(k-4, 3), ...
            u(k-1, 4), u(k-2, 4), u(k-3, 4), u(k-4, 4), y(k-1, 1), ...
            y(k-2, 1), y(k-3, 1), y(k-4, 1), y(k-1, 2), y(k-2, 2), ...
            y(k-3, 2), y(k-4, 2), y(k-1, 3), y(k-2, 3), y(k-3, 3), ...
            y(k-4, 3));

        y(k, 1) = y1;
        y(k, 2) = y2;
        y(k, 3) = y3;
    end
    y_step{i, 1} = y(:, 1);
    y_step{i, 2} = y(:, 2);
    y_step{i, 3} = y(:, 3);

end

figure;

for i=1:nu
    for j=1:ny
        
        subplot(4, 3, (i-1)*ny+j); % Specify position in the grid
        
        stairs(y_step{i, j}); % Example plot, replace with your data
        ylim([0, 3]);
        xlim([0, D+kstart]);
        grid on;
    end
end

for col = 1:3
    % Position text above the subplots
    annotation('textbox', [0.19 + 0.28*(col-1), 0.92, 0.1, 0.05], ...
               'String', ['Y', num2str(col)], ...
               'HorizontalAlignment', 'center', ...
               'EdgeColor', 'none', ...
               'FontSize', 12);
end

for row = 1:4
    % Position text to the left of the subplots
    annotation('textbox', [0.01, 0.80 - 0.22*(row-1), 0.18, 0.05], ...
               'String', ['U', num2str(row)], ...
               'HorizontalAlignment', 'center', ...
               'EdgeColor', 'none', ...
               'FontSize', 12);
end

set(gcf, 'Position', [100, 100, 1920, 1080]); % [left, bottom, width, height];