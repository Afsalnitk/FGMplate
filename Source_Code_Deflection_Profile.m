clc
clear all

%-------------Defection Profile----------------------------------------------------------- 
 BCs=menu('Boundary Conditions : ','CCCC','SCSC','SSSC','SSSS','SFSC','SFSS','CFCF','SFSF');

 Em=input('\nEm : '); Ec=input('\nEc : '); 
 LOAD=menu('LOAD TYPE : ','UDL','DOUBLE SINE VARIATION');
 if LOAD==1
    LoadType= [1,0];
 else
    LoadType= [0,1]; 
 end
 AspRatio=input('\na=1, Aspect Ratio (b/a) : ');
 ThickRatio=input('\nThickness Ratio : '); Pindex=input('\nPower low index : '); 

tic
 [b1,IW1_1,IW1_2,IW1_3,IW1_4,IW1_5,IW1_6,IW1_7,IW1_8,b2,LW2_1,b3,LW3_2,b4,LW4_3,b5,LW5_4] = Parameters(BCs);
ndivl=30;
ndivw=30;
a=1;    b=AspRatio;
count=0;
for i = 1:(ndivl+1)
for j = 1:(ndivw+1)
    count=count+1;
x(1,((ndivw+1)*(i-1) +j))= (a/ndivl)*(i-1);
x(2,((ndivw+1)*(i-1) +j))= -(b/ndivw)*(j-1)+b/2;
        Xp(i,j)=x(1,((ndivw+1)*(i-1) +j));
        Yp(i,j)=x(2,((ndivw+1)*(i-1) +j));

X=[Ec/Em,LoadType,AspRatio,ThickRatio,Pindex,Xp(i,j),Yp(i,j)]';
X=num2cell(X);

% ===== SIMULATION ========
    % Layer 1
    a1 = tansig(b1 + IW1_1*X{1} + IW1_2*X{2} + IW1_3*X{3} + IW1_4*X{4} + IW1_5*X{5} + IW1_6*X{6} + IW1_7*X{7} + IW1_8*X{8});
    % Layer 2
    a2 = tansig(b2 + LW2_1*a1);
    % Layer 3
    a3 = tansig(b3 + LW3_2*a2);
    % Layer 4
    a4 = tansig(b4 + LW4_3*a3);
    % Layer 5
    a5 = b5+ LW5_4*a4;
    
    % Output 
    W(i,j)=-a5;
    Deflection(count)=a5;
end
end
toc
Max_Deflections=max(abs(Deflection));

surf(Xp,Yp,W)
pbaspect([1 AspRatio 1/2.5]);
xlabel('X axis');
ylabel('Y axis');
zlabel('w');
