function [pos,tim] = damped_harmonic_oscillator_1D(nnt,c)
% nnt :     Number of time steps
% c   :     damping coefficient

if (nargin < 2)
    c = 5e-13;
end

% Initialise parameters
v0 = 0;                     % Initial velocity
x0 = 235e-12;               % Initial position
k = 1100;                   % Spring constant
M = 1.6726E-27;             % Mass of hydrogen atom

t_end = 3 * 2 * pi* 1/sqrt(k/M);    % 3 complete periods
deltat = t_end/nnt;                 % Time step

pos = zeros(nnt,1);      % Position vector
vel = zeros(nnt,1);      % Velocity vector
tim = zeros(nnt,1);      % Time vector

pos(1) = x0;             % Store initial position
vel(1) = v0;             % Store initial velocity

% The time loop
for n = 1:nnt-1
    pos(n+1) = position(pos(n),vel(n),deltat);
    newForce = spring_force(k,pos(n)) + damping_force(c,vel(n));
    vel(n+1) = velocity(vel(n),newForce,M,deltat);
    tim(n+1) = tim(n) + deltat;
end

% Plot results
figure; plot(tim,pos, 'o');

% Compare to analytical solution
compareToExact(x0,M,k,c,tim,pos);

end

function F = spring_force(k,pos)
% M:    mass of particle
F = - k * pos;
end


function F = damping_force(c,vel)
% M:    mass of particle
F = -c * vel;
end

function v = velocity(vt,F,M,dt)
% vt:   velocity at previous time
% mass: mass of particle
% dt:   time step size
v = vt + F/M * dt;
end

function x = position(xt,vel,dt)
% xt:   position at current time step
% vel:  velocity at current time step
% dt:   time step size
x = xt + vel * dt;
end

function compareToExact(x0,M,k,c,tim,pos)
omega = sqrt(k/M);
zeta = c / (2 * sqrt(M*k));
omega = sqrt(k/M);
alpha = omega * zeta;
gamma = omega * sqrt (1 - zeta*zeta);

% Exact solution
pos_ex = x0*exp(-alpha * tim) .* ((alpha / gamma) * sin(gamma * tim) + cos (gamma * tim));

% Draw comparative figure
figure;
subplot(2,1,1)
plot(tim,pos, 'o');
hold on;
plot(tim,pos_ex,'r-')
subplot(2,1,2)
stem(tim,pos_ex-pos,'r-')

disp 'The norm of error is: '
norm(pos_ex-pos)
end
