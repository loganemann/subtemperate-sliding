%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE: Functional Experiments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Logan E. Mann, Thayer School of Engineering, Dartmouth College

% Visualizes supplemental experiments A-D.


%% Experiments
close all
clear
% Curves
    x = linspace(-30,0,1000);
    % exp0 = exp(x/10);
    % exp1 = exp(x/0.1);                      % T_0 = 1;
    % exp2 = exp(x/1.0);
    % tanh1 = 1/2 + 1/2*tanh((x-(-1))/1);     % T_c = -5, T_0 = 1
    % tanh2 = 1/2 + 1/2*tanh((x-(-10))/10);   % T_c = -20, T_0 = 10

    experiment.main = exp(x/1);                  % Main text: T_0 = 1.0
    experiment.A = exp(x/0.1);                   % Experiment A: T_0=0.1
    experiment.B = exp(x/10);                    % Experiment B: T_0 = 10
    experiment.C = 1/2 + 1/2*tanh((x-(-1))/1);     % T_c = -1, T_0 = 1
    experiment.D = 1/2 + 1/2*tanh((x-(-10))/10);   % T_c = -10, T_0 = 10

%% Plotting
    list_factory = fieldnames(get(groot,'factory'));
    index_interpreter = find(contains(list_factory,'Interpreter'));
    for i = 1:length(index_interpreter)
        default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
        set(groot, default_name,'latex');
    end
    figure
    sty = styleGuide();
    sty.LineWidth = 1.5;
    sty.FontSize = 8;
    sty.LabelFontSize = 12;
    tcl = tiledlayout(1,1);
    tcl.TileSpacing = sty.TileSpacing;
    tcl.Padding = sty.Padding;
    
    nexttile(1)
    plot(x, experiment.main, '-k', 'LineWidth', sty.LineWidth)
    hold on
    plot(x, experiment.A, '-', 'Color', [67 169 221]./255, 'LineWidth',  sty.LineWidth)
    plot(x, experiment.B, '-', 'Color', [113 231 224]./255, 'LineWidth', sty.LineWidth)
    plot(x, experiment.C,'-', 'Color', [251 69 112]./255 , 'LineWidth', sty.LineWidth)
    plot(x, experiment.D,'-', 'Color', [251, 141, 160]./255, 'LineWidth', sty.LineWidth)
    xlim([-20 0])
    ylim([0 1])
    
    set(gca,'FontSize',sty.FontSize, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'Box','on')
    l=legend('Main Text: $\ \ \ \ \ g(T_b) = \exp{[(T_b-T_m)/T_0]}$; $T_0 = 10$ $^{\circ}$C',...
        'Experiment A: $g(T_b) = \exp{[(T_b-T_m)/T_0]}$; $T_0 = 1$ $^{\circ}$C',...
        'Experiment B: $g(T_b) = \exp{[(T_b-T_m)/T_0]}$; $T_0 = 10$ $^{\circ}$C',...
        'Experiment C: $g(T_b) = \frac{1}{2} + \frac{1}{2}\tanh{[(T_b - T_m - T_c)/T_b]}$; $T_0 = 1$ $^{\circ}$C, $T_c = -1$ $^{\circ}$C',...
        'Experiment D: $g(T_b) = \frac{1}{2} + \frac{1}{2}\tanh{[(T_b - T_m - T_c)/T_b]}$; $T_0 = 10$ $^{\circ}$C, $T_c = -10$ $^{\circ}$C',...
        'Location','northoutside','Box','off','FontSize',sty.FontSize);
    xlabel('$T_b-T_m$ ($^{\circ}$C)','FontSize',sty.LabelFontSize)
    ylabel('$g(T_b)$','FontSize',sty.LabelFontSize)

    width=5;
    set(gcf,'Units','inches')
    set(gcf,'Position',[4 4 width width/(4/3)]) %Aspect Ratio (3:4)
    % 
    figureName = 'functionalExperiments.pdf';
    exportgraphics(gcf,['./figures/supplement/' figureName],...
        'BackgroundColor', 'none',...
        'ContentType', 'vector');