clear all; close all; clc;


%% run an edge detection on cropped images and calculate
% structure area.

srcfiles = dir('imagedata/alldata/*cropped_refd.png');
R = zeros(1,length(srcfiles),'uint32');
for i = 1 : length(srcfiles)
    filename = strcat('imagedata/alldata/',srcfiles(i).name);
    X = imread(filename);
    % convert to grayscale
    BW1 = rgb2gray(X);
    % do some fancy edge detection (use the standard one! Canny produces not useful data!)
    BW2 = edge(BW1);
    %plot one image to show the outline border problem
    if i == 1
        imshow(BW2);
    end
    % do some morphological closing to get outlined area
    BW3 = bwmorph(BW2,'close',30);
    % erode the image to get rid of the border we don't want
    BWer = bwmorph(BW1,'erode',1);
    BWermask = BWer.*BW3;
    % close again, just to surely get the max area
    BWermask = bwmorph(BWermask,'close',Inf);
    % now reshape and count pixels
    [r col] = size(BWermask);
    BW_resh =reshape(BWermask,1,r*col);
    cnt = 0;
    figure;
    imshow(BWermask);
    for j=1:length(BW_resh)
        if BW_resh(j) > 0.4
            cnt = cnt +1;
        end
    end
    % write image, obviously
    [pathstr,name,ext] = fileparts(filename);
    imwrite(BWermask,strcat('imagedata/analysis/street',name,ext));
    % append it to a matrix
    R(i) = cnt;
end

% plot the data
figure, plot(R)
