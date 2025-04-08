clear all; clc;

r = 1;                        % radius of the plate
theta = linspace(0, 2*pi, 100);  % angle from 0 to 2π
x = r * cos(theta)+10;          % x coordinates
y = r * sin(theta)+5;          % y coordinates

hd = fill(x, y, 'b');             % fill the circle with blue color
set(hd, 'faceColor', [252 141 98]/255, 'faceAlpha', 0.3, 'EdgeColor', 'None');
axis equal;
title('2D Round Plate');
xlabel('x'); ylabel('y');
