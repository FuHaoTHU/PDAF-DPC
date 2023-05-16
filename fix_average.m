clear;
clc;
fname='lab_8160x6144.raw';
width=8160;
height=6144;
raw_im=read_raw16(fname,width,height);

% normalize to 0-1
black_level=64;
white_level=1023;
raw_im=(raw_im-black_level)/(white_level-black_level);
raw_im=min(max(raw_im,0),1);  % raw_im is the normalized Bayer raw image (with Left and Right PD pixels implanted)

% generate PD map
pd_map=zeros(16,16);
pd_map(1:2,6:7)=[1 2;1 2];
pd_map(7:8,2:3)=[1 2;1 2];
pd_map(9:10,10:11)=[1 2;1 2];
pd_map(15:16,14:15)=[1 2;1 2];
pd_map_full=zeros(size(raw_im));  % pd_map_full: 0=normal pixel,   1=left_PD,   2=right_PD   
pd_map_full(17:end-16,17:end-16)=repmat(pd_map, size(raw_im,1)/16-2, size(raw_im,2)/16-2);

A=17:6128;B=17:8144; % test range （1921:3200）

raw_test=raw_im(A,B);
pd_map_test=pd_map_full(A,B);
figure,imshow(raw_test);
%figure,imshow(pd_map_test);


% color RGB on
raw_3D = cat(3,pd_map_full,pd_map_full,pd_map_full);
pd_RGB_map1 = zeros(4,4,3);
pd_RGB_map1(1:2,1:2,2) = [1 1;1 1];
pd_RGB_map1(3:4,3:4,2) = [1 1;1 1];
pd_RGB_map1(1:2,3:4,3) = [1 1;1 1];
pd_RGB_map1(3:4,1:2,1) = [1 1;1 1];
pd_RGB1 = repmat(pd_RGB_map1,4);

pd_RGB2 = pd_RGB1;
pd_RGB2(1:2,7,:) = reshape([0 0 1 1 0 0],[2,1,3]);
pd_RGB2(7:8,2,:) = reshape([0 0 1 1 0 0],[2,1,3]);
pd_RGB2(9:10,11,:) = reshape([0 0 1 1 0 0],[2,1,3]);
pd_RGB2(15:16,14,:) = reshape([0 0 1 1 0 0],[2,1,3]); %RGB1:normal  RGB2:defect

pd_RGB=zeros([size(raw_im),3]);
pd_RGB(17:end-16,17:end-16,:)=repmat(pd_RGB2, size(raw_im,1)/16-2, size(raw_im,2)/16-2);
COLOR = cat(3,raw_im,raw_im,raw_im).*pd_RGB;
%figure,imshow(COLOR);
%save('lab_color','COLOR');


%fix the pixels
[row,col]=find(pd_map_test>0);%average
for i=1:size(col,1)
    if (row(i)>4)&&(row(i)<(size(pd_map_test,1)-4))&&(col(i)>4)&&(col(i)<(size(pd_map_test,2)-4))&&(mod(col(i),16)~=3)&&(mod(col(i),16)~=6)&&(mod(col(i),16)~=10)&&(mod(col(i),16)~=15) % process the pixels in the center (fix half part for every PD pair)
        raw_test(row(i),col(i))=(raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+4,col(i)-4)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-4,col(i)-4)+raw_test(row(i),col(i)+4)+raw_test(row(i),col(i)-4)+raw_test(row(i)-4,col(i))+raw_test(row(i)+4,col(i)))/8;  % the algorithm
    end
end
figure,imshow(raw_test);
save('lab_fixed_avg.mat',"raw_test");
% pd_RGB_t=zeros([size(raw_test),3]);
% pd_RGB_t=repmat(pd_RGB1, size(raw_test,1)/16, size(raw_test,2)/16);
% figure,imshow(cat(3,raw_test,raw_test,raw_test).*pd_RGB_t);


%define the function
function out=read_raw16(fname,w,h)
    fid=fopen(fname,'rb');
    out=fread(fid,[w h],'uint16');
    fclose(fid);
    out=out';
end