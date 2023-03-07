clc
clear all


%---------------TABLULAR RESULTS------------------------------------------------
 BCs=3;  
Em=70; Ec=380;LoadType=1; ThickRatio=10; Pindex=10; 
x1=0.5; y1=0;
x2=0.25; y2=0;
Lb=1;
AHP=0;
for BCs=1:8
Em=70e6;
EcL=[380]*1e6;
for EcI=1:1
    Ec=EcL(EcI);
  Ec_Em=Ec/Em;
DDD=[1,2,3,4,5];
for DD=1:1
    AspRatio=DDD(DD);
H=[1/2,1/5,1/10,1/20,1/50,1/100]*Lb;
for HH=1:6
h=H(HH);
ThickRatio=Lb/h;
P=[0 0.5 1 2 5 10];
for PPP=1:6
    AHP=AHP+1;
    Pindex=P(PPP);
    x1=0.5; y1=0;



[b1,IW1_1,IW1_2,IW1_3,IW1_4,IW1_5,IW1_6,IW1_7,IW1_8,b2,LW2_1,b3,LW3_2,b4,LW4_3,b5,LW5_4] = Parameters(BCs);

% X1=[Ec/Em,LoadType,0,AspRatio,ThickRatio,Pindex,x1,y1]';
% % X2=[Ec/Em,LoadType,0,AspRatio,ThickRatio,Pindex,x2,y2]';
% X=[X1];
% X=num2cell(X);

%-------------Maximum Defection-----------------------------------------------------------
ndivl=30;
ndivw=30;
length=Lb;
width=DD;
count=0;
for i = 1:(ndivl+1)
for j = 1:(ndivw+1)
    count=count+1;
x(1,((ndivw+1)*(i-1) +j))= (length/ndivl)*(i-1);
x(2,((ndivw+1)*(i-1) +j))= -(width/ndivw)*(j-1)+width/2;


        Xp(i,j)=x(1,((ndivw+1)*(i-1) +j));
        Yp(i,j)=x(2,((ndivw+1)*(i-1) +j));

         % Layer 1
         X=[Ec/Em,LoadType,0,AspRatio,ThickRatio,Pindex,Xp(i,j),Yp(i,j)]';
         X=num2cell(X);

%------------------------------------------------------------------



% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
  X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
  Q = size(X{1},2); % samples/series
else
  Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS

    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*X{1,ts} + IW1_2*X{2,ts} + IW1_3*X{3,ts} + IW1_4*X{4,ts} + IW1_5*X{5,ts} + IW1_6*X{6,ts} + IW1_7*X{7,ts} + IW1_8*X{8,ts});
    
    % Layer 2
    a2 = tansig_apply(repmat(b2,1,Q) + LW2_1*a1);
    
    % Layer 3
    a3 = tansig_apply(repmat(b3,1,Q) + LW3_2*a2);
    
    % Layer 4
    a4 = tansig_apply(repmat(b4,1,Q) + LW4_3*a3);
    
    % Layer 5
    a5 = repmat(b5,1,Q) + LW5_4*a4;
    
    % Output 1
    Y{1,ts} = a5;
end
Deflections=a5;

% Final Delay States
Xf = cell(8,0);
Af = cell(5,0);

% Format Output Arguments
if ~isCellX
  Y = cell2mat(Y);
end

W0(count)=Deflections;
%----Maximum Deflection
end
end
Max_Deflections=max(abs(W0));
Results(AHP,1)=BCs;
Results(AHP,2)=ThickRatio;
Results(AHP,3)=Pindex;
% end
Results(AHP,BCs+3)=Max_Deflections;

end
end
end
end
end
