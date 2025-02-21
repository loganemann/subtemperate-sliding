%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURE: Parameter Sweep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Logan E. Mann, Thayer School of Engineering, Dartmouth College



%% SETUP
    clear
    close all
    clc
    
    md = R13();
    


%% SWEEP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PARAMETERS
    md=parameterize(md);
    md.parameters.T_0 = 1;
    p = md.parameters;
    s = md.scales;
    
    % INITIAL CONDITIONS
    md = initialize(md);

    % SWEEP RANGE
    md.sweep.res = 300;
    md.sweep.Ts = linspace(-5,-30,md.sweep.res+1)+md.parameters.Tm;
    md.sweep.xi = linspace(0,0.05,md.sweep.res+1);
    performSweep = false;
    plotting = true;
    if performSweep
        md=sweep(md);
        save('./data/sweep_T-xi_300.mat','md')
    end
%% Hopf Bifurcation
    beta = p.G/(s.taub*s.ub).*ones(length(md.sweep.xi),1);
    gamma = ((p.n+1)/p.n)^(p.n/(p.n+1)) .* beta + ((p.n+1)/p.n)^(2*p.n/(p.n+1))/(p.n+1);
    Ts_boundary = -gamma*s.h*s.taub*s.ub/p.ki + p.Tm;
    hold on

%% PLOTTING
if plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    list_factory = fieldnames(get(groot,'factory'));
    index_interpreter = find(contains(list_factory,'Interpreter'));
    for i = 1:length(index_interpreter)
        default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
        set(groot, default_name,'latex');
    end
    load('./data/sweep_T-xi_300.mat')
    
    close all
    figure
    sty = styleGuide();
    sty.LineWidth = 0.75;
    tcl = tiledlayout(2,1);
    tcl.TileSpacing = sty.TileSpacing;
    tcl.Padding = sty.Padding;
    %% Period
        s1=nexttile(tcl);
            pcolor(md.sweep.xi,md.sweep.Ts-273.15,md.sweep.period/1000/md.parameters.yearCon)
            clim([2 16])
            shading flat
            clr = flipud(cividis(256));
            colormap(s1,clr);
            colorbar
            set(gca,'FontSize',14)
            c1 = colorbar;
            c1.TickLabelInterpreter = 'latex';
            hold on
            plot(md.sweep.xi,Ts_boundary-273.15,':k','LineWidth',2)
            plot([0 0.05], [-13.4 -16.5], ':w', 'LineWidth',2)
            set(s1,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'XTickLabel', {},...
                'Box','on')
            text(0.01, 0.95, 'a)', 'Units', 'normalized','FontSize', sty.LabelFontSize)
            text(0.025, -21, 'Strong Oscillations', 'FontSize', sty.LabelFontSize,'HorizontalAlignment','center')
            text(0.025, -12, 'Weak Oscillations', 'FontSize',sty.LabelFontSize, 'HorizontalAlignment', 'center')
            text(0.025, -7.5, 'Steady Streaming', 'FontSize',sty.LabelFontSize, 'HorizontalAlignment', 'center')
            c1.FontSize = sty.LabelFontSize;
%             xlabel('$\xi$','FontSize', sty.LabelFontSize)
            ylabel('$T_s$','FontSize', sty.LabelFontSize)
            title('\textbf{Event Period (kyr)}', 'FontSize', sty.LabelFontSize)
    %% Plot Period Variation
        % Calculation
        default_P = md.sweep.period(:,1);
        save('./data/default_P.mat','default_P')
        ratio_P = nan(md.sweep.res+1,md.sweep.res+1);
        diff_P = ratio_P;
        percDiff_P = diff_P;
        for i = 1:length(md.sweep.period(1,:))
            ratio_P(:,i) = md.sweep.period(:,i)./default_P;
            diff_P(:,i) = md.sweep.period(:,i)-default_P;
            percDiff_P(:,i) = (md.sweep.period(:,i)-default_P)./default_P*100;
        end
    
        percChange_P = -(1-ratio_P)*100;
        percChange_P(percChange_P>0) = nan;
        diff_P(diff_P>0) = nan;
        percDiff_P(percDiff_P>0) = nan;
        range = [min(min(percDiff_P)) 0];
        
        % Plotting
        s2 = nexttile(tcl);
            pcolor(md.sweep.xi,md.sweep.Ts-273.15,-percDiff_P)
            shading flat
            c2=colorbar;
            clr = inferno(256);
            colormap(s2,clr)
            hold on
            plot(md.sweep.xi,Ts_boundary-273.15,':k','LineWidth',2)
            plot([0 0.05], [-13.4 -16.5], ':w', 'LineWidth',2)
            c2.Ticks = [0 10 20 30 40 50 60];
            c2.TickLabels = {'$0\%$', '$10\%$', '$20\%$', '$30\%$', '$40\%$', '$50\%$', '$60\%$'};
            
            
            set(s2,'FontSize',sty.FontSize, ...
                'LineWidth', sty.LineWidth, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XMinorTick',sty.XMinorTick, ...
                'YMinorTick',sty.YMinorTick,...
                'Box','on')
            text(0.01, 0.95, 'b)', 'Units', 'normalized','FontSize', sty.LabelFontSize)
            text(0.025, -21, 'Strong Oscillations', 'FontSize', sty.LabelFontSize,'HorizontalAlignment','center','Color','w')
            text(0.025, -12, 'Weak Oscillations', 'FontSize',sty.LabelFontSize, 'HorizontalAlignment', 'center','Color','w')
            text(0.025, -7.5, 'Steady Streaming', 'FontSize',sty.LabelFontSize, 'HorizontalAlignment', 'center')
            
            c2.FontSize = sty.LabelFontSize;
            xlabel('$\xi$','FontSize',sty.LabelFontSize)
            ylabel('$T_s$','FontSize',sty.LabelFontSize)
            title('\textbf{\% Decrease in Event Period}', 'FontSize', sty.LabelFontSize)
%% Figure Processing
    width = 6.75;
    set(gcf,'Units','inches')
    set(gcf,'Position',[4 4 width width/(1/1.5)]) %Aspect Ratio (1:2)


    figureName = 'sweep.pdf';
    exportgraphics(gcf,['./figures/' figureName],...
        'BackgroundColor', 'none',...
        'ContentType', 'vector');


end