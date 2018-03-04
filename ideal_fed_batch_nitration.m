%% TITLE

% ideal fed batch Nitration Reaction Main Script

%% DESCRIPTION

% The main script acts as a platform which calls all function files,
% launches the DAE solver, and contains plotting functions for various
% outputs.

%% EDITORIAL LOG

% 09/11/2017 - Function file creation and manual import of data
% Editors    - E.E, P.S & E.H

% 22/11/2017 - Data value checked to keep units consistent.
%              Standard units are now kJ, moles, kg, K and m^3.
% Editors    - E.E

% 05/12/2017 - Script comment update: Addition of reaction equations, and
%              added detail and formatting to all sections.
% Editors    - E.E

% 31/01/2018 - Called newly created ControllerSystem script file. Renamed
%              relevant cooler propeties to controller properties.
% Editors    - E.H & R.S 

% 15/02/2018 - Introduced new plot function 'time_plot_function' used to
%              improve the readability of the script
% Editors    - E.E 
%% REFERENCES 

% ref. Kinetic Modeling of Nitration of Glycerol (E. Astuti et al. 2014)

%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2018
% All Rights Reserved

%% FUNCTION CALLS
%
% config_chemicals
% config_nitration
% feeding_system
% config_reactor_cstr
% config_cooling_system
% config_controller_settings
% config_level_control
% time_plot_function

close all;
clear all;

%% Set simulation options
%

hour = 3600;

SimulationTime =12 * hour;


%% SPECIFY CHEMICAL SPECIES
% See onfig_temperature_control_system DESCRIPTION

TemperatureControl = config_temperature_control_system(hour);

%% SPECIFY CHEMICAL SPECIES
% See config_chemicals DESCRIPTION

Chemicals = config_chemicals;

 
%% SPECIFY NITRATION REACTION
% See config_nitration DESCRIPTION

Nitration = config_nitration;

%% SPECIFIY FEEDING SYSTEM
% See feeding_system DESCRIPTION

Feed = feeding_system(Chemicals, hour,TemperatureControl);


%% SPECIFY REACTOR INITIAL CONDITIONS
% See config_reactor_cstr DESCRIPTION

Reactor = config_reactor_fed_batch(Chemicals,TemperatureControl);
                                    
%% SET INTEGRATOR TIME SPAN
% Specifies the time span over which the DAE solver operates and orders the
% time span chronologically removing any duplicate values

IntegrationTimeSpan = [0, SimulationTime];

IntegrationTimeSpan = [IntegrationTimeSpan Feed.Time];

IntegrationTimeSpan = [IntegrationTimeSpan TemperatureControl.Time];
 
IntegrationTimeSpan = sort(IntegrationTimeSpan);

IntegrationTimeSpan = unique(IntegrationTimeSpan);



%% SET INITIAL CONDITIONS FOR INTEGRATOR
% Specifies a vector of initial y values (y0) for the integrator. These
% values are called from multiple function scripts, relative to the
% parameter in question.

y0 = [Reactor.InitialMoles; ...
      Reactor.InitialTemperature; ...
      TemperatureControl.InitialCoolantTemperature; ...
      TemperatureControl.InitialCoolantFlow; ...
      Reactor.InitialVolume; ...
      TemperatureControl.InitialReactionHeat; ...
      Reactor.InitialConversion; ...
      Reactor.InitialSelectivity; ...
      Reactor.InitialYield; ...
      TemperatureControl.InitialIntegralError];


 
%% SET OPTIONS FOR DAE SOLVER
% Specifies the relative tolerance for the solver as well as specifying
% which outputs are differrential and algebraic through the 'Mass' matrix.
% the 'NonNegative' constraint has been removed as ode15s does not abide by
% this constraint.

options = odeset ('RelTol', 1e-6,'Mass',diag([1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 1]));
              
           
   
 %% INTEGRATE USING ODE 23t
 % The 'find' and 'isempty' comands dictate when a feed change should be implemented based
 % on the prameters outlined in the function file 'feeding_system'
 % The ode15s comand has inputs of the DAE script and other relavent
 % function files

for j = 1:length(IntegrationTimeSpan)-1

 index = find(Feed.Time == IntegrationTimeSpan(j));
 index_2 = find(TemperatureControl.Time == IntegrationTimeSpan(j));
if isempty(index) == 0
     Feed.CurrentMolarFlow = Feed.MolarFlow(:,index);
end

if isempty(index_2) == 0
    TemperatureControl.CurrentReactorSetPoint = TemperatureControl.ReactorSetPoint(:,index_2);
    
end

[tSection, ySection]  = ode23t (@dae_ideal_fed_batch_nitration, ...
                [IntegrationTimeSpan(j) IntegrationTimeSpan(j+1)], ...
                y0, ...
                options, ...
                Chemicals, ...
                Nitration, ...
                Reactor, ...
                TemperatureControl, ...
                Feed);
            
%% Concatenate output of each call to the ode solver 

     if j == 1
        
        t = tSection;
        y = ySection;
                
    else
        
        t = [t; tSection(2:end)];
        y = [y; ySection(2:end,:)];
                
     end
    
   
        y0 = ySection(end,:);
    
end

%% PLOTTING OF RESULTS

% Plotting relevant parameters in order for performance and control
% analysis. A plot function was used to increase code readability and
% figure consistency.

%% COMPOSITION PROFILES

% This figure shows the molar amounts of each species at time t

% PLOT MOLAR AMOUNTS OF SPECIES
figure(1);
FigureLabels.Title = 'Reactor Composition Profile (Ideal Fed-Batch)';
FigureLabels.X = 'Time (hours)';
FigureLabels.Y = 'Moles of Species (mol)';

time_plot_function(t,y(:,1),FigureLabels)
hold on
time_plot_function(t,y(:,3:Chemicals.Num),FigureLabels)

legend('H20','HNO3','G','1-MNG','2-MNG','1,2-DNG','1,3-DNG','TNG','Location','eastoutside');
hold off

%% REACTOR TEMPERATURE

% The line for reactor setpoint temperature is created through to points at
% the minimum and maximum time values

SP = plot_setpoint_axis_values(t, TemperatureControl);


% PLOT REACTOR TEMPERATURE AND SET POINT
figure(2);
subplot(2,1,1);

FigureLabels.Title = 'Reactor Temperature Profile (Ideal Fed-Batch)';
FigureLabels.X = 'Time (hours)';
FigureLabels.Y = 'Temperature (K)';

time_plot_function(t,y(:, Chemicals.Num + 1),FigureLabels)
hold on
time_plot_function(SP.t,SP.y,FigureLabels)

legend('Temperature','Setpoint');

% PLOT COOLANT TEMPERATURE
subplot(2,1,2);
yyaxis left

FigureLabels.Title = 'Cooling System: Temperature and Flowrate (Ideal Fed-Batch)';
FigureLabels.X = 'Time (hours)';
FigureLabels.Y = 'Temperature (K)';

time_plot_function(t,y(:, Chemicals.Num + 2),FigureLabels)
hold on

% PLOT COOLANT FLOWRATE
yyaxis right

FigureLabels.Y = 'Flowrate (kg/s)';

time_plot_function(t,y(:, Chemicals.Num + 3),FigureLabels)


ylabel('Flowrate (kg/s)', ...
      'FontName', 'AvantGarde', ...
      'FontSize', 10); 

legend('Jacket Temperature','Coolant Flowrate');
hold off

%% CONVERSION, YIELD AND SELECTIVITY

% Performance profiles were created by calculating conversion, yield and
% selectivity as an algebraic output and plotting them with respect to
% time.

% PLOT CONVERSION
figure(3)
subplot(3,1,1);

FigureLabels.Title = 'Conversion of Glycerol in Fed-Batch(Ideal Effluent)';
FigureLabels.X = 'Time (hours)';
FigureLabels.Y = 'Conversion (%)';

time_plot_function(t,y(:, Chemicals.Num + 6),FigureLabels)

% PLOT YIELD
subplot(3,1,2);

FigureLabels.Title = 'Yield of TNG in Fed-Batch(Ideal Effluent)';
FigureLabels.X = 'Time (hours)';
FigureLabels.Y = 'Yield (%)';

time_plot_function(t,y(:, Chemicals.Num + 8),FigureLabels)

% PLOT SELECTIVITY
subplot(3,1,3);

FigureLabels.Title = 'Selectivity of TNG in Fed-Batch(Ideal Effluent)';
FigureLabels.X = 'Time (hours)';
FigureLabels.Y = 'Selectivity)';

time_plot_function(t,y(:, Chemicals.Num + 7),FigureLabels)



    
