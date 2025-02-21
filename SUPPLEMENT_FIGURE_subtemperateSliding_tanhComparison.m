%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subtemperate Sliding Model: Nondimensional Implementaltion, ISSM-like Version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc
% close all
plotting = true;

%% Experiment C: SUBTEMPERATE RUN exp: T_0=1, T_c=-10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mdC = R13;
    %% PARAMETERS
        mdC=parameterize(mdC);
        mdC.parameters.xi = 0.01;
        mdC.parameters.Ts = 273.15-30;
        mdC.parameters.G = 0.03;
        mdC.parameters.T_0 = 1;        % Subtemperate Sliding Range (about transitional temperature) [C]
        mdC.parameters.T_c = -1;
        mdC.parameters.slidingLaw = 'tanh';
    
    %% INITIAL CONDITIONS
        mdC = initialize(mdC);
    
    %% SOLVE
        mdC = solve_R13(mdC);

%% Experiment D: SUBTEMPERATE RUN tanh: T_0=10, T_c = -10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mdD = R13;
    %% PARAMETERS
        mdD=parameterize(mdD);
        mdD.parameters.xi = 0.01;
        mdD.parameters.Ts = 273.15-30;
        mdD.parameters.G = 0.03;
        mdD.parameters.T_0 = 10;        % Subtemperate Sliding Range (about transitional temperature) [C]
        mdD.parameters.T_c = -10;
        mdD.parameters.slidingLaw = 'tanh';
    
    %% INITIAL CONDITIONS
        mdD = initialize(mdD);
    
    %% SOLVE
        mdD = solve_R13(mdD);

%% PLOTTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    list_factory = fieldnames(get(groot,'factory'));
    index_interpreter = find(contains(list_factory,'Interpreter'));
    for i = 1:length(index_interpreter)
        default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
        set(groot, default_name,'latex');
    end
    close all
    figure
    sty = styleGuide();
    sty.LineWidth = 0.75;
    tcl = tiledlayout(3,2);
    tcl.TileSpacing = sty.TileSpacing;
    tcl.Padding = sty.Padding;
%     sg=sgtitle('$g(T_b) = \frac{1}{2} + \frac{1}{2}\tanh{(\frac{T_b - T_m - T_c}{T_0})}$','FontSize',sty.LabelFontSize+4,'Interpreter','latex')

    %% Experiment C:
        % Subplot 1: h
        s1=nexttile(tcl,1);
            plot(mdC.results.time/mdC.parameters.yearCon/1000, mdC.results.h,'-k','LineWidth',sty.LineWidth)
            set(s1,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XTickLabel',{}, ...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'YLim', [500 2900],...
                'Box','off')
%             title('$g(T_b) = \exp{\frac{T_b-T_m}{T_0}}$, $T_0 = 1$','FontSize',sty.LabelFontSize)
            ylabel('$h$ [m]','FontSize',sty.LabelFontSize)
            title(['Experiment C: $T_0 =' num2str(mdC.parameters.T_0) '$ $^{\circ}$C, $T_c = ' num2str(mdC.parameters.T_c) '$ $^{\circ}$C'],'FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'a)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            eventPeriodC = round(period(mdC)/mdC.parameters.yearCon/1000,1);
            text(0.07,0.72,['Event Period $\approx ' num2str(eventPeriodC) '$ kyr'],'Units','Normalized','FontSize',sty.FontSize,'Interpreter','latex')
            anC = annotation('doublearrow');
            anC.X = [0.128472222222222,0.201388888888889];
            anC.Y = [0.7257 0.7257];
            anC.Head1Length = 5;
            anC.Head1Width = 5;
            anC.Head2Length = 5;
            anC.Head2Width = 5;
        % Subplot 3: ub
        s3 = nexttile(tcl,3);
            ub1=mdC.results.ub;
            ub1(mdC.results.ub_surge==0)=0;
            ub2=mdC.results.ub;
            ub2(mdC.results.ub_surge~=0)=0;
            semilogy(mdC.results.time./mdC.parameters.yearCon/1000,ub2.*mdC.parameters.yearCon,'-','Color',[0.5 0.5 0.5],'LineWidth',sty.LineWidth)
            hold on
            semilogy(mdC.results.time./mdC.parameters.yearCon/1000, ub1.*mdC.parameters.yearCon,'k-','LineWidth',sty.LineWidth)
            ylim([10^(-6) 20000])
            set(s3,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XTickLabel',{}, ...
                'YTick',[1e-6 1e-4 1e-2 1e0 1e2 1e4],...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'Box','off')
            ylabel('$u_b$ [m/yr]','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'b)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            l1 = legend('Stagnant Phase', 'Surge Phase','FontSize',sty.FontSize,'Orientation','horizontal','Location','south','Box','off');
            l1.Position = [0.091581674781111,0.313,0.311535841888851,0.047222222718928];
        s5 = nexttile(tcl,5);
            colororder({'b','r'})
            yyaxis left
            plot((mdC.results.time)./mdC.parameters.yearCon/1000,mdC.results.w,'-b','LineWidth',sty.LineWidth)
            set(s5,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'Box','off')
            ylabel('$w$ [m]', 'FontSize', sty.LabelFontSize)
            ylim([0 1])
            hold on
            yyaxis right
            plot(mdC.results.time./mdC.parameters.yearCon/1000,mdC.results.Tb-273.15,'-r','LineWidth',sty.LineWidth)
            set(s5,'YTickLabel',{})
            ylim([-20 2.5])
            
            yyaxis right
            xlabel('time [kyr]','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'c)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)

    %% Experiment D:
        % Subplot 1: h
        s2=nexttile(tcl,2);
            plot(mdD.results.time/mdD.parameters.yearCon/1000, mdD.results.h,'-k','LineWidth',sty.LineWidth)
            set(s2,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XTickLabel',{}, ...
                'YTickLabel',{}, ...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'YLim', [500 2900],...
                'Box','off')
%             title('$g(T_b) = \exp{\frac{T_b-T_m}{T_0}}$, $T_0 = 1$','FontSize',sty.LabelFontSize)
            title('Experiment D: $T_0 = 10$ $^{\circ}$C, $T_c = -10$ $^{\circ}$C','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'d)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            eventPeriodD = round(period(mdD)/mdD.parameters.yearCon/1000,1);
            text(0.06,0.65,['Event Period $\approx ' num2str(eventPeriodD) '$ kyr'],'Units','Normalized','FontSize',sty.FontSize,'Interpreter','latex')
            anD = annotation('doublearrow');
            anD.X = [0.587 0.651];
            anD.Y = [0.705 0.705];
            anD.Head1Length = 5;
            anD.Head1Width = 5;
            anD.Head2Length = 5;
            anD.Head2Width = 5;
        % Subplot 3: ub
        s4 = nexttile(tcl,4);
            ub1=mdD.results.ub;
            ub1(mdD.results.ub_surge==0)=0;
            ub2=mdD.results.ub;
            ub2(mdD.results.ub_surge~=0)=0;
            semilogy(mdD.results.time./mdD.parameters.yearCon/1000,ub2.*mdD.parameters.yearCon,'-','Color',[0.5 0.5 0.5],'LineWidth',sty.LineWidth)
            hold on
            semilogy(mdD.results.time./mdD.parameters.yearCon/1000, ub1.*mdD.parameters.yearCon,'k-','LineWidth',sty.LineWidth)
            ylim([10^(-6) 20000])
            set(s4,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XTickLabel',{}, ...
                'YTick',[1e-6 1e-4 1e-2 1e0 1e2 1e4],...
                'YTickLabel',{}, ...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'Box','off')
            text(0.01, 0.9,'e)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            l2 = legend('Stagnant Phase', 'Surge Phase','FontSize',sty.FontSize,'Orientation','horizontal','Location','south','Box','off');
            l2.Position  = [0.5938 0.313 0.2946 0.0439];
        % Subplot 5: w, Tb
        s6 = nexttile(tcl,6);
            colororder({'b','r'})
            yyaxis left
            plot((mdD.results.time)./mdD.parameters.yearCon/1000,mdD.results.w,'-b','LineWidth',sty.LineWidth)
            ylim([0 1])
            set(s6,'YTickLabel',{})
            hold on
            yyaxis right
            plot(mdD.results.time./mdD.parameters.yearCon/1000,mdD.results.Tb-273.15,'-r','LineWidth',sty.LineWidth)
            ylim([-20 2.5])
            set(s6,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'Box','off')
            yyaxis right
            xlabel('time [kyr]','FontSize',sty.LabelFontSize)
            ylabel('$T_b$ [$^{\circ}$ C]','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'f)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
    
    %% Figure Formatting/Export
        width=16;
        set(gcf,'Units','inches')
        set(gcf,'Position',[4 4 width width/(2/1)]) %Aspect Ratio (3:4)
        sgtitle('$g(T_b) = \frac{1}{2} + \frac{1}{2}\tanh{\left[\frac{T_b - T_m - T_c}{T_0}\right]}$','Interpreter','latex','FontSize',sty.LabelFontSize*3/2)

        figureName = 'subtemperateSliding_tanhComparison.pdf';
        exportgraphics(gcf,['./figures/supplement/' figureName],...
            'BackgroundColor', 'none',...
            'ContentType', 'vector');