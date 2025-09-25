
function [cost, ymodel,sol] = sizeGaNPfit(theta,tspan)
% Updated 9/25/2025

% ASSUMPTIONS
% S cells are very close to 2N levels, and cluster efficiently (4Cs)
% L clones are much slower, but can compete over time (4Cl)
% 4Cs cells are a bit less restricted now, and can match 2N2C cells
% When 4Cs cells divide asymmetrically, they make a 4N2Cs population

% inits
% Data from Baudoin et al., 2020
% We assume at day zero there are no 4N 2C small cells in order to solve
A = [  0     1      0      0         1           1        1;  % EC_tot
       1     1      0      0         0           0        0;  % 2N_tot
       0     0      1      1         1           1        0;  % 4N_tot
       0     0      0      0         0           0        1;  % NP_init
       0     0      0      1         0           0        0;  % 4n2cs_init
       0     1      0      0         0           0        0;  % 2n4c_init
       0     0      0      0  theta(18)   theta(18)-1     0]; % Small_frac 

b = [0.9004; 0.094117647; 1-0.094117647-0.070588235; 0.070588235; 0; 0.02*0.094117647; 0];

y0 = A\b;

times = [tspan(1), tspan(end)];

% cent data
% From Baudoin et al., 2020
ydata = [1-0.9004, 0.9004;
         1-0.485,  0.485;
         1-0.4079, 0.4079;
         1-0.3165, 0.3165;
         1-0.26,   0.26;
         1-0.202,  0.202;
         1-0.1625, 0.1625];

try
    sol = ode15s(@(t,y)sizeModelFitted(t,y,theta),times,y0);
    Cdat = deval(sol,tspan)'; % at t= tspan only for cost function
    ymodel = [Cdat(:,1)+Cdat(:,3)+Cdat(:,4), Cdat(:,2)+Cdat(:,5)+Cdat(:,6)+Cdat(:,7)]; % can't resolve 4C + SC in vitro
    cost = sum((ymodel(:) - ydata(:)).^2);
    
    % ensure 2N cell fraction matches ploidy data in Baudoin et al., 2020
    if Cdat(end,1) + Cdat(end,2) > 0.32
        cost = cost + ((Cdat(end,1)+Cdat(end,2)) - 0.32);
    elseif Cdat(end,1) + Cdat(end,2) < 0.25
        cost = cost + (0.25 - (Cdat(end,1)+Cdat(end,2)));
    end
    
catch
    cost = 10e4;
    % If ode solution fails, make a large cost to punish that param set
end
end

function dydt = sizeModelFitted(t,y,theta)

% ODE functions in fractional form
b2n2c = theta(1); b2n4c = theta(2); b4n2cs = theta(3); b4n2cl = theta(4);
b4n4c = theta(5); b4nSC = theta(6); d2n2c = theta(7); d2n4c = theta(8);
d4n2cs = theta(9); d4n2cl = theta(10); d4n4c = theta(11); 
d4nSC = theta(12); dNP = theta(13); pBi = theta(14); pSym = theta(15);
pCyto = theta(16); pOver = theta(17); pSC = theta(18); pSCsym = theta(19);

% 2n2c, 2n4c, 4n2cs, 4n2cl, 4n4c, 4nsc, np
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

dydt = P*y - sum(P*y)*y;

end
