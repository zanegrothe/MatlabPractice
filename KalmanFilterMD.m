% Kalman Filter calculation practice (Multi-Dimensional)

clear
close all
clc

format shortG

% Initial Conditions
x = 4000;  % m
vx = 280;  % m/s
X = [x; vx];  % Initial State
ax = 2;  % m/s^2
dt = 1;  % s

% Errors
Eest = [20; 5];  % error in estimate
Emea = [25; 6];  % error in measurement
P = diag(diag(Eest * Eest'));  % Initial Process Covariance

% Adaptation Matrices
A = [1, dt; 0, 1];
B = [0.5*dt^2; dt];
C = eye(length(Emea));

% Transformation Matrix
H = eye(length(Emea));

% Noise
w = 0;  % Predicted State noise
z = 0;  % Measurement noise
Q = 0;  % Process noise
R = diag(diag(Emea * Emea'));  % Sensor noise

% Measurements
MEAx = [4260, 4550, 4860, 5110];  % x position
MEAvx = [282, 285, 286, 290];  % x velocity
MEA = [MEAx; MEAvx];

%% Calculations

time_m = zeros(1, length(MEA));
Emea_m = zeros(2, length(MEA));
EST_m = zeros(2, length(MEA));
KG_m = zeros(2, length(MEA));
Eest_m = zeros(2, length(MEA));

for T = 1:length(MEA)
    Xp = A * X + B * ax + w;  % Predicted State
    Pp = diag(diag(A * P * A' + Q));  % Predicted Process Covariance
    KG = (Pp * H') / (H * Pp * H' + R);  % Kalman Gain
    Y = C * MEA(:, T) + z;  % New Observation (measurement w/noise)
    X = Xp + KG * (Y - H * Xp);  % Current State Estimate
    P = (eye(length(Emea)) - KG * H) * Pp;  % Current Estimate Error
    % Collect data
    time_m(T) = T;
    Emea_m(:, T) = Emea;
    EST_m(:, T) = X;
    KG_m(:, T) = diag(KG);
    Eest_m(:, T) = diag(P);
end

% Data
fprintf('Time__Measurement(x,v)__Measurement Error(x,v)__Estimate(x,v)__Kalman Gain(x,v)__Error Estimate(x,v)')
outputData = [time_m; MEA; Emea_m; EST_m; KG_m; Eest_m]'

%% Plots

% Measurements vs Estimates
figure(1)
subplot(2,1,1)
scatter(time_m, MEA(1, :), 'r', 'filled')
hold on
plot(time_m, EST_m(1, :), 'g', 'LineWidth', 2)
hold off
xlabel('Measurement')
ylabel('Position')
title('Kalman Filter Estimates')
legend('Measurements', 'Estimations')

subplot(2,1,2)
scatter(time_m, MEA(2, :), 'r', 'filled')
hold on
plot(time_m, EST_m(2, :), 'g', 'LineWidth', 2)
hold off
xlabel('Measurement')
ylabel('Velocity')
legend('Measurements', 'Estimations')

% Errors
figure(2)
subplot(2,1,1)
plot(time_m, Eest_m(1, :), 'b', 'LineWidth', 2)
xlabel('Measurement')
ylabel('Position Error')
title('Kalman Filter Error for Estimates')

subplot(2,1,2)
plot(time_m, Eest_m(2, :), 'b', 'LineWidth', 2)
xlabel('Measurement')
ylabel('Velocity Error')

% Kalman Gains
figure(3)
subplot(2,1,1)
plot(time_m, KG_m(1, :), 'm', 'LineWidth', 2)
xlabel('Measurement')
ylabel('Position Kalman Gain')
title('Kalman Filter Kalman Gain')

subplot(2,1,2)
plot(time_m, KG_m(2, :), 'm', 'LineWidth', 2)
xlabel('Measurement')
ylabel('Velocity Kalman Gain')



