% Load the data from Excel
filename = 'efficiency_data.xlsx';  % change to your actual filename
data = readtable(filename);

% Extract the flow rate and efficiencies
Q = data{:,1};  % Assuming first column is flow rate Q

% Extract efficiency values for each method
Rhomer = data{:,2};
Drago = data{:,3};
Yoosef = data{:,4};
SisRho = data{:,5};
SisDrag = data{:,6};

% Optional: remove rows with NaN (e.g., caused by #VALEUR!)
validIdx = ~any(isnan([Q Rhomer Drago Yoosef SisRho SisDrag]), 2);

% Filter out invalid rows
Q = Q(validIdx);
Rhomer = Rhomer(validIdx);
Drago = Drago(validIdx);
Yoosef = Yoosef(validIdx);
SisRho = SisRho(validIdx);
SisDrag = SisDrag(validIdx);

% Plot
figure;
plot(Q, Rhomer, '-o', 'DisplayName', 'Rohmer');
hold on;
plot(Q, Drago, '-s', 'DisplayName', 'Dragomirescu');
plot(Q, Yoosef, '-^', 'DisplayName', 'Yoosef');
plot(Q, SisRho, '-d', 'DisplayName', 'Sis/Rho');
plot(Q, SisDrag, '-x', 'DisplayName', 'Sis/Drag');
hold off;

grid on;
xlabel('Flow rate Q (m^3/s)');
ylabel('Efficiency [%]');
title('Efficiency vs Flow rate for Different Methods');
legend('Location','best');

