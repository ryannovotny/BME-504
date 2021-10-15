%% Initialization
% Moment Arms
r1 = 10;
r2 = 7;
r3 = 8;
r4 = 12;
% Angles
q1 = 0:90;
q2 = 0:180;
% Segment Lengths
l1 = 3;
l2 = 2;

%% Preliminary: Generate Workspace
% Create All Possible Vector Combinations
[Q1,Q2] = meshgrid(q1, q2);
% Restructure to Single Matrix
temp = cat(2,Q1',Q2');
% Reshape to Two Column Matrix Defined in Workspace
workspace = reshape(temp,[],2) * (pi/180);

% Compute Positions
x = l1 * cos(workspace(:,1)) + l2 * cos(workspace(:,2) + workspace(:,1));
y = l1 * sin(workspace(:,1)) + l2 * sin(workspace(:,2) + workspace(:,1));

% Plot Feasible Workspace
plot(x, y, '.');
title('Feasible Limb Workspace');
xlabel('Position (cm)');
ylabel('Position (cm)');

%% 1.2: Muscle Excursions
% Generate Moment Arm Matrix
moment_mtx = [-r1 -r1  r2 r2;
              -r3  r4 -r3 r4;];

% Calculate Muscle Excursions
exc_1 = (-moment_mtx(:,1)' * workspace')';
exc_2 = (-moment_mtx(:,2)' * workspace')';
exc_3 = (-moment_mtx(:,3)' * workspace')';
exc_4 = (-moment_mtx(:,4)' * workspace')';

% Plot Muscle Excursions
figure; plot3(x, y, exc_1);
title('Muscle 1 Excursions');
xlabel('X Position (cm)');
ylabel('Y Position (cm)');
zlabel('Excursion');

figure; plot3(x, y, exc_2);
title('Muscle 2 Excursions');
xlabel('X Position (cm)');
ylabel('Y Position (cm)');
zlabel('Excursion');

figure; plot3(x, y, exc_3);
title('Muscle 3 Excursions');
xlabel('X Position (cm)');
ylabel('Y Position (cm)');
zlabel('Excursion');

figure; plot3(x, y, exc_4);
title('Muscle 4 Excursions');
xlabel('X Position (cm)');
ylabel('Y Position (cm)');
zlabel('Excursion');