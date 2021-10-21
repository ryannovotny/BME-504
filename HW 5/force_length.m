%% Initialization
% Moment Arms
r1 = 10;
r2 = 7;
r3 = 8;
r4 = 12;
% Angles
q1 = 0:90;
q2 = 0:180;
% Segment Lengths (m)
l1 = 0.8;
l2 = 0.5;
% Optimal Muscle Lengths (cm)
m1_opt = 20;
m2_opt = 10;
m3_opt = 20;
m4_opt = 15;

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
m1_x = (exc_1 / m1_opt);
m2_x = (exc_2 / m2_opt);
m3_x = (exc_3 / m3_opt);
m4_x = (exc_4 / m4_opt);

% Calculate Maximal Force
m1_max = arrayfun(@(x) max_force(x), m1_x);
m2_max = arrayfun(@(x) max_force(x), m2_x);
m3_max = arrayfun(@(x) max_force(x), m3_x);
m4_max = arrayfun(@(x) max_force(x), m4_x);

% Plot Results
figure;
subplot(2,2,1);
plot3(x, y, m1_max, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 1 Max Force');
subplot(2,2,2);
plot3(x, y, m2_max, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 2 Max Force');
subplot(2,2,3);
plot3(x, y, m3_max, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 3 Max Force');
subplot(2,2,4);
plot3(x, y, m4_max, '.'); xlabel('X (m)'); ylabel('Y (m)'); title('Muscle Normalized 4 Max Force');

%% Problem 2:
% Sigmamax
sigmamax = 35;
% Pennation Angle
penn_ang = 0;
% Update Angles
q1 = 1.0621;
q2 = 1.87549;

%q1 = deg2rad(45);
%q2 = deg2rad(90);

% Jacobian Matrix
J = [((-l1 * sin(q1)) - (l2 * sin(q1 + q2))) (-l2 * sin(q1 + q2));
     ((l1 * cos(q1)) + (l2 * cos(q1 + q2))) (l2 * cos(q1 + q2))];

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
Max_a = linprog(-hT2, A, b);

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