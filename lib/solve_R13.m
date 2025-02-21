function md = solve_R13(md)
    s=md.scales;
    p = md.parameters;
    
    % Nondimensional Groups
    p.alpha = p.ws/(s.m*s.t);
    p.beta = p.G/(s.ub*s.taub);
    p.gamma = p.ki*p.Ts/(s.h*s.taub*s.ub);
%     p.gamma = p.ki*(p.Tm-p.Ts)/(s.h*s.taub*s.ub);
    p.theta = p.Tm/p.Ts;
    p.nu = p.Tm*p.Ci*p.hb/(s.t*s.taub*s.ub);

    md.parameters=p;
    % Solver
    init = [md.init.h/s.h md.init.e/s.e md.init.Zs/s.Zs md.init.Tb/s.Tb];
    tspan = [0 md.settings.t_final*p.yearCon/s.t];
    [time,soln]=ode113(@(t,X)R13_subtemp_RHS(t,X,md),tspan,init,md.settings.tolerance);
    
    % Prog. Variables
    h=soln(:,1);
    e=soln(:,2);
    e=max([e p.ec.*ones(length(time),1)./s.e]')';
    e=min([e ones(length(time),1)./s.e]')';
    Zs=soln(:,3);
    Tb=soln(:,4);
    
    % Diagnostic Variables
    taud = h.^2;
    tauy = p.a./s.taud.*exp(-p.b.*p.ec.*(e-1));
    taub=zeros(length(time),1); 
    taub(taud>tauy)=tauy(taud>tauy); 
    taub(taud<=tauy)=taud(taud<=tauy);
    
    ub_surge = max(h-tauy./h, zeros(length(time),1)).^p.n;% .* exp(p.Tm.*(Tb-1)/p.T_0) ;
    if strcmp(md.parameters.slidingLaw, 'exp')
        ub_subtemp = p.xi.*taub.^p.m.*exp(p.Tm.*(Tb-1)/p.T_0);
    elseif strcmp(md.parameters.slidingLaw, 'tanh')
        ub_subtemp = p.xi.*taub.^p.m .* 1/2.*(1 + tanh((p.Tm.*(Tb-1) - p.T_c)/p.T_0));
    end
    ub = ub_surge+ub_subtemp;
    
    % Thermal/Hydrology
    m = p.beta + p.gamma.*(1-p.theta.*Tb)./h + taub.*ub;
    w = e.*Zs;


    % out
    md.results.h = h*s.h;
    md.results.time = time*s.t;
    md.results.taud = taud*s.taud;
    md.results.tauy = tauy*s.tauy;
    md.results.taub = taub*s.taub;
    md.results.ub_surge = ub_surge*s.ub;
    md.results.ub_subtemp = ub_subtemp*s.ub;
    md.results.ub = ub*s.ub;
    md.results.m = m*s.m;
    md.results.w = w*s.w;
    md.results.Tb = Tb*s.Tb;



end