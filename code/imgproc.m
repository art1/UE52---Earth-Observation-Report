clear all; close all; clc;

in = imread('imagedata/L4-5TM/dubaimask_L45TM.png');
maskL45TM(:,:,1) = rgb2gray(in);
maskL45TM(:,:,2) = maskL45TM(:,:,1);
maskL45TM(:,:,3) = maskL45TM(:,:,1);
X = imread('imagedata/L4-5TM/LT41600431988027XXX03.png','png');


cform = makecform('srgb2lab');
lab_he = applycform(X,cform);

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',3);

pixel_labels = reshape(cluster_idx,nrows,ncols);
%figure, imshow(pixel_labels,[]), title('image labeled by cluster index');

segmented_images = cell(1,2);
rgb_label = repmat(pixel_labels,[1 1 2]);

for k = 1:nColors
    color = X;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

figure,
subplot(1,2,1), imshow(segmented_images{1})
subplot(1,2,2), imshow(segmented_images{2})