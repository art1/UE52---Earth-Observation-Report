clear all; close all; clc;

% this file runs a kNN algorithm using pre-set classes (manually done)

srcfiles = dir('imagedata/alldata/*cropped_refd.png');

R = zeros(1,length(srcfiles),'uint32');
for i = 1 : length(srcfiles)
    filename = strcat('imagedata/alldata/',srcfiles(i).name);
    I = imread(filename);
    X = I;
    % supervised classification using kNN algorithm
    [U,V,d] = size(I) ;
    I = double(I) ;
    DataBase = [ 32 49 57 1 ;
        32 49 61 1 ;
        36 53 61 1 ;
        32 51 61 1 ;
        36 53 57 1 ;
        45 61 69 1 ;
        40 57 65 1 ;
        32 45 57 1 ;
        36 49 61 1 ;
        32 49 57 1 ;
        178 162 146 2;
        182 166 154 2;
        178 162 159 2;
        182 162 146 2;
        121 154 85 3;
        142 162 101 3;
        125 158 93 3;
        125 150 98 3;] ;


    NbData = size(DataBase, 1) ;

    Pixels = DataBase(:,1:3) ;

    Classes = DataBase(:,4) ;

    MaskClasses = zeros(U,V) ;

    for u = 1 : U
        for v = 1 : V

            r = I(u,v,1) ;
            g = I(u,v,2) ;
            b = I(u,v,3) ;

            TabRGB = repmat([r g b],NbData,1) ;
            D2 = (TabRGB - Pixels).^2 ;
            % minimise distance
            [valmin,posmin] = min( sum(D2') ) ;
            MaskClasses(u,v) = Classes(posmin) ;


        end
    end
    % plot the water classe, for this report the others aren't used.
    show = (MaskClasses==1);
    bordermask = bwmorph(rgb2gray(I),'erode',1);
    show = show .* bordermask;
    show(:,:,2) = show;
    show(:,:,3) = show(:,:,1);
    waterMasked = show.*I;
    figure,
    subplot(1,2,1),imshow(X)
    subplot(1,2,2),imshow(show.*I)
    [pathstr,name,ext] = fileparts(filename);
    imwrite(show.*I,strcat('imagedata/analysis/water',name,'_w',ext));

    % now reshape and count pixels
    [r col] = size(waterMasked);
    BW_resh =reshape(waterMasked,1,r*col);
    cnt = 0;
    %figure;
    %subplot(1,2,1),imshow(BWermask);
    %subplot(1,2,2), imshow(X2);
    for j=1:length(BW_resh)
        if BW_resh(j) > 0.4
            cnt = cnt +1;
        end
    end
    % append it to a matrix
    R(i) = cnt;
end

plot(R)
