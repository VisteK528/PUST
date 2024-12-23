clear all;

D = 250;
nu = 4;
ny = 3;
kstart = 10;
S = stepResponses(D, nu, ny);


figure;

for i=1:nu
    for j=1:ny
        
        subplot(4, 3, (i-1)*ny+j); % Specify position in the grid
        
        stairs(S{i, j}); % Example plot, replace with your data
        ylim([0, 3]);
        xlim([0, D]);
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