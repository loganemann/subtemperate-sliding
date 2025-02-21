%%  Subtemperate Sliding Model: RHS
function rhs = R13_subtemp_RHS(t,X,md)
p=md.parameters;
s=md.scales;
%% Variables
h=X(1);
e=X(2);
Zs=X(3);
Tb=X(4);

% Regularizations
Zs = max([Zs p.Zs_min/s.Zs]); Zs = min([Zs p.Zs_init/s.Zs]);
Tb=min([Tb 1]);
e = max([e 1]); e = min([e 1/s.e]);


%% Diagnostic Variables
% Stress Balane
taud = h^2;
tauy = p.a/s.taud*exp(-p.b*p.ec*(e-1));
if taud>tauy
    taub = tauy;
else
    taub = taud;
end
ub_surge = max(h-tauy/h, 0)^p.n;% * exp(p.Tm*(Tb-1)/p.T_0);
if strcmp(p.slidingLaw,'exp')
    ub_subtemp = p.xi*taub^p.m * exp(p.Tm*(Tb-1)/p.T_0);                            % Exponential Subtemperate Sliding
elseif strcmp(p.slidingLaw,'tanh')
    ub_subtemp = p.xi*taub^p.m * 1/2 * ( 1 + tanh((p.Tm*(Tb-1)-p.T_c)/p.T_0) );     % Tanh subtemperate sliding
end
ub=ub_surge+ub_subtemp;

% Thermal/Hydrology
m = p.beta + p.gamma*(1-p.theta*Tb)/h + taub*ub;
% m = p.beta + p.gamma/h*(p.Ts - p.Tm*Tb)/(p.Tm-p.Ts) + taub*ub;


%% Prognostic Equations
if Zs==p.Zs_min/s.Zs && ( (Tb==1 && m<0) || (Tb<1) )   % Frozen
    dedt=0;
    dZsdt=0;
    dTbdt = m/p.nu;
elseif (e == 1 && Zs==p.Zs_init/s.Zs && m<0) ||  (e == 1 && Zs<p.Zs_init/s.Zs)    %Frozen, Drained
    dedt=0;
    dZsdt = m/p.alpha*s.e;
    dTbdt=0;
else                                                                              % Frozen, undrained
    dedt = 1/p.alpha * m/Zs;
    dZsdt = 0;
    dTbdt = 0;
end

dhdt = 1-(h*ub);

rhs=[dhdt; dedt; dZsdt; dTbdt];

if md.settings.print; disp(['Percent Integration Complete:' num2str(100*t/(md.settings.t_final*p.yearCon/s.t)) '%']); end


end