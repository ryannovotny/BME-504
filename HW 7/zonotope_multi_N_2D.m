%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% NEUROMECHANICS %%%%%%%%%%%%%
% (c) Francisco Valero-Cuevas
% October 2013, version 1.0
% November 2021, version 1.1 - RN - Update for Homework 7
% Filename: zonotope_muti_N.m

% This script shows how to map N-dimensional N-cubes into 2D and 3D via a
% random H matrix of dimensions 2 x N and 3 x N, respectively.
%
% It then plots the convex hulls of the zonotopes when considering 
% the input to be between 3 and 8 dimensions. That is, a system having 3 to
% 8 muscles

function [Y, K] = zonotope_multi_N_2D(H)
    % Iterate to calculate the zonotopes for inout dimensions from 3 to 8
    for n = 4 % n us the number if muscles, from 3 to 8 in this example
        % use my function ncube to obtain the vertices. Use 'help ncube' for
        % details. X is the matrix of all vertices of the n-cube
        [X, count] = ncube(n);
        H2 = H(1:2,1:n); %select the 2D output with n muscles

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 2D case
        % multiply each vertex by the matrix H
        Y = [];
        for i = 1:count
            Y = [Y;(H2*X(i,:)')'];
        end

        % Find the convex hull
        K = convhull(Y);
    end
end

