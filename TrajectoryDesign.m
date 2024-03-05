%{
Zane Grothe
2/28/22

Implement a function COE2RV to convert from Keplerian orbit elements to
position and velocity vector in planet centered inertial coordinates.
%}

clear
close all
clc

%% Covert Orbital Elements to Position and Velocity
ec = 0.000582;  % Eccentricity [e]
%{
    e = 0  for circular orbits
0 < e < 1  for elliptic orbits
    e = 1  for parabolic trajectories
    e > 1  for hyperbolic trajectories
%}

% Semi-Major Axis or Periapsis (km) [a]
SP = 414;  % (km)
if ec == 1
    r_para = SP;  % Periapsis for a parabolic trajectory (km)
else
    a = SP;  % Semi-major axis (km)
end
in = 51.641;  % Inclination (deg) [i]  (0 <= in <= 360)
O = 113.352;  % Right Ascention of the Ascending Node (RAAN) (deg) [OMEGA]  (0 <= in <= 360)
w = 325.6402;  % Argument of periapsis (deg) [omega]  (0 <= in <= 360)
nu = 0;  % True anomaly (deg) [nu]  (0 <= in <= 360)

mu = 398600;  % Gravitational mass parameter for Earth (km^3/s^2) [mu]

% Convert angles to radians
in = in*pi / 180;
O = O*pi / 180;
w = w*pi / 180;
nu = nu*pi / 180;

% Check if true anomaly is less than asymptote angle
if ec > 1
    if nu > acos(-1 / ec) || nu < -acos(-1 / ec)
        disp('Invalid true anomaly!')
        disp('You have a hyperbolic trajectory (eccentricity is greater than 1)')
        disp('A valid true anomaly for this trajectory must be less than:')
        disp(acos(-1 / ec)*180 / pi)
        disp('and greater than')
        disp(-acos(-1 / ec)*180 / pi)
        return
    end
end

% Parameter (km) and display movement identification
if ec == 0
    p = a*(1 - ec^2);
    shape = 'circular orbit';
elseif 0 < ec && ec < 1
    p = a*(1 - ec^2);
    shape = 'elliptical orbit';
elseif ec == 1
    p = 2*r_para;
    shape = 'parabolic trajectory';
else
    p = a*(ec^2 - 1);
    shape = 'hyperbolic trajectory';
end
fprintf('Position(km) and Velocity(km/s) vectors for your %s:', shape)

% Convert Orbital Elements to r and v
if ec == 1
    [r,v] = COE2RV(r_para, mu, p, ec, nu, w, in, O)
else
    [r,v] = COE2RV(a, mu, p, ec, nu, w, in, O)
end
%{
%% Covert Position and Velocity to Orbital Elements
% If the variable ends in "t" it is temporary
[a,ec,in,O,wt,nut]=RV2COE(r,v,mu);

% Display movement identification
if ec == 0
    disp('Orbital Elements for your circular orbit:')
elseif 0 < ec && ec < 1
    disp('Orbital Elements for your elliptical orbit:')
elseif ec == 1
    disp('Orbital Elements for your parabolic trajectory:')
else
    disp('Orbital Elements for your hyperbolic trajectory:')
end 

a
ec

% Defining arbitrary (originally specified) elements for a circular orbit
if ec == 0
    w = wt + w;
    nu = nut + nu;
end

% Convert angles back to degrees
in = in*180 / pi
O = O*180 / pi
w = w*180 / pi
nu = nu*180 / pi
%}
