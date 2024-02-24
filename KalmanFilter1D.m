% Kalman Filter calculation practice (1 Dimensional)

clear
close all
clc

trueTemp = 72;

% Initial Estimate
EST = 68;

% Errors
Eest = 2;  % error in estimate
Emea = 4;  % error in measurement

% Measurements
% TempMEA = [75, 71, 70, 74];

ms = 500;  % total measurements
TempMEA = transpose(((trueTemp+Emea)-(trueTemp-Emea)).*rand(ms,1)+(trueTemp-Emea));

% Calculations
time_m = zeros(1, length(TempMEA));
Emea_m = zeros(1, length(TempMEA));
EST_m = zeros(1, length(TempMEA));
KG_m = zeros(1, length(TempMEA));
Eest_m = zeros(1, length(TempMEA));

for T = 1:length(TempMEA)
    KG = Eest / (Eest + Emea);  % Kalman Gain
    EST = EST + KG*(TempMEA(T) - EST);  % Current Estimate
    Eest = (Emea * Eest) / (Emea + Eest);  % Current Error in Estimate
    % Collect data
    time_m(T) = T;
    Emea_m(T) = Emea;
    EST_m(T) = EST;
    KG_m(T) = KG;
    Eest_m(T) = Eest;
end

% Data
fprintf('Time__Temp Measurement__Measurement Error__Temp Estimate__Kalman Gain__Error Estimate')
outputData = transpose([time_m; TempMEA; Emea_m; EST_m; KG_m; Eest_m])

% Plots
figure(1)
scatter(time_m, TempMEA, 'r', 'filled')
hold on
plot(time_m, EST_m, 'g', 'LineWidth', 2)
yline(trueTemp, 'k', 'LineWidth', 2)
xlabel('Measurement')
% xticks(time_m)
ylabel('Temperature')
title('Kalman Filter Estimates for Temperature')
legend('Measurements', 'Estimations', 'True Temperature')

figure(2)
plot(time_m, Eest_m, 'b', 'LineWidth', 2)
xlabel('Measurement')
ylabel('Error')
title('Kalman Filter Error for Estimates')

figure(3)
plot(time_m, KG_m, 'm', 'LineWidth', 2)
xlabel('Measurement')
ylabel('Kalman Gain')
title('Kalman Filter Kalman Gain')




