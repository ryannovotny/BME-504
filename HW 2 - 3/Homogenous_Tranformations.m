%% Problem 1
%
% Define Symbols
%   Angles: Theta, Alpha
%   Lengths: L, S
syms theta alpha L S

% Frame T0_1: Rotate About Z Axis
A1 = [cos(theta) -sin(theta) 0 0;
      sin(theta)  cos(theta) 0 0;
      0           0          1 0;
      0           0          0 1];

% Frame T1_2: Rotate Alpha About Y Axis
A2 = [cos(alpha) 0 sin(alpha) 0;
      0          1 0          0;
     -sin(alpha) 0 cos(alpha) 0;
      0          0 0          1];
  
% Frame T2_3: Translate Up Length of Boom (L) About Z Axis
A3 = [1 0 0 0;
      0 1 0 0;
      0 0 1 L;
      0 0 0 1];
  
% Frame T3_4: Rotate -Alpha About Y Axis
A4 = [cos(alpha) 0 -sin(alpha) 0;
      0          1  0          0;
      sin(alpha) 0  cos(alpha) 0;
      0          0  0          1];

% Frame T4_5: Translate Down Length of Cable (S) About Z Axis
A5 = [1 0 0  0;
      0 1 0  0;
      0 0 1 -S;
      0 0 0  1];

% Multiple All Frame Together
T0_1 = A1;
T0_2 = A1 * A2;
T0_3 = T0_2 * A3;
T0_4 = T0_3 * A4;
T0_5 = T0_4 * A5;

% Simplify Entire Matrix
r = simplify(T0_5);

% Simplify Only Geometric Model
g = simplify(T0_5(1:3,4));

% Generate Jacobian Matrix
J = jacobian(g,[theta, alpha]);

%% Problem 2
syms th1 th2 th3 th4 th5 d2 d4 d6 a2 a3 pi

%%% First Transformation
% Rotate About Z-Axis
A1 = [cos(th1) -sin(th1) 0 0;
      sin(th1) cos(th1) 0 0;
      0 0 1 0;
      0 0 0 1];

% Translate by -d2 Along X-Axis
A2 = [1 0 0 -d2;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];
  
% Rotate About X-Axis - 90 w/ RHR
A3 = [1 0 0 0;
      0 cos(-pi/2) -sin(-pi/2) 0; 
      0 sin(-pi/2) cos(-pi/2) 0;
      0 0 0 1];
	  
% Rotate About Y-Axis
A4 = [cos(-pi/2) 0 sin(-pi/2) 0;
      0 1 0 0;
      -sin(-pi/2) 0 cos(-pi/2) 0;
      0 0 0 1];
  
%%% Second Transformation
% Rotate About Z-Axis
A5 = [cos(th2) -sin(th2) 0 0;
      sin(th2) cos(th2) 0 0;
      0 0 1 0;
      0 0 0 1];
  
% Translate by a2 Along X-Axis
A6 = [1 0 0 a2;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];
  
%%% Third Transformation
% Rotate About Z-Axis
A7 = [cos(th3) -sin(th3) 0 0;
      sin(th3) cos(th3) 0 0;
      0 0 1 0;
      0 0 0 1];

% Rotate About X-Axis
A8 = [1 0 0 0;
      0 cos(pi/2) -sin(pi/2) 0;
      0 sin(pi/2) cos(pi/2) 0;
      0 0 0 1];

% Translate by a3 Along X-Axis
A9 = [1 0 0 a3;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];
  
%%% Fourth Transformation
% Rotate About Z-Axis
A10 = [cos(th4) -sin(th4) 0 0;
       sin(th4) cos(th4) 0 0;
       0 0 1 0;
       0 0 0 1];

% Rotate About X-Axis
A11 = [1 0 0 0;
       0 cos(pi/2) -sin(pi/2) 0;
       0 sin(pi/2) cos(pi/2) 0;
       0 0 0 1];

% Translate by d4 Along X-Axis
A12 = [1 0 0 d4;
       0 1 0 0;
       0 0 1 0;
       0 0 0 1];
   
%%% Fifth Transformation
% Rotate About Z-Axis
A13 = [cos(th5) -sin(th5) 0 0;
       sin(th5) cos(th5) 0 0;
       0 0 1 0;
       0 0 0 1];

% Rotate About X-Axis
A14 = [1 0 0 0;
       0 cos(pi/2) -sin(pi/2) 0; 
       0 sin(pi/2) cos(pi/2) 0;
       0 0 0 1];

%%% Dummy Frame
A15 = [1 0 0 0;
       0 1 0 0;
       0 0 1 d6;
       0 0 0 1];
  
T1_0 = A1 * A2 * A3 * A4;
T2_0 = T1_0 * A5 * A6;
T3_0 = T2_0 * A7 * A8 * A9;
T4_0 = T3_0 * A10 * A11 * A12;
T5_0 = T4_0 * A13 * A14 * A15;

% Simplify Entire Matrix
r = simplify(T5_0);

% Simplify Only Geometric Model
g = simplify(T5_0(1:3,4));

% Generate Jacobian Matrix
J = jacobian(g,[th1 th2 th3 th4 th5]);