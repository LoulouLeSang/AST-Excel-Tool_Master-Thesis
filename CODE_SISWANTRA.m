clear; clc;

% === Load your archimedesData structure (make sure you've run the parsing script first) ===
% Example: load('archimedesData.mat') if you've saved it
% or make sure archimedesData is already in your workspace.
filename = 'archimedes_data.txt';
fid = fopen(filename, 'r');

% Skip header
fgetl(fid);

archimedesData = struct('ID', {}, 'Name', {}, 'Do', {}, 'H', {}, 'Q', {}, 'P', {}, 'Ref', {});

lineIndex = 1;
while ~feof(fid)
    line = strtrim(fgetl(fid));
    if isempty(line)
        continue;
    end
    
    % Split by spaces or tabs
    tokens = regexp(line, '\s+', 'split');

    % First token = ID
    ID = str2double(tokens{1});
    
    % The tricky part: find where numeric fields start
    % This will be the first token (after ID) that can be parsed as a number
    nameTokens = {};
    for i = 2:length(tokens)
        if ~isnan(str2double(tokens{i}))  % Number found
            firstNumIndex = i;
            break;
        else
            nameTokens{end+1} = tokens{i};
        end
    end
    
    % Extract name and numeric values
    Name = strjoin(nameTokens, ' ');
    Do = str2double(tokens{firstNumIndex});
    H = str2double(tokens{firstNumIndex + 1});
    Q = str2double(tokens{firstNumIndex + 2});
    P = str2double(tokens{firstNumIndex + 3});
    
    % Everything after that is reference
    Ref = strjoin(tokens(firstNumIndex + 4:end), ' ');

    % Store in structure
    archimedesData(lineIndex).ID = ID;
    archimedesData(lineIndex).Name = Name;
    archimedesData(lineIndex).Do = Do;
    archimedesData(lineIndex).H = H;
    archimedesData(lineIndex).Q = Q;
    archimedesData(lineIndex).P = P;
    archimedesData(lineIndex).Ref = Ref;

    lineIndex = lineIndex + 1;
end

fclose(fid);

% Display the first entry to check
%disp(archimedesData(1))

% === Constants for the design calculation ===
g=9.81 ; 
beta = 22;             % Inclination angle in degrees
N = 3;                 % Number of blades
delta = 0.54;          % Diameter ratio (D_i / D_o)
f = 1;                 % Filling ratio (optimal)
mu=0.537;               %constant for Qov
kv=0.773 ; 

% === Iteration settings ===
step = 0.000001;         % Increment step for D_o
tolerance = 1e-4;      % Convergence tolerance

% === Initialize results structure ===
resultsData = struct('ID', {}, 'Name', {}, 'Q_design', {}, 'Do_estimated', {}, 'Q_estimated', {}, 'Error_percent', {});

% === Loop over each plant in your list ===
% === Loop over each plant in your list ===
for i = 1:length(archimedesData)
    i
    Q_design = archimedesData(i).Q;
    Do_guess = 0.03;  % Initial guess for each iteration

    tic;  % Start timer

    while true
        Do = Do_guess;
        Ro = Do / 2;
        Ri = delta * Ro;
        S = (2 * Ro); 
        G_w = 0.0045 * sqrt(Do);

        % Compute water level
        Z_min = -Ro * cosd(beta) - (S / 2) * sind(beta);
        Z_max = Ri * cosd(beta) - S * sind(beta);
        Z_wl = Z_min + f * (Z_max - Z_min);

        % Numerical integration of Vb (approx.)
        Vb = computeWaterVolume(Ro, Ri, S, N, beta, Z_wl);

        % Compute omega_max (Muysken limit)
        omega_max = (5 * pi) / (3 * Do^(2/3));   % rad/s

        % Compute discharge
        Q_eff = (N * Vb * omega_max) / (2 * pi);
        Q_g = 2.5 * G_w * Do^1.5;
        Q_ov = 4/15 * mu * sqrt(2 * g) * (1/tand(beta) + tand(beta)) * (Z_wl - Z_max)^(5/2);
        Q_estimation = Q_eff + Q_ov + Q_g;

        % Compare to design discharge
        error = abs((Q_estimation - Q_design) / Q_design);

        if error < tolerance
            break;
        end

        Do_guess = Do_guess + step;
    end
    Do
    computationTime = toc;  % End timer

    % Display computation time
    fprintf('ID %d | Computation time: %.4f seconds\n', archimedesData(i).ID, computationTime);

    % Store results
    resultsData(i).ID = archimedesData(i).ID;
    resultsData(i).Name = archimedesData(i).Name;
    resultsData(i).Q_design = Q_design;
    resultsData(i).Do_estimated = Do;
    resultsData(i).Q_estimated = Q_estimation;
    resultsData(i).Error_percent = (Q_estimation - Q_design) / Q_design * 100;
    resultsData(i).ComputationTime = computationTime;  % NEW FIELD
end

% Optional: save results
save('archimedes_results.mat', 'resultsData');



% Load the results
load('archimedes_results.mat');

% Open the text file for writing
fileID = fopen('archimedes_results.txt', 'w');

% Write the header in the text file
fprintf(fileID, 'ID\tEstimated Diameter (D_o) [m]\n');

% Loop through the results and write the data into the text file
for i = 1:length(resultsData)
    fprintf(fileID, '%d\t%.4f\n', resultsData(i).ID, resultsData(i).Do_estimated);
end

% Close the text file
fclose(fileID);

disp('Text file created: archimedes_results.txt');   