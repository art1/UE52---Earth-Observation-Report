clear all; close all; clc;
% This


%% crop images to only contain ROI (experimentally determind
 roi = [   2350    220    3200    3000];
 srcfiles = dir('imagedata/alldata/*.png');
 for i = 1 : length(srcfiles)
   filename = strcat('imagedata/alldata/',srcfiles(i).name);
   I = imread(filename);
   I2 = imcrop(I,roi);
   [pathstr,name,ext] = fileparts(filename);
   imwrite(I2,strcat('imagedata/alldata/',name,'cropped',ext));
end

%% equalize historgram for the images
srcfiles = dir('imagedata/alldata/*cropped.png');
% use 1992 as reference image
ref = imread('imagedata/alldata/1992cropped.png');
for i = 1 : length(srcfiles)
  filename = strcat('imagedata/alldata/',srcfiles(i).name);
  I = imread(filename);
  I2 = imhistmatch(I,ref);
  % mask the image with the original image again
  mask = rgb2gray(I);
  mask = (mask > 0.001);
  mask(:,:,2) = mask;
  mask(:,:,3) = mask(:,:,1);
  I2 = immultiply(mask,I2);
  [pathstr,name,ext] = fileparts(filename);
  imwrite(I2,strcat('imagedata/alldata/',name,'_refd',ext));
end
