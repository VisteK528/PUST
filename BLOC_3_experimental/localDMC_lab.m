classdef localDMC_lab
    properties
        % Constraints
        u_min = -1
        u_max = 1
        % Trajectory
        yzad
        % Regulator parameters
        deltauk_p
        u
        Ke
        Ku
        % Horizont
        D
        Upp
        U
    end

    methods
        function obj = localDMC_lab(N, Nu, D, lambda, Upp, U, yzad, kend)  
            obj.D = D;
            obj.yzad = yzad;
            obj.Upp = Upp;
            obj.U = U;
        
            %Yodp = stepResponse(0, 0, Upp, 50);
            %Ypp = Yodp(50);
        
            % Step response
            %s = stepResponseNormalized(Upp, Ypp, 0.01, D+1);
            %s = s(2:end);
            [s, Ypp] = step_response_lab(D, Upp, U);
            
            % Fill M matrix
            M = zeros(N, Nu);
            for i=1:Nu
                M(i:end,i)=s(1:N-i + 1);
            end
            
            % Fill MP matrix
            MP = zeros(N, D-1);
            for i = 1:N
                for j = 1:D-1
                    if i+j <= D    
                        MP(i, j) = s(i+j) - s(j);
                    else
                        MP(i, j) = s(D) - s(j);
                    end
                end
            end
            
            % Regulator parameters
            I = eye(Nu);
            K = ((M'*M+lambda*I)^(-1))*M';
            obj.Ku = K(1,:)*MP;
            obj.Ke = sum(K(1, :));
            
            % Variables initialization
            obj.u = zeros(kend, 1);
            obj.deltauk_p = zeros(D-1, 1);
        end

        function u_current = iterationDMC(obj, k, y_current)
            % Compute error
            ek = obj.yzad(k) - y_current;
    
            % Compute deltau variable for given control horizon
            deltauk = obj.Ke * ek - obj.Ku * obj.deltauk_p;
    
            % Manipulate variable for time k
            u_current = obj.u(k-1) + deltauk;
    
            if(u_current < obj.u_min)
                u_current = obj.u_min;
            elseif(u_current > obj.u_max)
                u_current = obj.u_max;
            end
        end

        function obj = updateAfterIteration(obj, last_u, k)
            % Back deltau window
            for n=obj.D-1:-1:2
                obj.deltauk_p(n) = obj.deltauk_p(n-1);
            end
    
            obj.u(k) = last_u;
            obj.deltauk_p(1) = obj.u(k) - obj.u(k-1);
        end
    end
end