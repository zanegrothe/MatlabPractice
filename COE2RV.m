%{
Zane Grothe
3/4/24

Converting orbital elements into position(r) and velocity(v) in 3
dimensions.
First, convert scalar elements to perifocal coordinate system (P, Q, W)
Second, rotate to inertial reference frame (I, J, K)
%}

function [rf, vf] = COE2RV(~,mu,p,ec,nu,w,in,O)

r = p / (1 + ec*cos(nu));  % r scalar

% r and v vectors in perifocal coordinate system
rPQW = r*[          cos(nu);                 sin(nu); 0];
vPQW = [-sqrt(mu/p)*sin(nu); sqrt(mu/p)*(ec+cos(nu)); 0];

% Rotational matrices for inertial reference frame
% ROT 1 (w)
Rw  = [cos(w), sin(w), 0;
      -sin(w), cos(w), 0;
            0,      0, 1];
% ROT 2 (in)
if in < pi
    Rin = [1,        0,       0;
           0,  cos(in), sin(in);
           0, -sin(in), cos(in)];
else
    Rin = [1,       0,        0;
           0, cos(in), -sin(in);
           0, sin(in),  cos(in)];
end
% ROT 3 (O)
RO  = [cos(O), sin(O), 0;
      -sin(O), cos(O), 0;
            0,      0, 1];

A = Rw*Rin*RO; % Combined into one rotational matrix

% Rotated
rIJK = A.'*rPQW;
rf = rIJK;

vIJK = A.'*vPQW;
vf = vIJK;

