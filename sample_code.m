% read raw file
fname='chart_8160x6144.raw';
width=8160;
height=6144;
raw_im=read_raw16(fname,width,height);
myreadraw = raw_im;

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

% show raw image and PD_map
figure,imshow(raw_im);
figure,imshow(pd_map_full/2);

function out=read_raw16(fname,w,h)
    fid=fopen(fname,'rb');
    out=fread(fid,[w h],'uint16');
    fclose(fid);
    out=out';
end