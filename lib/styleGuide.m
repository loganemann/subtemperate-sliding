% Creates a standard style guide for figures
function sty = styleGuide()
%     sty.clr = colorSchemes();
    
    sty.Marker = 'o';
    sty.Line = '-';
    sty.MarkerSize = 1.5;
    sty.LineWidth = 1.5;
    sty.ScatterSize = 1.5;

    sty.FontSize = 12;
    sty.LabelFontSize = 18;
    
    sty.TickDir = 'out';
    sty.TickLength = [0.005 0.005];
    sty.XMinorTick = 'off';
    sty.YMinorTick = 'off';

    sty.Width = 7;
    sty.Width2 = 13.75;

    sty.TileSpacing = 'compact';
    sty.Padding = 'compact';




end