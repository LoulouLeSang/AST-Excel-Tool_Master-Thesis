function Vb = computeWaterVolume(Ro, Ri, P, N, beta,Z_wl)
    % Number of discretization steps
    dr = (Ro - Ri) / 400;  % Radial step size
    dtheta = (2 * pi) / 360; % Angular step size
    
    % Initialize volume
    Vb = 0;
    
    % Loop over radial and angular elements
    for r = Ri:dr:Ro
        for theta = 0:dtheta:(2 * pi)
            % Compute z1 and z2 based on given formulas
            z1 = r * cos(theta) * cosd(beta) - (P * theta / (2 * pi)) * sind(beta);
            z2 = r * cos(theta) * cosd(beta) - ((P * theta / (2 * pi)) - (P / N)) * sind(beta);
            
            % Compute differential volume element based on conditions
            if z2 > Z_wl && z1 > Z_wl
                dV = 0;
            elseif z2 >= Z_wl && z1 < Z_wl
                dV = ((Z_wl - z1) / (z2 - z1)) * (P / N) * r * dr * dtheta;
            else
                dV = (P / N) * r * dr * dtheta;
            end
            
            % Accumulate total volume
            Vb = Vb + dV ;
        end
    end
end
