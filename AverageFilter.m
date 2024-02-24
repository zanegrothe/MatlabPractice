% https://www.youtube.com/watch?v=HCd-leV8OkU

clear
close all
clc

prevAvg = 0;

dt = 0.2;
t = 0:dt:10;

Nsamples = length(t);

Avgsaved = zeros(Nsamples, 1);
Xmsaved = zeros(Nsamples, 1);

for k=1:Nsamples
    w = 0 + 4*randn;
    xm = 14.4 + w;
    alpha = (k - 1) / k;
    avg = alpha*prevAvg + (1 - alpha)*xm;
    prevAvg = avg;
    Avgsaved(k) = avg;
    Xmsaved(k) = xm;
    % k = k + 1;
end

figure
plot(t, Xmsaved, 'r:*')
hold on
grid on
plot(t, Avgsaved, 'o-')
