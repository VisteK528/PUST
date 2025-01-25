function [S, H] = stepResponses(D, nu, ny)
    kstart = 10;
    
    S = cell(nu, ny);
    H_temp = zeros(ny, nu, D);
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
            
            H_temp(1, i, k) = y1;
            H_temp(2, i, k) = y2;
            H_temp(3, i, k) = y3;
        end
        S{i, 1} = y(kstart+1:end, 1);
        S{i, 2} = y(kstart+1:end, 2);
        S{i, 3} = y(kstart+1:end, 3);
    
    end
    H(:, :, :) = H_temp(:, :, kstart+1:end);

end