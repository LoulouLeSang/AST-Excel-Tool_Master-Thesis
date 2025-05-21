% Compute errors (Actual D_O - Estimated D_O)
error_Rhomer = actual_DO - E_Rhomer;
error_Drago = actual_DO - E_drago;
error_Yoosef = actual_DO - E_yoosef;
error_SisRhom = actual_DO - E_sis_rhom;
error_SisDrago = actual_DO - E_sis_drago;

% Define histogram settings
numBins = 20; % Adjust for more/less smoothing
alphaVal = 0.5; % Transparency of bars

% Error arrays and labels
errors = {error_Rhomer, error_Drago, error_Yoosef, error_SisRhom, error_SisDrago};
labels = {'Rhomer', 'Drago', 'Yoosef', 'Sis Rhom', 'Sis Drago'};
colors = {'b', 'r', 'g', 'm', 'k'}; % Colors for different methods

% Loop through each method and create a separate figure
for i = 1:length(errors)
    figure; % New figure for each method
    hold on;
    grid on;

    % Plot histogram with probability density normalization
    histogram(errors{i}, numBins, 'Normalization', 'pdf', ...
              'FaceAlpha', alphaVal, 'FaceColor', colors{i});
    
    % Labels
    xlabel('Error (Actual D_O - Estimated D_O)');
    ylabel('Density');
    title(['Histogram Density Estimate of Errors - ', labels{i}]);
    % Save figure as PNG
    filename = ['error_histogram_' methods{i} '.png'];
    saveas(gcf, filename);

    hold off;
    close ; 
end
