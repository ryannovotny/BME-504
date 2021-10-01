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

% This is how you evaluate it for a posture
% q1 = pi/4; q2 = 0; q3 = 0; q4 = 0; q5 = 0; %define numerical values for your variables
% 
% subs(simplify(r)) %evaluate r
% subs(simplify(J)) %evaluate J