%% Test2
N = 300;
Upp = 0;
Ypp = 0;
Z = 0;

u = zeros(N, 1);
y = zeros(N, 1);
z = zeros(N, 1);

u_jump_points = 100;
u_max_jump = 15;
u_jump_time = 10;
u_jumps = linspace(Upp, u_max_jump, u_jump_points);
y_steady = zeros(u_jump_points, u_jump_points);

for i=1:u_jump_points
    u = zeros(N, 1);
    u(u_jump_time:end) = u_jumps(i);

    for j=1:u_jump_points
        y = zeros(N, 1);
        z = zeros(N, 1);
        z(u_jump_time:end) = u_jumps(j);
        
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
    
        y_steady(i, j) = y(end);
    end
end

% Create a mesh grid for u_jumps to plot y_steady in 3D
[U1, U2] = meshgrid(u_jumps, u_jumps);

% Create a 3D surface plot
figure;
surf(U1, U2, y_steady);
xlabel('$u_1$', 'Interpreter', 'latex', 'fontsize', 14); % x-axis for u_jumps
ylabel('$u_2$', 'Interpreter', 'latex', 'fontsize', 14); % y-axis for u_jumps
zlabel('$y_{steady}$', 'Interpreter', 'latex', 'fontsize', 14); % z-axis for y_steady
title('3D Surface Plot of Steady-State Output $y_{steady}$', 'Interpreter', 'latex');
colorbar; % Add color bar to show the color scale
grid on;
