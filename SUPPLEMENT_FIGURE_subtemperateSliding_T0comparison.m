%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subtemperate Sliding Model: Nondimensional Implementaltion, ISSM-like Version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc



%% Experiment A: SUBTEMPERATE RUN exp: T_0=0.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mdA = R13;
    %% PARAMETERS
        mdA=parameterize(mdA);
        mdA.parameters.xi = 0.01;
        mdA.parameters.Ts = 273.15-30;
        mdA.parameters.G = 0.03;
        mdA.parameters.T_0 = 0.1;        % Subtemperate Sliding Range (about transitional temperature) [C]
        mdA.parameters.slidingLaw = 'exp';
    
    %% INITIAL CONDITIONS
        mdA = initialize(mdA);
    
    %% SOLVE
        mdA = solve_R13(mdA);

%% Experiment B: SUBTEMPERATE RUN exp: T_0=1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mdB = R13;
    %% PARAMETERS
        mdB=parameterize(mdB);
        mdB.parameters.xi = 0.01;
        mdB.parameters.Ts = 273.15-30;
        mdB.parameters.G = 0.03;
        mdB.parameters.T_0 = 10;        % Subtemperate Sliding Range (about transitional temperature) [C]
        mdB.parameters.slidingLaw = 'exp';
    
    %% INITIAL CONDITIONS
        mdB = initialize(mdB);
    
    %% SOLVE
        mdB = solve_R13(mdB);


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

    %% Experiment A:
        % Subplot 1: h
        s1=nexttile(tcl,1);
            plot(mdA.results.time/mdA.parameters.yearCon/1000, mdA.results.h,'-k','LineWidth',sty.LineWidth)
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
            title('Experiment A: $T_0 = 0.1$ $^{\circ}$C','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'a)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            eventPeriodA = round(period(mdA)/mdA.parameters.yearCon/1000,1);
            text(0.116,0.81,['Event Period $\approx ' num2str(eventPeriodA) '$ kyr'],'Units','Normalized','FontSize',sty.FontSize,'Interpreter','latex')
            anA = annotation('doublearrow');
            anA.X = [0.128472222222222,0.21875];
            anA.Y = [0.817708333333333,0.817708333333333];
            anA.Head1Length = 5;
            anA.Head1Width = 5;
            anA.Head2Length = 5;
            anA.Head2Width = 5;
        % Subplot 3: ub
        s3 = nexttile(tcl,3);
            ub1=mdA.results.ub;
            ub1(mdA.results.ub_surge==0)=0;
            ub2=mdA.results.ub;
            ub2(mdA.results.ub_surge~=0)=0;
            semilogy(mdA.results.time./mdA.parameters.yearCon/1000,ub2.*mdA.parameters.yearCon,'-','Color',[0.5 0.5 0.5],'LineWidth',sty.LineWidth)
            hold on
            semilogy(mdA.results.time./mdA.parameters.yearCon/1000, ub1.*mdA.parameters.yearCon,'k-','LineWidth',sty.LineWidth)
            ylim([10^(-8) 20000])
            set(s3,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XTickLabel',{}, ...
                'YTick',[1e-8 1e-6 1e-4 1e-2 1e0 1e2 1e4],...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'Box','off')
            ylabel('$u_b$ [m/yr]','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'b)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            l1 = legend('Stagnant Phase', 'Surge Phase','FontSize',sty.FontSize,'Orientation','horizontal','Location','south','Box','off');
%             l1.Position  = [0.5938 0.39 0.2946 0.0439];
            l1.Position = [0.091581674781111,0.325,0.311535841888851,0.047222222718928];
        % Subplot 5: w, Tb
        s5 = nexttile(tcl,5);
            colororder({'b','r'})
            yyaxis left
            plot((mdA.results.time)./mdA.parameters.yearCon/1000,mdA.results.w,'-b','LineWidth',sty.LineWidth)
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
            plot(mdA.results.time./mdA.parameters.yearCon/1000,mdA.results.Tb-273.15,'-r','LineWidth',sty.LineWidth)
            set(s5,'YTickLabel',{})
            ylim([-20 2.5])
            
            yyaxis right
            xlabel('time [kyr]','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'c)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)

    %% Experiment B:
        % Subplot 1: h
        s2=nexttile(tcl,2);
            plot(mdB.results.time/mdB.parameters.yearCon/1000, mdB.results.h,'-k','LineWidth',sty.LineWidth)
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
            title('Experiment B: $T_0 = 10$ $^{\circ}$C','FontSize',sty.LabelFontSize)
            text(0.01, 0.9,'d)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            eventPeriodB = round(period(mdB)/mdB.parameters.yearCon/1000,1);
            text(0.06,0.73,['Event Period $\approx ' num2str(eventPeriodB) '$ kyr'],'Units','Normalized','FontSize',sty.FontSize,'Interpreter','latex')
            anB = annotation('doublearrow');
            anB.X = [0.569354166666666,0.637152777777778];
            anB.Y = [0.765680555555555,0.765680555555555];
            anB.Head1Length = 5;
            anB.Head1Width = 5;
            anB.Head2Length = 5;
            anB.Head2Width = 5;
        % Subplot 3: ub
        s4 = nexttile(tcl,4);
            ub1=mdB.results.ub;
            ub1(mdB.results.ub_surge==0)=0;
            ub2=mdB.results.ub;
            ub2(mdB.results.ub_surge~=0)=0;
            semilogy(mdB.results.time./mdB.parameters.yearCon/1000,ub2.*mdB.parameters.yearCon,'-','Color',[0.5 0.5 0.5],'LineWidth',sty.LineWidth)
            hold on
            semilogy(mdB.results.time./mdB.parameters.yearCon/1000, ub1.*mdB.parameters.yearCon,'k-','LineWidth',sty.LineWidth)
            ylim([10^(-8) 20000])
            set(s4,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XTickLabel',{}, ...
                'YTick',[1e-8 1e-6 1e-4 1e-2 1e0 1e2 1e4],...
                'YTickLabel',{}, ...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XLim', [5 60],...
                'Box','off')
            text(0.01, 0.9,'e)','Interpreter','latex','Units','normalized','FontSize',sty.LabelFontSize)
            l2 = legend('Stagnant Phase', 'Surge Phase','FontSize',sty.FontSize,'Orientation','horizontal','Location','south','Box','off');
            l2.Position  = [0.5938 0.325 0.2946 0.0439];
        % Subplot 5: w, Tb
        s6 = nexttile(tcl,6);
            colororder({'b','r'})
            yyaxis left
            plot((mdB.results.time)./mdB.parameters.yearCon/1000,mdB.results.w,'-b','LineWidth',sty.LineWidth)
            ylim([0 1])
            set(s6,'YTickLabel',{})
            hold on
            yyaxis right
            plot(mdB.results.time./mdB.parameters.yearCon/1000,mdB.results.Tb-273.15,'-r','LineWidth',sty.LineWidth)
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
        
        sgtitle('$g(T_b) = \exp{[(T_b-T_m)/T_0]}$','Interpreter','latex','FontSize',sty.LabelFontSize*3/2)

        figureName = 'subtemperateSliding_T0comparison.pdf';
        exportgraphics(gcf,['./figures/supplement/' figureName],...
            'BackgroundColor', 'none',...
            'ContentType', 'vector');