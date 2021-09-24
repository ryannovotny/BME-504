% BME 504 2015
% Chunji Wang & Francisco Valero-Cuevas
%
% Parameter Table:
% Frame A   Alpha   D   Theta
% 1     0  -90      0   q1 + 90
% 2     a2  0       0   q2
% 3    -a3  90      0   q3 + 90
% 4     0  -90      d4  q4
% 5     0   90      0   q5
% 6     0   0       d6  0
%
%%% Note: All q takes value of 0 at the posture given by the picture.
%
%%% Note: The coordinates given in the problem doesn't entirely fit D-H
%%% convention. From frame 1 to 0, there's an extra parameter d2. Other
%%% transitions fit D-H convention.
%
%%% Note: Frame 6 has no free parameter, it's a dummy frame.
% syms q1 q2 q3 q4 q5 a2 d2 a3 d4 d6
% A1 = [ cos(q1+pi/2) 0 -sin(q1+pi/2) -d2*cos(q1);
%        sin(q1+pi/2) 0 cos(q1+pi/2)  -d2*sin(q1);
%        0           -1 0              0;
%        0            0 0              1 ];
% 
% A2 = [ cos(q2) -sin(q2) 0 a2*cos(q2) ;
%        sin(q2) cos(q2)  0 a2*sin(q2) ;
%        0       0        1 0 ;
%        0       0        0 1 ] ;
% A3 = [ cos(q3+pi/2) 0 sin(q3+pi/2)  -a3*cos(q3+pi/2);
%        sin(q3+pi/2) 0 -cos(q3+pi/2) -a3*sin(q3+pi/2);
%        0            1 0             0;
%        0            0 0             1 ];
% A4 = [ cos(q4) 0 -sin(q4) 0;
%        sin(q4) 0 cos(q4)  0;
%        0      -1 0        d4;
%        0       0 0        1 ];
% A5 = [ cos(q5) 0 sin(q5)  0 ;
%        sin(q5) 0 -cos(q5) 0 ;
%        0       1 0        0 ;
%        0       0 0        1 ] ;
% A6 = [ 1 0 0 0 ;
%        0 1 0 0 ;
%        0 0 1 d6 ;
%        0 0 0 1 ];

syms q1 q2 q3 q4 a1 a2

A1 = [cos(q1) -sin(q1) 0 0
      sin(q1) cos(q1) 0 0
      0 0 1 0
      0 0 0 1];
  
A2 = [cos(q2) 0 sin(q2) 0
      0 1 0 0
      -sin(q2) 0 cos(q2) 0
      0 0 0 1];
  
A3 = [1 0 0 0
      0 1 0 0
      0 0 1 a1
      0 0 0 1];
  
A4 = [cos(q3) 0 -sin(q3) 0
      0 1 0 0
      sin(q3) 0 -cos(q3) 0
      0 0 0 1];
  
A5 = [1 0 0 0
      0 1 0 0
      0 0 1 a2
      0 0 0 1];

T0_1 = A1;
T0_2 = A1 * A2;
T0_3 = T0_2 * A3;
T0_4 = T0_3 * A4;
T0_5 = T0_4 * A5;
%T0_6 = T0_5 * A6;

%simplify the whole matrix and only the geometric model
% r = simplify(T0_6);
% g = simplify(T0_6(1:3,4));
% J = jacobian(g,[q1 q2 q3 q4 q5]); %%% this calculated the Jacobian
r = simplify(T0_5);
g = simplify(T0_5(1:3,4));
J = jacobian(g,[q1 q2 q3]); %%% this calculated the Jacobian

% This is how you evaluate it for a posture
% q1 = pi/4; q2 = 0; q3 = 0; q4 = 0; q5 = 0; %define numerical values for your variables
% 
% subs(simplify(r)) %evaluate r
% subs(simplify(J)) %evaluate J