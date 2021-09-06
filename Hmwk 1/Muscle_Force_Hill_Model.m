%% Initialization
pulse_count = 2;    % Number of Pulses
force_init = 0;     % Initial Force
k = 1;              % Stiffness
b = 1;              % Damping

% Generate One Pulse
pulse = [ones(16,1); zeros(9,1)];
% Generate Full Pulse Signal
signal = repmat(pulse, [pulse_count, 1]);
% Generate Force Array
force = NaN(length(signal), 1);

%% Force Calculation
% Iterate Through Each Time Point
for t_idx = 1:length(signal)
    if(signal(t_idx) == 1)
        force(t_idx) = ;
    elseif(signal(t_idx) == 0)
        force(t_idx) = ;
    end
end

