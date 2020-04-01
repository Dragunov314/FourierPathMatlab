close all;
clear all;

data1 = read_SVG_polyline('mysignature.svg'); % Normalized data
% data2 = read_SVG_polyline('mysignature2.svg'); % Normalized data

circle_count = 100;
start_frame = 0;
K = size(data1,2);

fr_path_obj1 = fourierPath(data1, circle_count, start_frame, K);

% fr_path_obj2 = fourierPath(data2, circle_count, start_frame, K);

% Apply Histogram similarity
% h1 = abs(fr_path_obj1.rads);
% h2 = abs(fr_path_obj2.rads);
% sim1 = sum(min([h1;h2]))/sum(h1)
% sim2 = sum(min([h1;h2]))/sum(h2)

frames = K;% size(data, 2);
fr_path_obj1.run_animation(frames);

movie(fr_path_obj1.animation,20,30); % movie(M,n,fps)