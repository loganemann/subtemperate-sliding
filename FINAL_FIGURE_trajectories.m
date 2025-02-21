%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE: Trajectories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Logan E. Mann, Thayer School of Engineering, Dartmouth College

% Depicts the thermal-temporal `trajectories'.

clear
clc
close all


%% 1)
    md = R13;
    %% PARAMETERS
        md=parameterize(md);
        md.parameters.xi = 0.01;
        md.parameters.Ts = 273.15-30;
        md.parameters.G = 0.03;
        md.parameters.T_0 = 0.1;
    
    %% INITIAL CONDITIONS
        md = initialize(md);
    
    %% SOLVE
        md = solve_R13(md);
    
%% 2)    
    md2 = R13;
    %% PARAMETERS
        md2=parameterize(md2);
        md2.parameters.xi = 0.01;
        md2.parameters.Ts = 273.15-30;
        md2.parameters.G = 0.03;
        md2.parameters.T_0 = 1;
    
    %% INITIAL CONDITIONS
        md2 = initialize(md2);
    
    %% SOLVE
        md2 = solve_R13(md2);
        md(2) = md2;
%% 3)    
    md3 = R13;
    %% PARAMETERS
        md3=parameterize(md3);
        md3.parameters.xi = 0.01;
        md3.parameters.Ts = 273.15-30;
        md3.parameters.G = 0.03;
        md3.parameters.T_0 = 2;
    %% INITIAL CONDITIONS
        md3 = initialize(md3);
    
    %% SOLVE
        md3 = solve_R13(md3);
        md(3) = md3;
%% 4)    
    md4 = R13;
    %% PARAMETERS
        md4=parameterize(md4);
        md4.parameters.xi = 0.01;
        md4.parameters.Ts = 273.15-30;
        md4.parameters.G = 0.03;
        md4.parameters.T_0 = 3;
    
    %% INITIAL CONDITIONS
        md4 = initialize(md4);
    
    %% SOLVE
        md4 = solve_R13(md4);
        md(4) = md4;
%% PLOTTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
    list_factory = fieldnames(get(groot,'factory'));
    index_interpreter = find(contains(list_factory,'Interpreter'));
    for i = 1:length(index_interpreter)
        default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
        set(groot, default_name,'latex');
    end

    yearCon = md(1).parameters.yearCon;
    figure
    

    sty = styleGuide();
    sty.LineWidth = 1.5;
    sty.clr = {'#fecc5c';...            % From https://colorbrewer2.org/#type=sequential&scheme=YlOrRd&n=5
                '#fd8d3c';...
                '#f03b20';...
                '#bd0026'};

    tcl = tiledlayout(2,1);
    tcl.TileSpacing = sty.TileSpacing;
    tcl.Padding = sty.Padding;
    
    for i = length(md):-1:1
        startMask = md(i).results.time/yearCon/1000>7 & md(i).results.time/yearCon/1000<19;
        h_cutoff = md(i).results.h(startMask);
        h_min = min(h_cutoff);
        md(i).start = find(md(i).results.h==h_min);
        t_fromStart = md(i).results.time(md(i).start:end) - md(i).results.time(md(i).start);
        h_fromStart = md(i).results.h(md(i).start:end);
        Tb_fromStart = md(i).results.Tb(md(i).start:end);
        ub_fromStart = md(i).results.ub(md(i).start:end);
        

        endMask = t_fromStart/yearCon/1000<17;
        t = t_fromStart(endMask);
        h = h_fromStart(endMask);
        Tb = Tb_fromStart(endMask);
        ub = ub_fromStart(endMask);
        
        stop = find(h==min(h(10:end)));
        t = t(1:stop);
        h = h(1:stop);
        Tb = Tb(1:stop);
        ub = ub(1:stop);
        
        s1 = nexttile(1);
        semilogy(t/yearCon/1000, ub*yearCon, 'LineWidth', sty.LineWidth, 'Color', sty.clr{end+1-i})
        hold on
        set(s1,'FontSize',sty.FontSize, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'YTick', [1e-2 1e0 1e2 1e4],...
                'XTickLabel',{}, ...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick','on')
        ylabel('$u_b$ (m yr$^{-1}$)','FontSize',sty.LabelFontSize)
        xlim([5 14])
        ylim([1e-2 1e4])
        
        s2 = nexttile(2);
        plot(t/yearCon/1000, Tb-273.15, 'LineWidth', sty.LineWidth, 'Color', sty.clr{end+1-i})
        hold on
        set(s2,'FontSize',sty.FontSize, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick)
        ylabel('$T_b$ ($^{\circ}$C)','FontSize',sty.LabelFontSize)
        xlabel('time since stagnation (kyr)','FontSize',sty.LabelFontSize)
        xlim([5 14])
        ylim([-11 0.0])
        
    end
    leg = legend(fliplr({'0.1', '1.0', '2.0', '3.0'}));
    ti = title(leg,'Premelting Temp. Range, $T_0$ ($^{\circ}$C):', 'FontSize', sty.LabelFontSize);
    set(leg, 'Location', 'southeast',...
        'FontSize', sty.LabelFontSize,...
        'Orientation','horizontal',...
        'Box', 'off',...
        'Position', [0.3167 0.1500 0.6140 0.1502])

    text(s1,0.01,0.9,'a)','Units','normalized','FontSize',sty.LabelFontSize)
    text(s2,0.01,0.9,'b)','Units','normalized','FontSize',sty.LabelFontSize)

    
    % width=5.1;
    width = sty.Width;
    set(gcf,'Units','inches')
    set(gcf,'Position',[4 4 width width/(1.75/1)]) %Aspect Ratio (1:1.5)

    figureName = 'trajectories.pdf';
            exportgraphics(gcf,['./figures/' figureName],...
                'BackgroundColor', 'none',...
                'ContentType', 'vector');

