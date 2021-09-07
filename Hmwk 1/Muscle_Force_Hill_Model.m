%% Initialization
clear; close all;
pulse_count = 2;    % Number of Pulses
force_init = 0;     % Initial Force
k = 33;             % Stiffness
b = 10;             % Damping

% Generate Pulse
pulse = [ones(16,1); zeros(9,1)];
% Generate Full Pulse Signal
signal = repmat(pulse, [pulse_count, 1]);
% Generate Force Array
force = NaN(length(signal), 1);
%options = odeset('MaxStep', 0.001);

%% Force Calculation
for signal_idx = 1:pulse_count
    [t, y] = ode45(@(t, y) hill_type(t, y, k, b), [1:0.01:length(signal)], 0); %, options);
end

% Plot Results
plot(t,y);

%% Hill-Type Model Equation
function f_dot = hill_type(f0, F, k, b)
    f_dot = ((k/b) * f0) - ((k/b) * F);
end

%% Iterate Through Each Time Point
% for t_idx = 1:length(signal)
%     if(signal(t_idx) == 1)
%         [x,force(t_idx)] = ode45(@hill_type, [0 16], 0, k, b, F, init, t_idx, signal);
%     elseif(signal(t_idx) == 0)
%         [x,force(t_idx)] = ode45(@hill_type, [0 9], 0, k, b, F, init, t_idx, signal);
%     end
% end