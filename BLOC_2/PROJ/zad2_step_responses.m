%% Test2
N = 300;
Upp = 0;
Ypp = 0;
Z = 0;

u = zeros(N, 1);
y = zeros(N, 1);
z = zeros(N, 1);

u_jump_time = 10;
jumps = [0.1 1 10];

y_steady_u = zeros(N, length(jumps));
y_steady_z = zeros(N, length(jumps));

for i=1:2
    for j=1:length(jumps)
        y = zeros(N, 1);
        z = zeros(N, 1);
        u = zeros(N, 1);
        if(i == 1) 
            u(u_jump_time:end) = jumps(j);
        elseif(i == 2)
            z(u_jump_time:end) = jumps(j);
        end
        
        for k=1:N
            if(k - 8 < 1)
                ukm8 = Upp;
            else
                ukm8 = u(k-8);
            end
        
            if(k - 7 < 1)
                ukm7 = Upp;
            else
                ukm7 = u(k-7);
            end
        
            if(k - 4 < 1)
                zkm4 = Z;
            else
                zkm4 = z(k-4);
            end
        
            if(k - 3 < 1)
                zkm3 = Z;
            else
                zkm3 = z(k-3);
            end
        
            if(k - 2 < 1)
                ykm2 = Ypp;
            else
                ykm2 = y(k-2);
            end
        
            if(k - 1 < 1)
                ykm1 = Ypp;
            else
                ykm1 = y(k-1);
            end
        
            y(k) = symulacja_obiektu11y_p2(ukm7, ukm8, zkm3, zkm4, ykm1, ykm2);
        end
    
        if(i == 1) 
            y_steady_u(:, j) = y;
        elseif(i == 2)
            y_steady_z(:, j) = y;
        end
    end
end

for i=1:length(jumps)
    % Create a figure
    figure;
    
    % Plot first subplot (top)
    subplot(2, 1, 1); % 2 rows, 1 column, 1st plot
    stairs(y_steady_u(:, i));
    grid on;
    grid(gca, 'minor');
    title('Tor wejście-wyjście');
    xlabel('$k$', 'fontsize', 14, 'Interpreter', 'latex');
    ylabel('$y$', 'fontsize', 14, 'Interpreter', 'latex');
    
    % Plot second subplot (bottom)
    subplot(2, 1, 2); % 2 rows, 1 column, 2nd plot
    plot(y_steady_z(:, i)); % Replace with other data if needed
    grid on;
    grid(gca, 'minor');
    title('Tor zakłócenie-wyjście');
    xlabel('$k$', 'fontsize', 14, 'Interpreter', 'latex');
    ylabel('$y$', 'fontsize', 14, 'Interpreter', 'latex');
    
    % Set figure size and position
    x0 = 10;
    y0 = 10;
    width = 1280;
    height = 720;
    set(gcf, 'position', [x0, y0, width, height]);
    
    % Export the figure as a PDF if export_pictures is true
    export_pictures = true;
    file_name = "images/ex2_step_responses_step=" + string(jumps(i)) + ".pdf";
    if export_pictures
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
    end
end
