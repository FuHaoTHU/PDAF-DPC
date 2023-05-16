clear;

fname='indoor_8160x6144.raw';
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
[row,col]=find(pd_map_test>0);

for i=1:size(col,1)
    if (row(i)>5)&&(row(i)<(size(pd_map_test,1)-5))&&(col(i)>5)&&(col(i)<(size(pd_map_test,2)-5))&&(mod(col(i),16)~=3)&&(mod(col(i),16)~=6)&&(mod(col(i),16)~=10)&&(mod(col(i),16)~=15)
        if (mod(row(i),2)==0)&&(mod(col(i),2)==1)% process the upper blue bad pixels
            myAVG1 = 0.25*(raw_test(row(i)+4,col(i)+5)+raw_test(row(i)+3,col(i)+5)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+3,col(i)+4));
            myAVG2 = 0.25*(raw_test(row(i)-4,col(i)+5)+raw_test(row(i)-5,col(i)+5)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-5,col(i)+4));
            myAVG3 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+3,col(i)-4)+raw_test(row(i)+4,col(i)-3)+raw_test(row(i)+3,col(i)-3));
            myAVG4 = 0.25*(raw_test(row(i)-5,col(i)-4)+raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-5,col(i)-3)+raw_test(row(i)-4,col(i)-3));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+5)+raw_test(row(i),col(i)+4)+raw_test(row(i)-1,col(i)+5)+raw_test(row(i)-1,col(i)+4));
            myAVG6 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+3,col(i))+raw_test(row(i)+4,col(i)+1)+raw_test(row(i)+3,col(i)+1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-3)+raw_test(row(i)-1,col(i)-4)+raw_test(row(i)-1,col(i)-3));
            myAVG8 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-5,col(i))+raw_test(row(i)-4,col(i)+1)+raw_test(row(i)-5,col(i)+1));
            
            myAVG9 = 0.25*(raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+1,col(i)+3)+raw_test(row(i)+2,col(i)+3));
            myAVG10 = 0.25*(raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-3,col(i)+2)+raw_test(row(i)-2,col(i)+3)+raw_test(row(i)-3,col(i)+3));
            myAVG11 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+1,col(i)-2));
            myAVG12 = 0.25*(raw_test(row(i)-3,col(i)-1)+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-3,col(i)-2)+raw_test(row(i)-2,col(i)-2));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+3)+raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-1,col(i)+3));
            myAVG14 = 0.25*(raw_test(row(i)+1,col(i))+raw_test(row(i)+2,col(i))+raw_test(row(i)+1,col(i)+1)+raw_test(row(i)+2,col(i)+1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-1)+raw_test(row(i),col(i)-2)+raw_test(row(i)-1,col(i)-1)+raw_test(row(i)-1,col(i)-2));
            myAVG16 = 0.25*(raw_test(row(i)-2,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-2,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            
            mydelta1 = (abs(myAVG1-myAVG9)+abs(myAVG12-myAVG9)+abs(myAVG12-myAVG4))/3;
            mydelta2 = (abs(myAVG10-myAVG2)+abs(myAVG11-myAVG10)+abs(myAVG11-myAVG3))/3;
            mydelta3 = (abs(myAVG14-myAVG6)+abs(myAVG14-myAVG16)+abs(myAVG16-myAVG8))/3;
            mydelta4 = (abs(myAVG13-myAVG5)+abs(myAVG13-myAVG15)+abs(myAVG15-myAVG7))/3;
        elseif (mod(row(i),2)==1)&&(mod(col(i),2)==1)
            myAVG1 = 0.25*(raw_test(row(i)+4,col(i)+5)+raw_test(row(i)+5,col(i)+5)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+5,col(i)+4));
            myAVG2 = 0.25*(raw_test(row(i)-4,col(i)+5)+raw_test(row(i)-3,col(i)+5)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-3,col(i)+4));
            myAVG3 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+5,col(i)-4)+raw_test(row(i)+4,col(i)-3)+raw_test(row(i)+5,col(i)-3));
            myAVG4 = 0.25*(raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-3,col(i)-4)+raw_test(row(i)-3,col(i)-3)+raw_test(row(i)-4,col(i)-3));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+5)+raw_test(row(i),col(i)+4)+raw_test(row(i)+1,col(i)+5)+raw_test(row(i)+1,col(i)+4));
            myAVG6 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+5,col(i))+raw_test(row(i)+4,col(i)+1)+raw_test(row(i)+5,col(i)+1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-3)+raw_test(row(i)+1,col(i)-4)+raw_test(row(i)+1,col(i)-3));
            myAVG8 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-4,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            
            myAVG9 = 0.25*(raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+3,col(i)+2)+raw_test(row(i)+2,col(i)+3)+raw_test(row(i)+3,col(i)+3));
            myAVG10 = 0.25*(raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-1,col(i)+3)+raw_test(row(i)-2,col(i)+3));
            myAVG11 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+3,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+3,col(i)-2));
            myAVG12 = 0.25*(raw_test(row(i)-1,col(i)-1)+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-1,col(i)-2)+raw_test(row(i)-2,col(i)-2));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+3)+raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+1,col(i)+3));
            myAVG14 = 0.25*(raw_test(row(i)+2,col(i))+raw_test(row(i)+3,col(i))+raw_test(row(i)+2,col(i)+1)+raw_test(row(i)+3,col(i)+1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-1)+raw_test(row(i),col(i)-2)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+1,col(i)-2));
            myAVG16 = 0.25*(raw_test(row(i)-1,col(i))+raw_test(row(i)-2,col(i))+raw_test(row(i)-1,col(i)+1)+raw_test(row(i)-2,col(i)+1));

            mydelta1 = (abs(myAVG1-myAVG9)+abs(myAVG12-myAVG9)+abs(myAVG12-myAVG4))/3;
            mydelta2 = (abs(myAVG10-myAVG2)+abs(myAVG11-myAVG10)+abs(myAVG11-myAVG3))/3;
            mydelta3 = (abs(myAVG14-myAVG6)+abs(myAVG14-myAVG16)+abs(myAVG16-myAVG8))/3;
            mydelta4 = (abs(myAVG13-myAVG5)+abs(myAVG13-myAVG15)+abs(myAVG15-myAVG7))/3;
        elseif (mod(row(i),2)==0)&&(mod(col(i),2)==0)% process the upper red bad pixels
            myAVG1 = 0.25*(raw_test(row(i)+4,col(i)+3)+raw_test(row(i)+3,col(i)+3)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+3,col(i)+4));
            myAVG2 = 0.25*(raw_test(row(i)-4,col(i)+3)+raw_test(row(i)-5,col(i)+3)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-5,col(i)+4));
            myAVG3 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+3,col(i)-4)+raw_test(row(i)+4,col(i)-5)+raw_test(row(i)+3,col(i)-5));
            myAVG4 = 0.25*(raw_test(row(i)-5,col(i)-4)+raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-5,col(i)-5)+raw_test(row(i)-4,col(i)-5));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+3)+raw_test(row(i),col(i)+4)+raw_test(row(i)-1,col(i)+3)+raw_test(row(i)-1,col(i)+4));
            myAVG6 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+3,col(i))+raw_test(row(i)+4,col(i)-1)+raw_test(row(i)+3,col(i)-1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-5)+raw_test(row(i)-1,col(i)-4)+raw_test(row(i)-1,col(i)-5));
            myAVG8 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-5,col(i))+raw_test(row(i)-4,col(i)-1)+raw_test(row(i)-5,col(i)-1));
            

            myAVG9 = 0.25*(raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+2,col(i)+1)+raw_test(row(i)+1,col(i)+1));
            myAVG10 = 0.25*(raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-3,col(i)+2)+raw_test(row(i)-2,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            myAVG11 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+1,col(i)-2));
            myAVG12 = 0.25*(raw_test(row(i)-3,col(i)-2)+raw_test(row(i)-2,col(i)-2)+raw_test(row(i)-3,col(i)-3)+raw_test(row(i)-2,col(i)-3));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+1)+raw_test(row(i),col(i)+2)+raw_test(row(i)-1,col(i)+1)+raw_test(row(i)-1,col(i)+2));
            myAVG14 = 0.25*(raw_test(row(i)+1,col(i))+raw_test(row(i)+2,col(i))+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+2,col(i)-1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-3)+raw_test(row(i),col(i)-2)+raw_test(row(i)-1,col(i)-3)+raw_test(row(i)-1,col(i)-2));
            myAVG16 = 0.25*(raw_test(row(i)-2,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-3,col(i)-1));

            mydelta1 = (abs(myAVG1-myAVG9)+abs(myAVG12-myAVG9)+abs(myAVG12-myAVG4))/3;
            mydelta2 = (abs(myAVG10-myAVG2)+abs(myAVG11-myAVG10)+abs(myAVG11-myAVG3))/3;
            mydelta3 = (abs(myAVG14-myAVG6)+abs(myAVG14-myAVG16)+abs(myAVG16-myAVG8))/3;
            mydelta4 = (abs(myAVG13-myAVG5)+abs(myAVG13-myAVG15)+abs(myAVG15-myAVG7))/3;
        elseif (mod(row(i),2)==1)&&(mod(col(i),2)==0)
            myAVG1 = 0.25*(raw_test(row(i)+4,col(i)+3)+raw_test(row(i)+5,col(i)+3)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+5,col(i)+4));
            myAVG2 = 0.25*(raw_test(row(i)-4,col(i)+3)+raw_test(row(i)-3,col(i)+3)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-3,col(i)+4));
            myAVG3 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+5,col(i)-4)+raw_test(row(i)+4,col(i)-5)+raw_test(row(i)+5,col(i)-5));
            myAVG4 = 0.25*(raw_test(row(i)-3,col(i)-4)+raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-3,col(i)-5)+raw_test(row(i)-4,col(i)-5));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+3)+raw_test(row(i),col(i)+4)+raw_test(row(i)+1,col(i)+3)+raw_test(row(i)+1,col(i)+4));
            myAVG6 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+5,col(i))+raw_test(row(i)+4,col(i)-1)+raw_test(row(i)+5,col(i)-1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-5)+raw_test(row(i)+1,col(i)-4)+raw_test(row(i)+1,col(i)-5));
            myAVG8 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-4,col(i)-1)+raw_test(row(i)-3,col(i)-1));
            
            myAVG9 = 0.25*(raw_test(row(i)+2,col(i)+1)+raw_test(row(i)+3,col(i)+1)+raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+3,col(i)+2));
            myAVG10 = 0.25*(raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-1,col(i)+1)+raw_test(row(i)-2,col(i)+1));
            myAVG11 = 0.25*(raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+3,col(i)-2)+raw_test(row(i)+2,col(i)-3)+raw_test(row(i)+3,col(i)-3));
            myAVG12 = 0.25*(raw_test(row(i)-1,col(i)-2)+raw_test(row(i)-2,col(i)-2)+raw_test(row(i)-1,col(i)-3)+raw_test(row(i)-2,col(i)-3));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+1)+raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+1,col(i)+1));
            myAVG14 = 0.25*(raw_test(row(i)+3,col(i))+raw_test(row(i)+2,col(i))+raw_test(row(i)+3,col(i)-1)+raw_test(row(i)+2,col(i)-1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-3)+raw_test(row(i),col(i)-2)+raw_test(row(i)+1,col(i)-3)+raw_test(row(i)+1,col(i)-2));
            myAVG16 = 0.25*(raw_test(row(i)-2,col(i))+raw_test(row(i)-1,col(i))+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-1,col(i)-1));

            mydelta1 = (abs(myAVG1-myAVG9)+abs(myAVG12-myAVG9)+abs(myAVG12-myAVG4))/3;
            mydelta2 = (abs(myAVG10-myAVG2)+abs(myAVG11-myAVG10)+abs(myAVG11-myAVG3))/3;
            mydelta3 = (abs(myAVG14-myAVG6)+abs(myAVG14-myAVG16)+abs(myAVG16-myAVG8))/3;
            mydelta4 = (abs(myAVG13-myAVG5)+abs(myAVG13-myAVG15)+abs(myAVG15-myAVG7))/3;
        end
        %[delta_max,direc] = min([mydelta1,mydelta2,mydelta3,mydelta4]);
%         if direc == 1
%             raw_test(row(i),col(i)) = 2*myAVG1+2*myAVG4-myAVG2-myAVG3-myAVG5-myAVG6-myAVG7-myAVG8;
%         elseif direc == 2
%             raw_test(row(i),col(i)) = 2*myAVG2+2*myAVG3-myAVG1-myAVG4-myAVG5-myAVG6-myAVG7-myAVG8;
%         elseif direc ==3
%             raw_test(row(i),col(i)) = 2*myAVG6+2*myAVG8-myAVG1-myAVG2-myAVG3-myAVG4-myAVG5-myAVG7;
%         else
%             raw_test(row(i),col(i)) = 2*myAVG5+2*myAVG7-myAVG1-myAVG2-myAVG3-myAVG4-myAVG6-myAVG8;
%         end
%  
%         if(mod(row(i),2)==0)&&(mod(col(i),2)==1)
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+2*raw_test(row(i),col(i)+1)+2*raw_test(row(i)-1,col(i)+1))/2;
%         elseif(mod(row(i),2)==1)&&(mod(col(i),2)==1)
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+2*raw_test(row(i),col(i)+1)+2*raw_test(row(i)+1,col(i)+1))/2;
%         elseif(mod(row(i),2)==0)&&(mod(col(i),2)==0)
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+2*raw_test(row(i),col(i)-1)+2*raw_test(row(i)-1,col(i)-1))/2;
%         else
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+2*raw_test(row(i),col(i))+2*raw_test(row(i)+1,col(i)-1))/2;
%         end
        d1 = 2*myAVG1+2*myAVG4-myAVG2-myAVG3-myAVG5-myAVG6-myAVG7-myAVG8;
        d2 = 2*myAVG2+2*myAVG3-myAVG1-myAVG4-myAVG5-myAVG6-myAVG7-myAVG8;
        d3 = 2*myAVG6+2*myAVG8-myAVG1-myAVG2-myAVG3-myAVG4-myAVG5-myAVG7;
        d4 = 2*myAVG5+2*myAVG7-myAVG1-myAVG2-myAVG3-myAVG4-myAVG6-myAVG8;
        [d_min,direc] = min([d1,d2,d3,d4]);
        if direc == 1
            raw_test(row(i),col(i)) = 0.25*(myAVG12+myAVG9+myAVG1+myAVG4);
        elseif direc == 2
            raw_test(row(i),col(i)) = 0.25*(myAVG11+myAVG10+myAVG2+myAVG3);
        elseif direc ==3
            raw_test(row(i),col(i)) = 0.25*(myAVG6+myAVG8+myAVG14+myAVG16);
        else
            raw_test(row(i),col(i)) = 0.25*(myAVG5+myAVG7+myAVG13+myAVG15);
        end
    end
end

figure,imshow(raw_test);
save('indoor_fixed_4',"raw_test");
%pd_RGB_t=zeros([size(raw_test),3]);
%pd_RGB_t=repmat(pd_RGB1, size(raw_test,1)/16, size(raw_test,2)/16);
%figure,imshow(cat(3,raw_test,raw_test,raw_test).*pd_RGB_t);




%define the function
function out=read_raw16(fname,w,h)
    fid=fopen(fname,'rb');
    out=fread(fid,[w h],'uint16');
    fclose(fid);
    out=out';
end