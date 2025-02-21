%% SETUP
    clear
    close all
    clc

    plotting = true;
    
load('./data/T_0_sweep.mat')
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
    sty.FontSize = sty.FontSize;
    sty.LabelFontSize = sty.LabelFontSize;
    tcl = tiledlayout(2,5);
    tcl.TileSpacing = sty.TileSpacing;
    tcl.Padding = sty.Padding;
    
    %% Plot Period Variation (pcolor)
    alph= 'abcdefghij';
    for k = 1:length(DATA)
        md = DATA{k};
        % Calculation
        default_P = md.sweep.period(:,1);
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
        s = nexttile(tcl);
            pcolor(md.sweep.xi,md.sweep.Ts-273.15,-percDiff_P)
            clim([0 65])
            shading flat
            clr = inferno(256);
            colormap(s,clr);
            if k == length(DATA)
                
            end
            set(s,'FontSize',sty.FontSize, ...
                'TickDir',sty.TickDir, ...
                'TickLength',sty.TickLength,...
                'XMinorTick',sty.XMinorTick,...
                'YMinorTick',sty.YMinorTick,...
                'Box','on')
            xlabel('$\xi$','FontSize',sty.LabelFontSize)
            ylabel('$T_s$','FontSize',sty.LabelFontSize)
            if k<=5; set(s,'XTickLabel',{}); xlabel([]); end
            if k~=1 && k~=6; set(s,'YTickLabel',{}); ylabel([]); end
            text(0.01,0.92,[alph(k) ')'], 'Units', 'normalized','Interpreter','latex','FontSize',sty.LabelFontSize)
            title(['$T_0 = ' num2str(md.parameters.T_0) '$ $^{\circ}$C'], 'FontSize', sty.LabelFontSize)
    end
    c=colorbar;
    hold on
    c.Ticks = [0 10 20 30 40 50 60];
    c.TickLabels = {'$0\%$', '$10\%$', '$20\%$', '$30\%$' , '$40\%$', '$50\%$', '$60\%$'};
    c.FontSize = sty.LabelFontSize;
    c.Layout.Tile = 'east';

    sgtitle('$\%$ Decrease in Event Period','Interpreter','latex','FontSize',sty.LabelFontSize*(3/2))
%% Figure Processing
    width=16;
    set(gcf,'Units','inches')
    set(gcf,'Position',[4 4 width width/(2.25)]) %Aspect Ratio (1:3)
        
    figureName = 'sweep_T0_comparison.pdf';
    exportgraphics(gcf,['./figures/supplement/' figureName],...
            'BackgroundColor', 'none',...
            'ContentType', 'vector');
    
