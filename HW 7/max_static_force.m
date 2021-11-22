clear; close all;

%% Initialization
% Moment Arms
r1 = 10;
r2 = 7;
r3 = 8;
r4 = 12;
% Segment Lengths (cm)
l1 = 80;
l2 = 50;
% Moment Arm Matrix
moment_mtx = [-r1 -r1  r2 r2;
              -r3  r4 -r3 r4;];   
% Sigmamax
sigmamax = 35;
% Angles
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
Fx = NaN(1,10); Fy = NaN(1,10);

figure;
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
    tau = moment_mtx * F0;

    % Calculate Endpoint Wrench
    H = inv(J') * tau;

    % Compute Maximal Static Force
    [Y{i}, K{i}] = zonotope_multi_N_2D(H);
    
    % Plot Maximal Static Force Results
    subplot(5, 2, i);
    plot(Y{i}(K{i},1),Y{i}(K{i},2),'r-');
    title(['Posture ' num2str(i)]);
end
