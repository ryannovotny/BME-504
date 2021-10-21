clear; close all;

%% Initialization
% Moment Arms
r1 = 10;
r2 = 7;
r3 = 8;
r4 = 12;
% Angles
q1 = 0:90;
q2 = 0:180;
% Segment Lengths (cm)
l1 = 80;
l2 = 50;
% Optimal Muscle Lengths (cm)
m1_len = 20;
m2_len = 10;
m3_len = 20;
m4_len = 15;

%% Preliminary: Generate Workspace
% Create All Possible Vector Combinations
[Q1,Q2] = meshgrid(q1, q2);
% Restructure to Single Matrix
temp = cat(2, Q1', Q2');
% Reshape to Two Column Matrix Defined in Workspace
workspace = reshape(temp, [], 2) * (pi/180);

% Compute Positions
x = l1 * cos(workspace(:,1)) + l2 * cos(workspace(:,2) + workspace(:,1));
y = l1 * sin(workspace(:,1)) + l2 * sin(workspace(:,2) + workspace(:,1));

% Set Reference Frame
workspace(:,1) = workspace(:,1) - deg2rad(45);
workspace(:,2) = workspace(:,2) - deg2rad(90);

%% Problem 1: Generate Normalized Maximal Isometric Static Forces
% Create Moment Arm Matrix
moment_mtx = [-r1 -r1  r2 r2;
              -r3  r4 -r3 r4;];

% Calculate Muscle Excursions
exc_1 = (-moment_mtx(:,1)' * workspace')';
exc_2 = (-moment_mtx(:,2)' * workspace')';
exc_3 = (-moment_mtx(:,3)' * workspace')';
exc_4 = (-moment_mtx(:,4)' * workspace')';

% Calculate Slack Length
m1_x = (exc_1 / m1_len);
m2_x = (exc_2 / m2_len);
m3_x = (exc_3 / m3_len);
m4_x = (exc_4 / m4_len);

% Calculate Maximal Force
m1_force = arrayfun(@(x) max_force(x), m1_x);
m2_force = arrayfun(@(x) max_force(x), m2_x);
m3_force = arrayfun(@(x) max_force(x), m3_x);
m4_force = arrayfun(@(x) max_force(x), m4_x);

% Plot Results
figure;
subplot(2,2,1);
plot3(x, y, m1_force, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 1 Max Force');
subplot(2,2,2);
plot3(x, y, m2_force, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 2 Max Force');
subplot(2,2,3);
plot3(x, y, m3_force, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 3 Max Force');
subplot(2,2,4);
plot3(x, y, m4_force, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 4 Max Force');

%% Problem 2: Calculate Optimal Muscle Activations / Coordination Pattern
clear x y
% Sigmamax
sigmamax = 35;
% Pennation Angle
penn_ang = 0;
% Update Angles
q = [1.1908 1.83641;
     1.0621 1.87549;
     0.813389 1.87549;
     0.700844 1.83641;
     0.601398 1.77215;
     0.518223 1.68353;
     0.453598 1.5708;
     0.409172 1.43286;
     0.386661 1.2661;
     0.389248 1.06157];
% Preallocate Matrices and Vectors
max_a = NaN(4, 10);
x_elb = NaN(1,10); y_elb = NaN(1,10);
x = NaN(1,10); y = NaN(1,10);
F = NaN(1,10);

post_plot = figure;
hold on;
for i = 1:length(q)
    % Compute Elbow Location
    x_elb(:,i) = l1 * cos(q(i,1));
    y_elb(:,i) = l1 * sin(q(i,1));
    
    % Compute Endpoint Location
    x(:,i) = l1 * cos(q(i,1)) + l2 * cos(q(i,2) + q(i,1));
    y(:,i) = l1 * sin(q(i,1)) + l2 * sin(q(i,2) + q(i,1));
    
    % Jacobian Matrix
    J = [((-l1 * sin(q(i,1))) - (l2 * sin(q(i,1) + q(i,2)))) (-l2 * sin(q(i,1) + q(i,2)));
         ((l1 * cos(q(i,1))) + (l2 * cos(q(i,1) + q(i,2)))) (l2 * cos(q(i,1) + q(i,2)))];

    % Calculate Maximal Force
    F0 = [(10 * sigmamax) 0 0 0;
          0 (20 * sigmamax) 0 0;
          0 0 (15 * sigmamax) 0;
          0 0 0 (25 * sigmamax);];

    % Calculate Joint Torques
    RF0 = moment_mtx * F0;

    % Calculate Endpoint Wrench
    H = inv(J') * RF0;

    % Create Constraint Equations
    hT1 = H(1,:);
    hT2 = H(2,:);

    % Create H Matrix and B Vector Constraints
    A = [hT1; -hT1; eye(4); -eye(4)];
    b = [0.001; 0.001; 1; 1; 1; 1; 0; 0; 0; 0];

    % Find Optimal Activations
    max_a(:,i) = linprog(-hT2, A, b);
    
    % Compute Force
    F(i) = H(2,:) * max_a(:,1);
    
    % Plot Limb Configurations
    plot([0 x_elb(i)], [0 y_elb(i)], [x_elb(i) x(i)], [y_elb(i) y(i)]);
end
hold off;
xlabel('X (m)');
ylabel('Y (m)');
title('Limb Configurations');

% Plot Activations
act_plot = figure;
subplot(2,5,1); bar(max_a(:,1));
subplot(2,5,2); bar(max_a(:,2));
subplot(2,5,3); bar(max_a(:,3));
subplot(2,5,4); bar(max_a(:,4));
subplot(2,5,5); bar(max_a(:,5));
subplot(2,5,6); bar(max_a(:,6));
subplot(2,5,7); bar(max_a(:,7));
subplot(2,5,8); bar(max_a(:,8));
subplot(2,5,9); bar(max_a(:,9));
subplot(2,5,10); bar(max_a(:,10));
act_han = axes(act_plot,'visible','off'); 
act_han.Title.Visible = 'on';
act_han.XLabel.Visible = 'on';
act_han.YLabel.Visible = 'on';
ylabel(act_han, 'Activation');
xlabel(act_han, 'Muscles');
title(act_han, 'Muscle Activations for All Postures');

% Plot Force for Each Configurations
figure;
plot(F);
xlabel('Posture');
ylabel('Force Magnitude');
title('Force Magnitude for Each Posture');

%% Max Force Function
function f_max = max_force(m_x)
    % Shape Parameter
    w = 0.5;
    
    % Calculate Max Force
    if(m_x <= -0.5 || m_x >= 0.5)
        f_max = 0;
    else
        f_max = 1 - (m_x / w)^2;
    end
end