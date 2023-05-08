clc
clear all

%---------------Point Deflection------------------------------------------------
 BCs=menu('Boundary Conditions : ','CCCC','SCSC','SSSC','SSSS','SFSC','SFSS','CFCF','SFSF');
 [b1,IW1_1,IW1_2,IW1_3,IW1_4,IW1_5,IW1_6,IW1_7,IW1_8,b2,LW2_1,b3,LW3_2,b4,LW4_3,b5,LW5_4] = Parameters(BCs);

 Em=input('\nEm : '); Ec=input('\nEc : '); 
 LOAD=menu('LOAD TYPE : ','UDL','DOUBLE SINE VARIATION');
 if LOAD==1
    LoadType= [1,0];
  else
    LoadType= [0,1]; 
 end
 AspRatio=input('\na=1, Aspect Ratio (b/a) : ');
 ThickRatio=input('\nThickness Ratio : '); Pindex=input('\nPower low index : '); 
 x1=input('\n Point Position x : '); y1=input('\n Point Position y : '); 

X=[Ec/Em,LoadType,AspRatio,ThickRatio,Pindex,x1,y1]';
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
    Deflection=a5
