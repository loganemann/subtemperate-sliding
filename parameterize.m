%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Default Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Logan E. Mann, Thayer School of Engineering, Dartmouth College

% Default parameters

function md = parameterize(md)
p = md.parameters;
%% Parameterize
    p.yearCon = 3600*24*365;    %Seconds in a year (s)
    p.print=true;      % Print % Integration Complete
    

    % Ice Stream Parameters 
    p.a= 1.41e6;            % Till empirical coefficient (Pa)
    p.ac= 0.1/p.yearCon;      % Accumulation rate (m sec-1)
    p.Ag= 5e-25;    % Glen's law rate factor (Pa-3 s-1)
    p.b = 21.7;     % Till empirical exponent (unitless)
    p.Ci= 1.94e6;   % Volumetric heat capacity of ice (J K-1 m-3)
    p.ec= 0.3;      % Till consolidation threshold (unitless)
    p.g = 9.81;     % Acceleration (s-2)
    p.G = 0.03;
    p.hb= 10;       % Thickness of temperate ice layer (m)
    p.ki= 2.1;      % Thermal conductivity of ice (J s-1 m-1 K-1)
    p.L=500e3;      % Ice Strem trunk length (m)
    p.Lf= 3.35e5;   % Specific latent heat of ice (J kg-1)
    p.n = 3;        % Glen's law exponent (unitless)
    p.Tm= 273.15;    % Melting point of water (K)
    p.Ts = p.Tm - 30;       % Surface Temperature (K)
    p.W = 40e3;       % Ice stream trunk width (m)
    p.ws= 1;        % Till saturation threshold (m)
    p.Zs_init= 1;        % Initial effective till layer thickness (m)
    p.Zs_min=1e-9;   % minimum till thickness
    p.rhoi= 917;      % Ice Density (kg m-3)
    p.rhow= 1028;     % Seawater density (kg m-3)
    
    % Subtemperate Sliding Parameters
    p.T_0=1;                      % Subtemperate Sliding Range(C)
    p.m = 1;                                % Subtemperate sliding exponent
    p.xi = 0;
    p.slidingLaw = 'exp';

%% Scale
    md.parameters=p;
    md = scale(md);
    s=md.scales;




end