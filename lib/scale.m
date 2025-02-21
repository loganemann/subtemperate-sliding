function md = scale(md)
    s = md.scales;
    p = md.parameters;
    s.h = p.L*((p.Ag*p.W^(p.n+1)*(p.rhoi*p.g)^p.n)/(4^p.n*(p.n+1)*p.ac))^(-1/(p.n+1));
    s.t = s.h/p.ac;
    s.taud = p.rhoi*p.g*s.h^2/p.L;
    s.taub = s.taud;
    s.tauy = s.taud;
    s.ub = p.ac*p.L/s.h;
    s.m = s.ub*s.taub/(p.rhoi*p.Lf);
    s.Tb = p.Tm;
    s.w=p.ws;
    s.e=p.ec;
    s.Zs=s.w/s.e;
    
    md.scales = s;
end