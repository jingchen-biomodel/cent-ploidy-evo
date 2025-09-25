
% sensitivityModelSize()
% By Nicholas Keen
% Last Update: 9/25/2025

function result = sensitivityModelSize(par)

result = zeros(1,2);
% 1: time @ 50% between IC and SS; i.e., IC: 90%, SS: 30%, time @ 60% ECs
% 2: ss frac w/ ECs

%% Set-Up ODE model for parameter set
tfin = 50;
tspan = [0 tfin];

A = [  0     1      0      0         1           1        1;  % EC_tot
       1     1      0      0         0           0        0;  % 2N_tot
       0     0      1      1         1           1        0;  % 4N_tot
       0     0      0      0         0           0        1;  % NP_init
       0     0      0      1         0           0        0;  % 4n2cs_init
       0     1      0      0         0           0        0;  % 2n4c_init
       0     0      0      0   par.pSC   par.pSC-1        0]; % SC_frac 

b = [0.9004; 0.094117647; 1-0.094117647-0.070588235; 0.070588235; 0; 0.02*0.094117647; 0];

y0 = A\b;

%% Parameter Matrix

b2n2c = par.b2n2c; b2n4c = par.b2n4c; b4n2cs = par.b4n2cs;
b4n2cl = par.b4n2cl; b4n4c = par.b4n4c; b4nSC = par.b4nSC;
d2n2c = par.d2n2c; d2n4c = par.d2n4c; d4n2cs = par.d4n2cs;
d4n2cl = par.d4n2cl; d4n4c = par.d4n4c; d4nSC = par.d4nSC; dNP = par.dNP;
pBi = par.pBi; pSym = par.pSym; pCyto = par.pCyto; pOver = par.pOver;
pSC = par.pSC; pSCsym = par.pSCsym;

P = zeros(7);
P(1,1) = b2n2c*(2*(1-pCyto-pOver)-1)-d2n2c;
P(1,2) = b2n4c*(1-pCyto-pOver)*pBi*(1-pSym);
P(2,1) = b2n2c*2*pOver;
P(2,2) = b2n4c*(2*(1-pCyto-pOver)*pBi*pSym-1)-d2n4c;
P(3,3) = b4n2cs*(2*(1-pCyto-pOver)-1)-d4n2cs;
P(3,6) = b4nSC*(1-pCyto-pOver)*(1-pSCsym);
P(4,4) = b4n2cl*(2*(1-pCyto-pOver)-1)-d4n2cl;
P(4,5) = b4n4c*(1-pCyto-pOver)*pBi*(1-pSym);
P(5,1) = b2n2c*pCyto*(1-pSC);
P(5,4) = b4n2cl*2*pOver;
P(5,5) = b4n4c*(2*(1-pCyto-pOver)*pBi*pSym-1)-d4n4c;
P(6,1) = b2n2c*pCyto*pSC;
P(6,4) = b4n2cs*2*pOver;
P(6,6) = b4nSC*(2*(1-pCyto-pOver)*pSCsym-1)-d4nSC;
P(7,2) = b2n4c*(2*pOver+pCyto+(1-pCyto-pOver)*pBi*(1-pSym));
P(7,3) = b4n2cs*pCyto;
P(7,4) = b4n2cl*pCyto;
P(7,5) = b4n4c*(2*pOver+pCyto+(1-pCyto-pOver)*pBi*(1-pSym));
P(7,6) = b4nSC*(2*pOver+pCyto+(1-pCyto-pOver)*(1-pSCsym));
P(7,7) = -dNP;

% ss frac: eigenvec associated w/ largest eigenvalue of P-matrix
[V,D] = eig(P);
[Dmaxs,~] = max(real(D)); %What is the max eigenvalue?
[~,Dj] = max(Dmaxs);
maxvec = V(:,Dj); % corresponding eigenvector
normvec = maxvec./sum(maxvec(1:end));

%% Solve ODE System
options = odeset('Events',@(t,y)halfFracEC(t,y,y0,normvec)); % passage at 10e10 and check for 50% ECs
% Solve
sol = ode15s(@(t,y)PloidyModel(t,y,P),tspan,y0,options);

%% Figure to check cell population trajectories and 50% EC event
% commented out for lower computational cost
% figure()
% plot(sol.x, sol.y(2,:)+sol.y(4,:)+sol.y(5,:));
% hold on;
% plot(sol.xe(1), sum(sol.ye([2 4 5 6]),1),'ro');
% xlim([0 12])
% xlabel('time (d)');
% ylabel('Fraction of population');

%% Calculate results for Sensitivity Analysis

% steady state EC fraction (result 2)
result(2) = normvec(2)+normvec(5)+normvec(6)+normvec(7);

% EC frac time @ half-life (result 1)
try
    result(1) = sol.xe(1); % find first event, use its x-location
catch
    result(1) = tfin;
    fprintf('Catch triggered \n')
    disp(par)
end
end

%% ODE Function (Ploidy Model)

function dydt = PloidyModel(t,y,P)
dydt = P*y - sum(P*y)*y;
end

%% Event Functions (Passage & Half-Life)

function [position,isterminal,direction] = halfFracEC(t,y,y0,normvec)
position = (y(2)+y(5)+y(6)+y(7)) - ((normvec(2)+normvec(5)+normvec(6)+normvec(7))+(y0(2)+y0(5)+y0(6)+y0(7)))/2; % Half-life reached
isterminal = 1; % (can change)
direction = 0;
end
