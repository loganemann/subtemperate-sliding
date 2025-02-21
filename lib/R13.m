function md = R13()
    md = struct('parameters',[],'init',[],'scales',[],'settings',[],'sweep',[]);
    
    % Defaults
    md.settings.print = true;
    md.settings.tolerance = odeset('RelTol',1e-9,'AbsTol',1e-9);
    md.settings.t_final = 3e5;
    md.settings.print = true;
    
    % Parameters
    p.yearCon = 3600*24*365;    %Seconds in a year (s)
    p.a= [];
    p.ac= [];
    p.Ag= [];
    p.b = [];
    p.Ci= [];
    p.ec= [];
    p.g = [];
    p.G = [];
    p.hb= [];
    p.ki= [];
    p.L = [];
    p.Lf= [];
    p.n = [];
    p.Tm= [];
    p.Ts = [];
    p.W = [];
    p.ws= [];
    p.Zs_init= [];
    p.Zs_min=[];
    p.rhoi= [];
    p.rhow= [];
    p.T_0=[];
    p.m = [];
    p.xi = [];
    p.alpha = [];
    p.beta = [];
    p.gamma = [];
    p.theta = [];
    p.nu = [];

    md.parameters=p;
    
    % Initialization
    md.init.h = [];
    md.init.e = [];
    md.init.Zs = [];
    md.init.Tb = [];

    % Scales
    s = [];
    s.h = [];
    s.t = [];
    s.taud = [];
    s.taub = [];
    s.tauy = [];
    s.ub = [];
    s.m = [];
    s.Tb = [];
    s.w=[];
    s.e=[];
    s.Zs=[];

    md.scales = s;
    

    % Sweep
    md.sweep.res = [];
    md.sweep.Ts = [];
    md.sweep.G = [];
    md.sweep.xi = [];
%     md.sweep.results = [];
    md.sweep.save_results = false;
end