%% TITLE

% Temperature Control System

%% DESCRIPTION

% A function that provides cooling and heating parameters to the DAE script


%% EDITORIAL LOG

% 21/02/2018 - Function rewritten to include heating capabilities and
%              eliminated reactor jacket parameters, which were migrate to
%              config_reactor in order to tidy up the fuction and make it more modular.
% Editors    - P.S

% 06/12/2017 - Function creation and parameter evaluation
% Editors    - P.S

% 31/01/2018 - Seperated process controller properties into a separate
%              script file
% Editors    - E.H & R.S 

%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2017
% All Rights Reserved

%% INPUTS

% Hour


%% OUTPUTS

% Function outputs consist of:

% HANDLE                                      PROPERTY                                               UNITS         
% TemperatureControl.UA                       Heat transfer coefficient                              J / K


function [TemperatureControl] = config_temperature_control_system(hour)

%% Set Point Set-Up

% Parameters for stepoint temperatures, timings and number of changes for
% control system. 

TemperatureControl.NumChanges = 2;

TemperatureControl.Time = [0 8] * hour;

TemperatureControl.ReactorSetPoint = [293.15 293.15];
                                    
%% Cooling media properties - type of liquid, temperature and limits

% Cooling media is set at - 10 degrees C and is chosen to be 65 % glycol solution

% Parameters are taken from https://www.engineeringtoolbox.com/ethylene-glycol-d_146.html

TemperatureControl.CoolantTemperature = 263.15 ;

TemperatureControl.CoolantSpecificHeat = 4.2;

TemperatureControl.CoolantDensity = 1113;

TemperatureControl.CoolingFlowMaximumLimit = 2 ;

TemperatureControl.CoolingFlowMinimumLimit = 0 ;

%% Controller parameters 

TemperatureControl.PGain = 1.7;

TemperatureControl.IGain = -0.0008;

%% Heating System

% In case of heating to be offline - a value of 0 is used to avoid
% cluttering with on/off funtions and variables

TemperatureControl.HeatingOutput = 75;                 %kW


%% Initial Conditions For Temperature Control System 

TemperatureControl.InitialCoolantTemperature = TemperatureControl.ReactorSetPoint(1);

TemperatureControl.InitialCoolantFlow = 0;

TemperatureControl.InitialReactionHeat = 0;

TemperatureControl.InitialIntegralError = 0;


end
