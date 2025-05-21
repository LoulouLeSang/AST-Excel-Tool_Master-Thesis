clear all; close all; clc;

% Load the data from an Excel file
data = readmatrix('DATA.xlsx');

% Extract columns (replace with actual indices)
actual_DO = data(:,1); % Column for Actual D_O
E_Rhomer = data(:,2);
E_drago = data(:,3);
E_yoosef = data(:,4);
E_sis_rhom = data(:,5);
E_sis_drago = data(:,6);

% Define index ranges
bigger_AST = 1:48;
small_AST = 49:55;

% Compute the Percentage Error (PE) for each estimation method for Bigger ASTs
PE_Rhomer_bigger = abs(E_Rhomer(bigger_AST) - actual_DO(bigger_AST)) ./ abs(actual_DO(bigger_AST)) * 100;
PE_drago_bigger = abs(E_drago(bigger_AST) - actual_DO(bigger_AST)) ./ abs(actual_DO(bigger_AST)) * 100;
PE_yoosef_bigger = abs(E_yoosef(bigger_AST) - actual_DO(bigger_AST)) ./ abs(actual_DO(bigger_AST)) * 100;
PE_sis_rhom_bigger = abs(E_sis_rhom(bigger_AST) - actual_DO(bigger_AST)) ./ abs(actual_DO(bigger_AST)) * 100;
PE_sis_drago_bigger = abs(E_sis_drago(bigger_AST) - actual_DO(bigger_AST)) ./ abs(actual_DO(bigger_AST)) * 100;

% Compute the Percentage Error (PE) for each estimation method for Small ASTs
PE_Rhomer_small = abs(E_Rhomer(small_AST) - actual_DO(small_AST)) ./ abs(actual_DO(small_AST)) * 100;
PE_drago_small = abs(E_drago(small_AST) - actual_DO(small_AST)) ./ abs(actual_DO(small_AST)) * 100;
PE_yoosef_small = abs(E_yoosef(small_AST) - actual_DO(small_AST)) ./ abs(actual_DO(small_AST)) * 100;
PE_sis_rhom_small = abs(E_sis_rhom(small_AST) - actual_DO(small_AST)) ./ abs(actual_DO(small_AST)) * 100;
PE_sis_drago_small = abs(E_sis_drago(small_AST) - actual_DO(small_AST)) ./ abs(actual_DO(small_AST)) * 100;

% Combine the PE data for both Bigger and Small ASTs into a single variable
data_bigger = {PE_Rhomer_bigger, PE_drago_bigger, PE_yoosef_bigger, PE_sis_rhom_bigger, PE_sis_drago_bigger};
data_small = {PE_Rhomer_small, PE_drago_small, PE_yoosef_small, PE_sis_rhom_small, PE_sis_drago_small};

% Create custom boxplot-like graph for Bigger ASTs
figure;
hold on;
grid on;

% Labels for the methods
labels = {'Rhomer', 'Drago', 'Yoosef', 'Sis Rhom', 'Sis Drago'};

% For each data series, calculate and plot the custom boxplot data
for i = 1:length(data_bigger)
    data = data_bigger{i};
    
    % Calculate quartiles and median
    q1 = prctile(data, 25); % 25th percentile
    q3 = prctile(data, 75); % 75th percentile
    median_val = median(data); % Median value
    min_val = min(data); % Min value
    max_val = max(data); % Max value

    % Plot the box (rectangular box from q1 to q3)
    plot([i-0.2, i+0.2], [q1, q1], 'k-', 'LineWidth', 2); % Lower quartile
    plot([i-0.2, i+0.2], [q3, q3], 'k-', 'LineWidth', 2); % Upper quartile
    plot([i, i], [q1, q3], 'k-', 'LineWidth', 2); % Box line
    
    % Plot the median
    plot([i-0.2, i+0.2], [median_val, median_val], 'r-', 'LineWidth', 2); % Median line
    
    % Plot the min and max values as dots
    plot(i, min_val, 'ro', 'MarkerFaceColor', 'r');
    plot(i, max_val, 'ro', 'MarkerFaceColor', 'r');
end

% Labels and title
xlabel('Estimation Method');
ylabel('Percentage Error (%)');
title('Percentage Error for Bigger ASTs');

% Set the x-axis ticks and labels
set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels);

% Save the figure for Bigger ASTs
saveas(gcf, 'PE_Bigger_ASTs_CustomBoxplot.png');

% Create custom boxplot-like graph for Small ASTs
figure;
hold on;
grid on;

% For each data series, calculate and plot the custom boxplot data
for i = 1:length(data_small)
    data = data_small{i};
    
    % Calculate quartiles and median
    q1 = prctile(data, 25); % 25th percentile
    q3 = prctile(data, 75); % 75th percentile
    median_val = median(data); % Median value
    min_val = min(data); % Min value
    max_val = max(data); % Max value

    % Plot the box (rectangular box from q1 to q3)
    plot([i-0.2, i+0.2], [q1, q1], 'k-', 'LineWidth', 2); % Lower quartile
    plot([i-0.2, i+0.2], [q3, q3], 'k-', 'LineWidth', 2); % Upper quartile
    plot([i, i], [q1, q3], 'k-', 'LineWidth', 2); % Box line
    
    % Plot the median
    plot([i-0.2, i+0.2], [median_val, median_val], 'r-', 'LineWidth', 2); % Median line
    
    % Plot the min and max values as dots
    plot(i, min_val, 'ro', 'MarkerFaceColor', 'r');
    plot(i, max_val, 'ro', 'MarkerFaceColor', 'r');
end

% Labels and title
xlabel('Estimation Method');
ylabel('Percentage Error (%)');
title('Percentage Error for Small ASTs');

% Set the x-axis ticks and labels
set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels);

% Save the figure for Small ASTs
saveas(gcf, 'PE_Small_ASTs_CustomBoxplot.png');
