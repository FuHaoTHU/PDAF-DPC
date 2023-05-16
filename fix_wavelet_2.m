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





[CA,CB,CC,CD] = dwt2(raw_test,'haar');
figure,imshow(CA);axis on
figure,imshow(CC);axis on



%fix the pixels
[row,col]=find(pd_map_test>0);

for j = 4:8:size(CA,1)
    for k = 9:8:size(CA,2)
        myAVG1 = CA(j-2,k+2);
         myAVG2 = CA(j+2,k+2);
         myAVG3 = CA(j-2,k-2);
         myAVG4 = CA(j+2,k-2);
         myAVG5 = CA(j,k+2);
         myAVG6 = CA(j-2,k);
         myAVG7 = CA(j,k-2);
         myAVG8 = CA(j+2,k);
               
         myAVG9 = CA(j-1,k+1);
         myAVG10 = CA(j+1,k+1);
         myAVG11 = CA(j-1,k-1);
         myAVG12 = CA(j+1,k-1);
         myAVG13 = CA(j,k+1);
         myAVG14 = CA(j-1,k);
         myAVG15 = CA(j,k-1);
         myAVG16 = CA(j+1,k);
                
        mydelta1 = abs(myAVG1-myAVG9);
        mydelta2 = abs(myAVG5-myAVG13);
        mydelta3 = abs(myAVG2-myAVG10);
        mydelta4 = abs(myAVG8-myAVG16);
        mydelta5 = abs(myAVG4-myAVG12);
        mydelta6 = abs(myAVG7-myAVG15);
        mydelta7 = abs(myAVG3-myAVG11);
        mydelta8 = abs(myAVG6-myAVG14);
        Direct = sort([mydelta1,mydelta2,mydelta3,mydelta4,mydelta5,mydelta6,mydelta7,mydelta8]);
        d1 = Direct(1,1);
        d2 = Direct(1,2);
        if d1==mydelta1
            CA(j,k) = 0.5*(myAVG1+myAVG9);
        elseif d1==mydelta2
            CA(j,k) = 0.5*(myAVG5+myAVG13);
        elseif d1==mydelta3
            CA(j,k) = 0.5*(myAVG10+myAVG2);
        elseif d1==mydelta4
            CA(j,k) = 0.5*(myAVG8+myAVG16);
        elseif d1==mydelta5
            CA(j,k) = 0.5*(myAVG12+myAVG4);
        elseif d1==mydelta6
            CA(j,k) = 0.5*(myAVG15+myAVG7);
        elseif d1==mydelta7
            CA(j,k) = 0.5*(myAVG11+myAVG3);
        else
            CA(j,k) = 0.5*(myAVG14+myAVG6);
        end
        
        if d2==mydelta1
            CA(j,k) = (CA(j,k)+myAVG1+myAVG9)/3;
        elseif d2==mydelta2
            CA(j,k) = (CA(j,k)+myAVG5+myAVG13)/3;
        elseif d2==mydelta3
            CA(j,k) = (CA(j,k)+myAVG10+myAVG2)/3;
        elseif d2==mydelta4
            CA(j,k) = (CA(j,k)+myAVG8+myAVG16)/3;
        elseif d2==mydelta5
            CA(j,k) = (CA(j,k)+myAVG12+myAVG4)/3;
        elseif d2==mydelta6
            CA(j,k) = (CA(j,k)+myAVG15+myAVG7)/3;
        elseif d2==mydelta7
            CA(j,k) = (CA(j,k)+myAVG11+myAVG3)/3;
        else
            CA(j,k) = (CA(j,k)+myAVG14+myAVG6)/3;
        end

 
    end
end

for j = 8:8:size(CA,1)-2
    for k = 7:8:size(CA,2)-2
        myAVG1 = CA(j-2,k+2);
         myAVG2 = CA(j+2,k+2);
         myAVG3 = CA(j-2,k-2);
         myAVG4 = CA(j+2,k-2);
         myAVG5 = CA(j,k+2);
         myAVG6 = CA(j-2,k);
         myAVG7 = CA(j,k-2);
         myAVG8 = CA(j+2,k);
               
         myAVG9 = CA(j-1,k+1);
         myAVG10 = CA(j+1,k+1);
         myAVG11 = CA(j-1,k-1);
         myAVG12 = CA(j+1,k-1);
         myAVG13 = CA(j,k+1);
         myAVG14 = CA(j-1,k);
         myAVG15 = CA(j,k-1);
         myAVG16 = CA(j+1,k);
                
         mydelta1 = abs(myAVG1-myAVG9);
        mydelta2 = abs(myAVG5-myAVG13);
        mydelta3 = abs(myAVG2-myAVG10);
        mydelta4 = abs(myAVG8-myAVG16);
        mydelta5 = abs(myAVG4-myAVG12);
        mydelta6 = abs(myAVG7-myAVG15);
        mydelta7 = abs(myAVG3-myAVG11);
        mydelta8 = abs(myAVG6-myAVG14);
        Direct = sort([mydelta1,mydelta2,mydelta3,mydelta4,mydelta5,mydelta6,mydelta7,mydelta8]);
        d1 = Direct(1,1);
        d2 = Direct(1,2);
        if d1==mydelta1
            CA(j,k) = 0.5*(myAVG1+myAVG9);
        elseif d1==mydelta2
            CA(j,k) = 0.5*(myAVG5+myAVG13);
        elseif d1==mydelta3
            CA(j,k) = 0.5*(myAVG10+myAVG2);
        elseif d1==mydelta4
            CA(j,k) = 0.5*(myAVG8+myAVG16);
        elseif d1==mydelta5
            CA(j,k) = 0.5*(myAVG12+myAVG4);
        elseif d1==mydelta6
            CA(j,k) = 0.5*(myAVG15+myAVG7);
        elseif d1==mydelta7
            CA(j,k) = 0.5*(myAVG11+myAVG3);
        else
            CA(j,k) = 0.5*(myAVG14+myAVG6);
        end
        
        if d2==mydelta1
            CA(j,k) = (CA(j,k)+myAVG1+myAVG9)/3;
        elseif d2==mydelta2
            CA(j,k) = (CA(j,k)+myAVG5+myAVG13)/3;
        elseif d2==mydelta3
            CA(j,k) = (CA(j,k)+myAVG10+myAVG2)/3;
        elseif d2==mydelta4
            CA(j,k) = (CA(j,k)+myAVG8+myAVG16)/3;
        elseif d2==mydelta5
            CA(j,k) = (CA(j,k)+myAVG12+myAVG4)/3;
        elseif d2==mydelta6
            CA(j,k) = (CA(j,k)+myAVG15+myAVG7)/3;
        elseif d2==mydelta7
            CA(j,k) = (CA(j,k)+myAVG11+myAVG3)/3;
        else
            CA(j,k) = (CA(j,k)+myAVG14+myAVG6)/3;
        end
 
    end
end




for j = 5:8:size(CC,1)
    for k = 6:8:size(CC,2)
        myAVG1 = CA(j-2,k+2);
         myAVG2 = CA(j+2,k+2);
         myAVG3 = CA(j-2,k-2);
         myAVG4 = CA(j+2,k-2);
         myAVG5 = CA(j,k+2);
         myAVG6 = CA(j-2,k);
         myAVG7 = CA(j,k-2);
         myAVG8 = CA(j+2,k);
               
         myAVG9 = CA(j-1,k+1);
         myAVG10 = CA(j+1,k+1);
         myAVG11 = CA(j-1,k-1);
         myAVG12 = CA(j+1,k-1);
         myAVG13 = CA(j,k+1);
         myAVG14 = CA(j-1,k);
         myAVG15 = CA(j,k-1);
         myAVG16 = CA(j+1,k);
                
         mydelta1 = abs(myAVG1-myAVG9);
        mydelta2 = abs(myAVG5-myAVG13);
        mydelta3 = abs(myAVG2-myAVG10);
        mydelta4 = abs(myAVG8-myAVG16);
        mydelta5 = abs(myAVG4-myAVG12);
        mydelta6 = abs(myAVG7-myAVG15);
        mydelta7 = abs(myAVG3-myAVG11);
        mydelta8 = abs(myAVG6-myAVG14);
        Direct = sort([mydelta1,mydelta2,mydelta3,mydelta4,mydelta5,mydelta6,mydelta7,mydelta8]);
        d1 = Direct(1,1);
        d2 = Direct(1,2);
        if d1==mydelta1
            CA(j,k) = 0.5*(myAVG1+myAVG9);
        elseif d1==mydelta2
            CA(j,k) = 0.5*(myAVG5+myAVG13);
        elseif d1==mydelta3
            CA(j,k) = 0.5*(myAVG10+myAVG2);
        elseif d1==mydelta4
            CA(j,k) = 0.5*(myAVG8+myAVG16);
        elseif d1==mydelta5
            CA(j,k) = 0.5*(myAVG12+myAVG4);
        elseif d1==mydelta6
            CA(j,k) = 0.5*(myAVG15+myAVG7);
        elseif d1==mydelta7
            CA(j,k) = 0.5*(myAVG11+myAVG3);
        else
            CA(j,k) = 0.5*(myAVG14+myAVG6);
        end
        
        if d2==mydelta1
            CA(j,k) = (CA(j,k)+myAVG1+myAVG9)/3;
        elseif d2==mydelta2
            CA(j,k) = (CA(j,k)+myAVG5+myAVG13)/3;
        elseif d2==mydelta3
            CA(j,k) = (CA(j,k)+myAVG10+myAVG2)/3;
        elseif d2==mydelta4
            CA(j,k) = (CA(j,k)+myAVG8+myAVG16)/3;
        elseif d2==mydelta5
            CA(j,k) = (CA(j,k)+myAVG12+myAVG4)/3;
        elseif d2==mydelta6
            CA(j,k) = (CA(j,k)+myAVG15+myAVG7)/3;
        elseif d2==mydelta7
            CA(j,k) = (CA(j,k)+myAVG11+myAVG3)/3;
        else
            CA(j,k) = (CA(j,k)+myAVG14+myAVG6)/3;
        end
 
    end
end
for j = 9:8:size(CC,1)
    for k = 4:8:size(CC,2)
         myAVG1 = CA(j-2,k+2);
         myAVG2 = CA(j+2,k+2);
         myAVG3 = CA(j-2,k-2);
         myAVG4 = CA(j+2,k-2);
         myAVG5 = CA(j,k+2);
         myAVG6 = CA(j-2,k);
         myAVG7 = CA(j,k-2);
         myAVG8 = CA(j+2,k);
               
         myAVG9 = CA(j-1,k+1);
         myAVG10 = CA(j+1,k+1);
         myAVG11 = CA(j-1,k-1);
         myAVG12 = CA(j+1,k-1);
         myAVG13 = CA(j,k+1);
         myAVG14 = CA(j-1,k);
         myAVG15 = CA(j,k-1);
         myAVG16 = CA(j+1,k);
                
         mydelta1 = abs(myAVG1-myAVG9);
        mydelta2 = abs(myAVG5-myAVG13);
        mydelta3 = abs(myAVG2-myAVG10);
        mydelta4 = abs(myAVG8-myAVG16);
        mydelta5 = abs(myAVG4-myAVG12);
        mydelta6 = abs(myAVG7-myAVG15);
        mydelta7 = abs(myAVG3-myAVG11);
        mydelta8 = abs(myAVG6-myAVG14);
        Direct = sort([mydelta1,mydelta2,mydelta3,mydelta4,mydelta5,mydelta6,mydelta7,mydelta8]);
        d1 = Direct(1,1);
        d2 = Direct(1,2);
        if d1==mydelta1
            CA(j,k) = 0.5*(myAVG1+myAVG9);
        elseif d1==mydelta2
            CA(j,k) = 0.5*(myAVG5+myAVG13);
        elseif d1==mydelta3
            CA(j,k) = 0.5*(myAVG10+myAVG2);
        elseif d1==mydelta4
            CA(j,k) = 0.5*(myAVG8+myAVG16);
        elseif d1==mydelta5
            CA(j,k) = 0.5*(myAVG12+myAVG4);
        elseif d1==mydelta6
            CA(j,k) = 0.5*(myAVG15+myAVG7);
        elseif d1==mydelta7
            CA(j,k) = 0.5*(myAVG11+myAVG3);
        else
            CA(j,k) = 0.5*(myAVG14+myAVG6);
        end
        
        if d2==mydelta1
            CA(j,k) = (CA(j,k)+myAVG1+myAVG9)/3;
        elseif d2==mydelta2
            CA(j,k) = (CA(j,k)+myAVG5+myAVG13)/3;
        elseif d2==mydelta3
            CA(j,k) = (CA(j,k)+myAVG10+myAVG2)/3;
        elseif d2==mydelta4
            CA(j,k) = (CA(j,k)+myAVG8+myAVG16)/3;
        elseif d2==mydelta5
            CA(j,k) = (CA(j,k)+myAVG12+myAVG4)/3;
        elseif d2==mydelta6
            CA(j,k) = (CA(j,k)+myAVG15+myAVG7)/3;
        elseif d2==mydelta7
            CA(j,k) = (CA(j,k)+myAVG11+myAVG3)/3;
        else
            CA(j,k) = (CA(j,k)+myAVG14+myAVG6)/3;
        end
 
 
    end
end

for j = 5:8:size(CC,1)
    for k = 6:8:size(CC,2)
        
            CC(j,k) = 0.0000;
        
 
    end
end

for j = 9:8:size(CC,1)
    for k = 4:8:size(CC,2)
        
            CC(j,k) = 0.0000;
     
    end
end

for j = 4:8:size(CC,1)
    for k = 9:8:size(CC,2)
        
            CC(j,k) = 0.0000;
   
 
    end
end

for j = 8:8:size(CC,1)
    for k = 7:8:size(CC,2)
        
            CC(j,k) = 0.0000;
       
 
    end
end






figure,imshow(CA);axis on
figure,imshow(CC);axis on

%CC = zeros(size(CC));
raw_test = idwt2(CA,CB,CC,CD,'haar');



figure,imshow(raw_test);axis on
save('chart_fixed_wavelet2',"raw_test");





%define the function
function out=read_raw16(fname,w,h)
    fid=fopen(fname,'rb');
    out=fread(fid,[w h],'uint16');
    fclose(fid);
    out=out';
end