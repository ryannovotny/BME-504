clc; clear; close all;

% Generate Force Profiles with Varying Pulses
force_profile(2, 9);
force_profile(3, 9);
force_profile(7, 9);

% Generate Force Profiles with Varying Time Between Pulses
force_profile(3, 5);
force_profile(3, 14);

function force_profile(p_cnt, p_int)
    % This function determines the force profile for a simple Hill-type model of muscle by generating a square
    % activation signal and utilizing the Hill Muscle Model differential equations.
    %
    % Input:    p_cnt: The number of pulses to occur within the activation signal.
    %           p-int: The number of time in ms between each activation pulse.
    
    % Initialization
    p_len = 16;     % Duration of Pulse
    p_tot = p_len + p_int;      % Total Duration of Pulse
    sig_len = p_tot * p_cnt;    % Total Duration of Signal
    k = 1;          % Stiffness
    b = 0.03;       % Damping
    kb = k / b;     % Coefficient

    % Generate Time Series in MS
    time = 0:0.0001:sig_len/1000;
    % Generate Activation Signal
    f0 = square(2 * pi * (1000 / p_tot) * time, p_len * 100 / p_tot);
    % Set Negatives to 0 Value
    f0(f0 < 0) = 0;
    
    % Force Calculation
    [t, y] = ode15s(@hill_type, time, 0, [], [kb, p_tot, p_len]);

    %% Plot Results
    figure; plot(t*1000, y, 'k'); box off;
    hold on;
    plot(time*1000, f0, 'b'); box off;
    legend('ODE15s', 'Activation');
    xlabel('Time (ms)');
    xticks(0:10:max(time)*1000);
    xlim([0 max(time)*1000])
    ylabel('Force (Norm. Units)')
    yticks(0:0.2:1);
    title('Force Profile');
end

function f_dot = hill_type(t, F, var)
    % Takes in a time series and initial condition, along with relative information to create a square activation signal, and
    % returns the muscle activation that occured during the activation signal.
    %
    % Input:    t: Time Series in ms.
    %           F: Initial condition.
    %           var: Vector consisting of three variables
    %               1. k/B Coefficient
    %               2. Total Duration of Pulse
    %               3. Duration of Activation Pulse
    %
    % Output:   f_dot: Muscle activation during the pulse signal.
    
    % Generate Activation Signal
    f0 = square(2 * pi * (1000 / var(2)) * t, var(3) * 100 / var(2));
    % Set Negatives to 0 Value
    f0(f0 < 0) = 0;
    % Compute F-Dot for Muscle Force Profile
    f_dot = (var(1) * f0) - (var(1) * F);
end
