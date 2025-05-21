clear all; 
close all; 
clc;

% Load data
data = readmatrix('DATA.xlsx');

% Extract columns
actual_DO = data(:,1);
E_Rhomer = data(:,2);
E_drago = data(:,3);
E_yoosef = data(:,4);
E_sis_rhom = data(:,5);
E_sis_drago = data(:,6);

% Define methods
methods = {E_Rhomer, E_drago, E_yoosef, E_sis_rhom, E_sis_drago};
labels = {'Rhomer', 'Drago', 'Yoosef', 'Sis Rhom', 'Sis Drago'};
colors = {'b', 'r', 'g', 'm', 'k'}; % Different colors

%% --- 1. ERROR ANALYSIS ---
errors = cellfun(@(x) x - actual_DO, methods, 'UniformOutput', false);

% Compute Mean Absolute Error (MAE), RMSE, and Bias
MAE = cellfun(@(x) mean(abs(x)), errors);
RMSE = cellfun(@(x) sqrt(mean(x.^2)), errors);
Bias = cellfun(@mean, errors);

% Display metrics
error_table = table(labels', MAE', RMSE', Bias', ...
                   'VariableNames', {'Method', 'MAE', 'RMSE', 'Bias'});
disp(error_table);

%% --- 2. PLOT ERROR DEVIATIONS (CLEARER THAN SCATTER PLOTS) ---
figure;
hold on;
grid on;

for i = 1:length(methods)
    scatter(actual_DO, errors{i}, 40, colors{i}, 'filled', ...
            'MarkerFaceAlpha', 0.6, 'DisplayName', labels{i});
end

yline(0, 'k--', 'LineWidth', 1.5); % Reference line (zero error)
xlabel('Actual D_O (m)');
ylabel('Estimation Error (Estimated - Actual)');
title('Deviation of Estimated D_O from Actual Values');
legend('Location', 'bestoutside');
hold off;

% Save figure
saveas(gcf, 'Error_Deviations.png');

%% --- 3. PLOT ALL DATA IN A SINGLE COMPARISON PLOT ---

% Plot all methods together
figure;
hold on;
grid on;

for i = 1:length(methods)
    scatter(actual_DO, methods{i}, 40, colors{i}, 'filled', ...
            'MarkerFaceAlpha', 0.6, 'DisplayName', labels{i});
end

% 1:1 Reference Line
x_ref = linspace(min(actual_DO), max(actual_DO), 100);
plot(x_ref, x_ref, 'k--', 'LineWidth', 1.5, 'DisplayName', '1:1 Line');

% ±5% and ±10% Error Bands
plot(x_ref, x_ref * 1.05, 'b--', 'LineWidth', 1, 'HandleVisibility', 'off');
plot(x_ref, x_ref * 0.95, 'b--', 'LineWidth', 1, 'HandleVisibility', 'off');
plot(x_ref, x_ref * 1.10, 'r--', 'LineWidth', 1, 'HandleVisibility', 'off');
plot(x_ref, x_ref * 0.90, 'r--', 'LineWidth', 1, 'HandleVisibility', 'off');

xlabel('Actual D_O (m)');
ylabel('Estimated D_O (m)');
title('Comparison of Actual vs. Estimated D_O');
legend('Location', 'bestoutside');
hold off;

% Save figure
saveas(gcf, 'Comparison_All_Methods.png');
