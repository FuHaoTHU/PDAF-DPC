clear;

fname='chart_8160x6144.raw';
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




%fix the pixels
[row,col]=find(pd_map_test>0);

for i=1:size(col,1)
    if (row(i)>5)&&(row(i)<(size(pd_map_test,1)-5))&&(col(i)>5)&&(col(i)<(size(pd_map_test,2)-5))&&(mod(col(i),16)~=3)&&(mod(col(i),16)~=6)&&(mod(col(i),16)~=10)&&(mod(col(i),16)~=15)
       if (mod(row(i),2)==0)&&(mod(col(i),2)==1)% process the lower blue bad pixels
            myAVG2 = 0.25*(raw_test(row(i)+4,col(i)+5)+raw_test(row(i)+3,col(i)+5)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+3,col(i)+4));
            myAVG1 = 0.25*(raw_test(row(i)-4,col(i)+5)+raw_test(row(i)-5,col(i)+5)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-5,col(i)+4));
            myAVG4 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+3,col(i)-4)+raw_test(row(i)+4,col(i)-3)+raw_test(row(i)+3,col(i)-3));
            myAVG3 = 0.25*(raw_test(row(i)-5,col(i)-4)+raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-5,col(i)-3)+raw_test(row(i)-4,col(i)-3));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+5)+raw_test(row(i),col(i)+4)+raw_test(row(i)-1,col(i)+5)+raw_test(row(i)-1,col(i)+4));
            myAVG8 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+3,col(i))+raw_test(row(i)+4,col(i)+1)+raw_test(row(i)+3,col(i)+1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-3)+raw_test(row(i)-1,col(i)-4)+raw_test(row(i)-1,col(i)-3));
            myAVG6 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-5,col(i))+raw_test(row(i)-4,col(i)+1)+raw_test(row(i)-5,col(i)+1));
            
            myAVG10 = 0.25*(raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+1,col(i)+3)+raw_test(row(i)+2,col(i)+3));
            myAVG9 = 0.25*(raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-3,col(i)+2)+raw_test(row(i)-2,col(i)+3)+raw_test(row(i)-3,col(i)+3));
            myAVG12 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+1,col(i)-2));
            myAVG11 = 0.25*(raw_test(row(i)-3,col(i)-1)+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-3,col(i)-2)+raw_test(row(i)-2,col(i)-2));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+3)+raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-1,col(i)+3));
            myAVG16 = 0.25*(raw_test(row(i)+1,col(i))+raw_test(row(i)+2,col(i))+raw_test(row(i)+1,col(i)+1)+raw_test(row(i)+2,col(i)+1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-1)+raw_test(row(i),col(i)-2)+raw_test(row(i)-1,col(i)-1)+raw_test(row(i)-1,col(i)-2));
            myAVG14 = 0.25*(raw_test(row(i)-2,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-2,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            
            myAVG = 0.5*(raw_test(row(i),col(i)+1)+raw_test(row(i)-1,col(i)+1));
            
        elseif (mod(row(i),2)==1)&&(mod(col(i),2)==1)
            myAVG2 = 0.25*(raw_test(row(i)+4,col(i)+5)+raw_test(row(i)+5,col(i)+5)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+5,col(i)+4));
            myAVG1 = 0.25*(raw_test(row(i)-4,col(i)+5)+raw_test(row(i)-3,col(i)+5)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-3,col(i)+4));
            myAVG4 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+5,col(i)-4)+raw_test(row(i)+4,col(i)-3)+raw_test(row(i)+5,col(i)-3));
            myAVG3 = 0.25*(raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-3,col(i)-4)+raw_test(row(i)-3,col(i)-3)+raw_test(row(i)-4,col(i)-3));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+5)+raw_test(row(i),col(i)+4)+raw_test(row(i)+1,col(i)+5)+raw_test(row(i)+1,col(i)+4));
            myAVG8 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+5,col(i))+raw_test(row(i)+4,col(i)+1)+raw_test(row(i)+5,col(i)+1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-3)+raw_test(row(i)+1,col(i)-4)+raw_test(row(i)+1,col(i)-3));
            myAVG6 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-4,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            
            myAVG10 = 0.25*(raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+3,col(i)+2)+raw_test(row(i)+2,col(i)+3)+raw_test(row(i)+3,col(i)+3));
            myAVG9 = 0.25*(raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-1,col(i)+3)+raw_test(row(i)-2,col(i)+3));
            myAVG12 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+3,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+3,col(i)-2));
            myAVG11 = 0.25*(raw_test(row(i)-1,col(i)-1)+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-1,col(i)-2)+raw_test(row(i)-2,col(i)-2));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+3)+raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+1,col(i)+3));
            myAVG16 = 0.25*(raw_test(row(i)+2,col(i))+raw_test(row(i)+3,col(i))+raw_test(row(i)+2,col(i)+1)+raw_test(row(i)+3,col(i)+1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-1)+raw_test(row(i),col(i)-2)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+1,col(i)-2));
            myAVG14 = 0.25*(raw_test(row(i)-1,col(i))+raw_test(row(i)-2,col(i))+raw_test(row(i)-1,col(i)+1)+raw_test(row(i)-2,col(i)+1));

            myAVG = 0.5*(raw_test(row(i),col(i)+1)+raw_test(row(i)+1,col(i)+1));

        elseif (mod(row(i),2)==0)&&(mod(col(i),2)==0)% process the lower red bad pixels
            myAVG2 = 0.25*(raw_test(row(i)+4,col(i)+3)+raw_test(row(i)+3,col(i)+3)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+3,col(i)+4));
            myAVG1 = 0.25*(raw_test(row(i)-4,col(i)+3)+raw_test(row(i)-5,col(i)+3)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-5,col(i)+4));
            myAVG4 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+3,col(i)-4)+raw_test(row(i)+4,col(i)-5)+raw_test(row(i)+3,col(i)-5));
            myAVG3 = 0.25*(raw_test(row(i)-5,col(i)-4)+raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-5,col(i)-5)+raw_test(row(i)-4,col(i)-5));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+3)+raw_test(row(i),col(i)+4)+raw_test(row(i)-1,col(i)+3)+raw_test(row(i)-1,col(i)+4));
            myAVG8 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+3,col(i))+raw_test(row(i)+4,col(i)-1)+raw_test(row(i)+3,col(i)-1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-5)+raw_test(row(i)-1,col(i)-4)+raw_test(row(i)-1,col(i)-5));
            myAVG6 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-5,col(i))+raw_test(row(i)-4,col(i)-1)+raw_test(row(i)-5,col(i)-1));
            

            myAVG10 = 0.25*(raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+2,col(i)+1)+raw_test(row(i)+1,col(i)+1));
            myAVG9 = 0.25*(raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-3,col(i)+2)+raw_test(row(i)-2,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            myAVG12 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+1,col(i)-2));
            myAVG11 = 0.25*(raw_test(row(i)-3,col(i)-2)+raw_test(row(i)-2,col(i)-2)+raw_test(row(i)-3,col(i)-3)+raw_test(row(i)-2,col(i)-3));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+1)+raw_test(row(i),col(i)+2)+raw_test(row(i)-1,col(i)+1)+raw_test(row(i)-1,col(i)+2));
            myAVG16 = 0.25*(raw_test(row(i)+1,col(i))+raw_test(row(i)+2,col(i))+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+2,col(i)-1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-3)+raw_test(row(i),col(i)-2)+raw_test(row(i)-1,col(i)-3)+raw_test(row(i)-1,col(i)-2));
            myAVG14 = 0.25*(raw_test(row(i)-2,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-3,col(i)-1));

            myAVG = 0.5*(raw_test(row(i),col(i)-1)+raw_test(row(i)-1,col(i)-1));

        elseif (mod(row(i),2)==1)&&(mod(col(i),2)==0)
            myAVG2 = 0.25*(raw_test(row(i)+4,col(i)+3)+raw_test(row(i)+5,col(i)+3)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+5,col(i)+4));
            myAVG1 = 0.25*(raw_test(row(i)-4,col(i)+3)+raw_test(row(i)-3,col(i)+3)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-3,col(i)+4));
            myAVG4 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+5,col(i)-4)+raw_test(row(i)+4,col(i)-5)+raw_test(row(i)+5,col(i)-5));
            myAVG3 = 0.25*(raw_test(row(i)-3,col(i)-4)+raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-3,col(i)-5)+raw_test(row(i)-4,col(i)-5));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+3)+raw_test(row(i),col(i)+4)+raw_test(row(i)+1,col(i)+3)+raw_test(row(i)+1,col(i)+4));
            myAVG8 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+5,col(i))+raw_test(row(i)+4,col(i)-1)+raw_test(row(i)+5,col(i)-1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-5)+raw_test(row(i)+1,col(i)-4)+raw_test(row(i)+1,col(i)-5));
            myAVG6 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-4,col(i)-1)+raw_test(row(i)-3,col(i)-1));
            
            myAVG10 = 0.25*(raw_test(row(i)+2,col(i)+1)+raw_test(row(i)+3,col(i)+1)+raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+3,col(i)+2));
            myAVG9 = 0.25*(raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-1,col(i)+1)+raw_test(row(i)-2,col(i)+1));
            myAVG12 = 0.25*(raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+3,col(i)-2)+raw_test(row(i)+2,col(i)-3)+raw_test(row(i)+3,col(i)-3));
            myAVG11 = 0.25*(raw_test(row(i)-1,col(i)-2)+raw_test(row(i)-2,col(i)-2)+raw_test(row(i)-1,col(i)-3)+raw_test(row(i)-2,col(i)-3));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+1)+raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+1,col(i)+1));
            myAVG16 = 0.25*(raw_test(row(i)+3,col(i))+raw_test(row(i)+2,col(i))+raw_test(row(i)+3,col(i)-1)+raw_test(row(i)+2,col(i)-1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-3)+raw_test(row(i),col(i)-2)+raw_test(row(i)+1,col(i)-3)+raw_test(row(i)+1,col(i)-2));
            myAVG14 = 0.25*(raw_test(row(i)-2,col(i))+raw_test(row(i)-1,col(i))+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-1,col(i)-1));
            

            myAVG = 0.5*(raw_test(row(i),col(i))+raw_test(row(i)+1,col(i)-1));
   
        end
        
       V = [myAVG7,myAVG11,myAVG6;myAVG12,myAVG,myAVG9;myAVG8,myAVG10,myAVG5];
       [X,Y] = meshgrid(-1:1);
       [Xq,Yq] = meshgrid(-1:0.5:1);
       Vq = interp2(X,Y,V,Xq,Yq,'spline');
       
       if(mod(row(i),2)==0)&&(mod(col(i),2)==1)
            raw_test(row(i),col(i))= Vq(4,2);
       elseif(mod(row(i),2)==1)&&(mod(col(i),2)==1)
            raw_test(row(i),col(i))= Vq(2,2);
       elseif(mod(row(i),2)==0)&&(mod(col(i),2)==0)
            raw_test(row(i),col(i))= Vq(4,4);
       else
            raw_test(row(i),col(i))= Vq(2,4);
       end
       



    end
end


figure,imshow(raw_test);
save('chart_fixed_intp',"raw_test");
out = Demosaic_Func(raw_test);



%define the function
function out=read_raw16(fname,w,h)
    fid=fopen(fname,'rb');
    out=fread(fid,[w h],'uint16');
    fclose(fid);
    out=out';
end