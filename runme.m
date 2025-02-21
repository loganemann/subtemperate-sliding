%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subtemperate Sliding Model: Nondimensional Implementaltion, ISSM-like Version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Logan E. Mann, Thayer School of Engineering, Dartmouth College

% R13 box model with subtemperate sliding. Written with a nondimensional 
% implementation, in an ISSM-like syntax.

clear
clc


%% Non-Subtemperate Run
    md = R13;
%% PARAMETERS
    md=parameterize(md);
    md.parameters.xi = 0.00;
    md.parameters.Ts = 273.15-30;
    md.parameters.G = 0.03;

%% INITIAL CONDITIONS
    md = initialize(md);

%% SOLVE
    md = solve_R13(md);
    figure
    plot(md.results.time./md.parameters.yearCon,md.results.h)
    plot(md.results.time./md.parameters.yearCon,md.results.w)

%% PLOTTING

