function time_plot_function(t, y, FigureLabels)

%% TITLE

% Time Plot Function

%% DESCRIPTION

% A plotting function that provides efficiency and consistency when
% plotting multiple figures.

%% EDITORIAL LOG

% 15/02/2018 - Function file created.
% Editors    - E.E

%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2018
% All Rights Reserved

%% INPUTS

% t - Time matrix on the X axis
% y - Specified Y axis parameter
% FigureLabels - A array of text data including Title, X and Y that must
% be filled in by the user to give headings of figures.
%% OUTPUTS

% Plots a figure

%% PLOT
plot((t/3600),y,'LineWidth', 1)

title (FigureLabels.Title, ...
                 'FontName', 'AvantGarde', ...
                 'FontSize', 12, ...
                 'FontWeight', 'bold');

xlabel(FigureLabels.X,...
                    'FontName', 'AvantGarde', ...
                    'FontSize', 10);

ylabel(FigureLabels.Y, ...
                    'FontName', 'AvantGarde', ...
                    'FontSize', 10); 
  
ax = gca; % current axes

grid on
    ax.FontName = 'Helvetica';

    ax.Box = 'off';

    ax.TickDir = 'out';

    ax.TickLength = [.02 .02];

    ax.XMinorTick = 'on';
    
    ax.YMinorTick = 'on';
    
    ax.XColor = 'k';
    
    ax.YColor = 'k';
    
    ax.LineWidth = 1;

end

