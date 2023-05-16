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
        if (mod(row(i),2)==0)&&(mod(col(i),2)==1)% process the upper blue bad pixels
            myAVG1 = mean(mean(raw_test(row(i)+3:row(i)+4,col(i)+4:col(i)+5)));
            myAVG2 = mean(mean(raw_test(row(i)-5:row(i)-4,col(i)+4:col(i)+5)));
            myAVG3 = mean(mean(raw_test(row(i)+3:row(i)+4,col(i)-4:col(i)-3)));
            myAVG4 = mean(mean(raw_test(row(i)-5:row(i)-4,col(i)-4:col(i)-3)));
            myAVG5 = mean(mean(raw_test(row(i)-1:row(i),col(i)+4:col(i)+5)));
            myAVG6 = mean(mean(raw_test(row(i)+3:row(i)+4,col(i):col(i)+1)));
            myAVG7 = mean(mean(raw_test(row(i)-1:row(i),col(i)-4:col(i)-3)));
            myAVG8 = mean(mean(raw_test(row(i)-5:row(i)-4,col(i):col(i)+1)));
            
            myAVG9 = mean(mean(raw_test(row(i)+1:row(i)+2,col(i)+2:col(i)+3)));
            myAVG10 = mean(mean(raw_test(row(i)-3:row(i)-2,col(i)+2:col(i)+3)));
            myAVG11 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+1,col(i)-2));
            myAVG12 = 0.25*(raw_test(row(i)-3,col(i)-1)+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-3,col(i)-2)+raw_test(row(i)-2,col(i)-2));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+3)+raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-1,col(i)+3));
            myAVG14 = 0.25*(raw_test(row(i)+1,col(i))+raw_test(row(i)+2,col(i))+raw_test(row(i)+1,col(i)+1)+raw_test(row(i)+2,col(i)+1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-1)+raw_test(row(i),col(i)-2)+raw_test(row(i)-1,col(i)-1)+raw_test(row(i)-1,col(i)-2));
            myAVG16 = 0.25*(raw_test(row(i)-2,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-2,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            

   
        elseif (mod(row(i),2)==1)&&(mod(col(i),2)==1)
            myAVG1 = 0.25*(raw_test(row(i)+4,col(i)+5)+raw_test(row(i)+5,col(i)+5)+raw_test(row(i)+4,col(i)+4)+raw_test(row(i)+5,col(i)+4));
            myAVG2 = 0.25*(raw_test(row(i)-4,col(i)+5)+raw_test(row(i)-3,col(i)+5)+raw_test(row(i)-4,col(i)+4)+raw_test(row(i)-3,col(i)+4));
            myAVG3 = 0.25*(raw_test(row(i)+4,col(i)-4)+raw_test(row(i)+5,col(i)-4)+raw_test(row(i)+4,col(i)-3)+raw_test(row(i)+5,col(i)-3));
            myAVG4 = 0.25*(raw_test(row(i)-4,col(i)-4)+raw_test(row(i)-3,col(i)-4)+raw_test(row(i)-3,col(i)-3)+raw_test(row(i)-4,col(i)-3));
            myAVG5 = 0.25*(raw_test(row(i),col(i)+5)+raw_test(row(i),col(i)+4)+raw_test(row(i)+1,col(i)+5)+raw_test(row(i)+1,col(i)+4));
            myAVG6 = 0.25*(raw_test(row(i)+4,col(i))+raw_test(row(i)+5,col(i))+raw_test(row(i)+4,col(i)+1)+raw_test(row(i)+5,col(i)+1));
            myAVG7 = 0.25*(raw_test(row(i),col(i)-4)+raw_test(row(i),col(i)-3)+raw_test(row(i)-1,col(i)-4)+raw_test(row(i)-1,col(i)-3));
            myAVG8 = 0.25*(raw_test(row(i)-4,col(i))+raw_test(row(i)-3,col(i))+raw_test(row(i)-4,col(i)+1)+raw_test(row(i)-3,col(i)+1));
            
            myAVG9 = 0.25*(raw_test(row(i)+2,col(i)+2)+raw_test(row(i)+3,col(i)+2)+raw_test(row(i)+2,col(i)+3)+raw_test(row(i)+3,col(i)+3));
            myAVG10 = 0.25*(raw_test(row(i)-1,col(i)+2)+raw_test(row(i)-2,col(i)+2)+raw_test(row(i)-1,col(i)+3)+raw_test(row(i)-2,col(i)+3));
            myAVG11 = 0.25*(raw_test(row(i)+2,col(i)-1)+raw_test(row(i)+3,col(i)-1)+raw_test(row(i)+2,col(i)-2)+raw_test(row(i)+3,col(i)-2));
            myAVG12 = 0.25*(raw_test(row(i)-1,col(i)-1)+raw_test(row(i)-2,col(i)-1)+raw_test(row(i)-1,col(i)-2)+raw_test(row(i)-2,col(i)-2));
            myAVG13 = 0.25*(raw_test(row(i),col(i)+2)+raw_test(row(i),col(i)+3)+raw_test(row(i)+1,col(i)+2)+raw_test(row(i)+1,col(i)+3));
            myAVG14 = 0.25*(raw_test(row(i)+2,col(i))+raw_test(row(i)+3,col(i))+raw_test(row(i)+2,col(i)+1)+raw_test(row(i)+3,col(i)+1));
            myAVG15 = 0.25*(raw_test(row(i),col(i)-1)+raw_test(row(i),col(i)-2)+raw_test(row(i)+1,col(i)-1)+raw_test(row(i)+1,col(i)-2));
            myAVG16 = 0.25*(raw_test(row(i)-1,col(i))+raw_test(row(i)-2,col(i))+raw_test(row(i)-1,col(i)+1)+raw_test(row(i)-2,col(i)+1));

           
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

            
        end
        mydelta1 = (abs(myAVG1-myAVG9)+abs(myAVG12-myAVG9)+abs(myAVG12-myAVG4))/3;
        mydelta2 = (abs(myAVG10-myAVG2)+abs(myAVG11-myAVG10)+abs(myAVG11-myAVG3))/3;
        mydelta3 = (abs(myAVG14-myAVG6)+abs(myAVG14-myAVG16)+abs(myAVG16-myAVG8))/3;
        mydelta4 = (abs(myAVG13-myAVG5)+abs(myAVG13-myAVG15)+abs(myAVG15-myAVG7))/3;
        
        [~,direc] = min([mydelta1,mydelta2,mydelta3,mydelta4]);
        if direc == 1
            raw_test(row(i),col(i)) = 0.5*(myAVG12+myAVG9);
        elseif direc == 2
            raw_test(row(i),col(i)) = 0.5*(myAVG11+myAVG10);
        elseif direc ==3
            raw_test(row(i),col(i)) = 0.5*(myAVG6+myAVG8);
        else
            raw_test(row(i),col(i)) = 0.5*(myAVG5+myAVG7);
        end
%         if(mod(row(i),2)==0)&&(mod(col(i),2)==1)
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i)+1)+raw_test(row(i)-1,col(i)+1))/3;
%         elseif(mod(row(i),2)==1)&&(mod(col(i),2)==1)
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i)+1)+raw_test(row(i)+1,col(i)+1))/3;
%         elseif(mod(row(i),2)==0)&&(mod(col(i),2)==0)
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i)-1)+raw_test(row(i)-1,col(i)-1))/3;
%         else
%             raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i))+raw_test(row(i)+1,col(i)-1))/3;
%         end
        if(mod(row(i),2)==0)&&(mod(col(i),2)==1)
            mse1 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+3:row(i)+4,col(i)+4:col(i)+5));
            mse2 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-5:row(i)-4,col(i)+4:col(i)+5));
            mse3 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+3:row(i)+4,col(i)-4:col(i)-3));
            mse4 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-5:row(i)-4,col(i)-4:col(i)-3));
            mse5 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-1:row(i),col(i)+4:col(i)+5));
            mse6 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+3:row(i)+4,col(i):col(i)+1));
            mse7 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-1:row(i),col(i)-4:col(i)-3));
            mse8 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-5:row(i)-4,col(i):col(i)+1));

        elseif(mod(row(i),2)==1)&&(mod(col(i),2)==1)
            mse1 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+4:row(i)+5,col(i)+4:col(i)+5));
            mse2 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-4:row(i)-3,col(i)+4:col(i)+5));
            mse3 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+4:row(i)+5,col(i)-4:col(i)-3));
            mse4 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-4:row(i)-3,col(i)-4:col(i)-3));
            mse5 = mymse(raw_test(row(i),col(i)),raw_test(row(i):row(i)+1,col(i)+4:col(i)+5));
            mse6 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+4:row(i)+5,col(i):col(i)+1));
            mse7 = mymse(raw_test(row(i),col(i)),raw_test(row(i):row(i)+1,col(i)-4:col(i)-3));
            mse8 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-4:row(i)-3,col(i):col(i)+1));
        elseif(mod(row(i),2)==0)&&(mod(col(i),2)==0)
            mse1 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+3:row(i)+4,col(i)+3:col(i)+4));
            mse2 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-5:row(i)-4,col(i)+3:col(i)+4));
            mse3 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+3:row(i)+4,col(i)-5:col(i)-4));
            mse4 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-5:row(i)-4,col(i)-5:col(i)-4));
            mse5 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-1:row(i),col(i)+3:col(i)+4));
            mse6 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+3:row(i)+4,col(i)-1:col(i)));
            mse7 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-1:row(i),col(i)-5:col(i)-4));
            mse8 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-5:row(i)-4,col(i)-1:col(i)));
        else
            mse1 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+4:row(i)+5,col(i)+3:col(i)+4));
            mse2 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-4:row(i)-3,col(i)+3:col(i)+4));
            mse3 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+4:row(i)+5,col(i)-5:col(i)-4));
            mse4 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-4:row(i)-3,col(i)-5:col(i)-4));
            mse5 = mymse(raw_test(row(i),col(i)),raw_test(row(i):row(i)+1,col(i)+3:col(i)+4));
            mse6 = mymse(raw_test(row(i),col(i)),raw_test(row(i)+4:row(i)+5,col(i)-1:col(i)));
            mse7 = mymse(raw_test(row(i),col(i)),raw_test(row(i):row(i)+1,col(i)-5:col(i)-4));
            mse8 = mymse(raw_test(row(i),col(i)),raw_test(row(i)-4:row(i)-3,col(i)-1:col(i)));
        end
        %思路：找均方误差最小的两个方向做均值
        MSE = sort([mse1,mse2,mse3,mse4,mse5,mse6,mse7,mse8]);
        d1 = MSE(1,1);
        d2 = MSE(1,2);
        if d1==mse1
            raw_test(row(i),col(i)) = 0.5*(myAVG1+myAVG9);
        elseif d1==mse2
            raw_test(row(i),col(i)) = 0.5*(myAVG5+myAVG13);
        elseif d1==mse3
            raw_test(row(i),col(i)) = 0.5*(myAVG10+myAVG2);
        elseif d1==mse4
            raw_test(row(i),col(i)) = 0.5*(myAVG8+myAVG16);
        elseif d1==mse5
            raw_test(row(i),col(i)) = 0.5*(myAVG12+myAVG4);
        elseif d1==mse6
            raw_test(row(i),col(i)) = 0.5*(myAVG15+myAVG7);
        elseif d1==mse7
            raw_test(row(i),col(i)) = 0.5*(myAVG11+myAVG3);
        else
            raw_test(row(i),col(i)) = 0.5*(myAVG14+myAVG6);
        end
        
        if d2==mse1
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG1+myAVG9)/3;
        elseif d2==mse2
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG5+myAVG13)/3;
        elseif d2==mse3
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG10+myAVG2)/3;
        elseif d2==mse4
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG8+myAVG16)/3;
        elseif d2==mse5
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG12+myAVG4)/3;
        elseif d2==mse6
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG15+myAVG7)/3;
        elseif d2==mse7
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG11+myAVG3)/3;
        else
            raw_test(row(i),col(i)) = (raw_test(row(i),col(i))+myAVG14+myAVG6)/3;
        end

        if(mod(row(i),2)==0)&&(mod(col(i),2)==1)
            raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i)+1)+raw_test(row(i)-1,col(i)+1))/3;
        elseif(mod(row(i),2)==1)&&(mod(col(i),2)==1)
            raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i)+1)+raw_test(row(i)+1,col(i)+1))/3;
        elseif(mod(row(i),2)==0)&&(mod(col(i),2)==0)
            raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i)-1)+raw_test(row(i)-1,col(i)-1))/3;
        else
            raw_test(row(i),col(i))=(raw_test(row(i),col(i))+raw_test(row(i),col(i))+raw_test(row(i)+1,col(i)-1))/3;
        end
    end
end

figure,imshow(raw_test);
save('chart_fixed_3',"raw_test");




%define the function
function out=read_raw16(fname,w,h)
    fid=fopen(fname,'rb');
    out=fread(fid,[w h],'uint16');
    fclose(fid);
    out=out';
end

function out=mymse(pixel,P)
    err = [abs(pixel-P(1,1)),abs(pixel-P(1,2)),abs(pixel-P(2,1)),abs(pixel-P(2,2))];
    out = 0;
    for i = 1:4
        out = out + err(i)^2;
    end
    out = out*0.25;
end