function [K, MP, Ke, Ku] = offlineMIMO_DMC(H, psi, lambda, N, Nu)
    [ny, nu, D] = size(H);

    PSI = eye(N*ny, N*ny) * diag(repmat(psi, N, 1));
    LAMBDA = eye(Nu*nu, Nu*nu) * diag(repmat(lambda, Nu, 1));

    M = zeros(N*ny, Nu*nu);
    for i=1:Nu
        cell_element = permute(H(:, :, 1:N-i + 1), [1, 3, 2]);
        cell_element_reshaped = reshape(cell_element, [ny*(N-i+1), nu]);

        M(ny*(i-1)+1:end, (i-1)*nu+1:i*nu) = cell_element_reshaped;
    end
    
    MP = zeros(N*ny, (D-1)*nu);
    for i = 1:N
        for j = 1:D-1
            if i+j <= D
                MP(ny*(i-1)+1:ny*i, nu*(j-1)+1:nu*j) = H(:, :, i+j) - H(:, :, j);
            else
                MP(ny*(i-1)+1:ny*i, nu*(j-1)+1:nu*j) = H(:, :, D) - H(:, :, j);
            end
        end
    end


    K = ((M'*PSI*M+LAMBDA)^(-1))*M'*PSI;

    Ke = zeros(nu, ny);
    for i=1:N
        Ke = Ke + K(1:nu, (i-1)*ny+1:i*ny);
    end

    Ku = K(1:nu, 1:N*ny) * MP;
end