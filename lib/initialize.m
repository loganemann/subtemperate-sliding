function md = initialize(md)
% s = md.scales;
% Defaults
%     init=[700/s.h .6/s.e 1/s.Zs 273.15/s.Tb];
    md.init.h = 700;
    md.init.e = 0.6;
    md.init.Zs = 1;
    md.init.Tb = 273.15; 
end