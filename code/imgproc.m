clear all; close all; clc;

% in = imread('imagedata/L4-5TM/dubaimask_L45TM.png');
% maskL45TM(:,:,1) = rgb2gray(in);
% maskL45TM(:,:,2) = maskL45TM(:,:,1);
% maskL45TM(:,:,3) = maskL45TM(:,:,1);
%roi = [   2350    220    3200    3000];


%% run an edge detection on cropped images and calculate
% structure area.

% reference image for the histogram
%ref = imread('imagedata/alldata/1992cropped.png');
srcfiles = dir('imagedata/alldata/*cropped_refd.png');
R = zeros(1,length(srcfiles),'uint32');
for i = 1 : length(srcfiles)
    filename = strcat('imagedata/alldata/',srcfiles(i).name);
    X = imread(filename);
    %X2 = imhistmatch(X,ref);
    BW1 = rgb2gray(X);
    BW2 = edge(BW1);
    BW3 = bwmorph(BW2,'close',30);
    BWer = bwmorph(BW1,'erode',10);
    BWermask = BWer.*BW3;
    BWermask = bwmorph(BWermask,'close',Inf);
    % now reshape and count pixels
    [r col] = size(BWermask);
    BW_resh =reshape(BWermask,1,r*col);
    cnt = 0;
    figure;
    subplot(1,2,1),imshow(BWermask);
    %subplot(1,2,2), imshow(X2);
    for j=1:length(BW_resh)
        if BW_resh(j) > 0.4
            cnt = cnt +1;
        end
    end
    % append it to a matrix
    R(i) = cnt;
end

figure, plot(R)

% BW1 = rgb2gray(X);
% BW2 = edge(BW1);
% imshow(BW1)
% figure, imshow(BW2)
% BW3 = bwmorph(BW2,'close',30);
% figure, imshow(BW3);
% % subtract edges from image
% BWer = bwmorph(BW1,'erode',10);
% BWermask = BWer.*BW3;
% figure, imshow(BWermask)
% figure, imshow(bwmorph(BWermask,'close',Inf))



% cform = makecform('srgb2lab');
% lab_he = applycform(X,cform);
% 
% ab = double(lab_he(:,:,2:3));
% nrows = size(ab,1);
% ncols = size(ab,2);
% ab = reshape(ab,nrows*ncols,2);
% 
% nColors = 2;
% % repeat the clustering 3 times to avoid local minima
% [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',3);
% 
% pixel_labels = reshape(cluster_idx,nrows,ncols);
% %figure, imshow(pixel_labels,[]), title('image labeled by cluster index');
% 
% segmented_images = cell(1,2);
% rgb_label = repmat(pixel_labels,[1 1 2]);
% 
% for k = 1:nColors
%     color = X;
%     color(rgb_label ~= k) = 0;
%     segmented_images{k} = color;
% end
% 
% figure,
% subplot(1,2,1), imshow(segmented_images{1})
% subplot(1,2,2), imshow(segmented_images{2})