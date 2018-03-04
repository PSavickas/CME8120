function [Feed] = feeding_system(Chemicals, hour, TemperatureControl)

%% TITLE

% Feeding System Function File

%% DESCRIPTION

% This function contains data on the volumetric flow of feed and from this
% calculated molar feed flow. It also specifies the number of feed changes
% if any including magnitude, compositional changes and at what time these
% changes occur.

%% EDITORIAL LOG

% 06/11/2017 - Function file created.
% Editors    - M.M, R.M & B.S

% 22/11/2017 - Script comment update to improve readability.
% Editors    - E.E

%% REFERENCES 

% ref. Kinetic Modeling of Nitration of Glycerol (E. Astuti et al. 2014)
% used to calculate flowrates and composition to satisfy reagent
% concentrations and molar ratios of reactants in accordance with the
% literature

%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2017
% All Rights Reserved

%% INPUTS

% Chemicals - config_chemicals
% hour - specifys conversion from hours to seconds for the DAE solver.

%% OUTPUTS

% Function outputs a structure of data to be used in mass and energy
% balances

% HANDLE                         PROPERTY                                                   UNITS         
% Feed.NumChanges                Number of feed changes in simulation                       -
% Feed.VolumetricFlow            Volumetric flow of feed                                    m^3/hour    
% Feed.VolumeFraction            Volumetric fraction composition of feed                    -
% Feed.MolarFlow                 Vector of molar flows of feed                              kmol/s
% Feed.Time                      Times at which feed changes occur                          seconds
% Feed.Tempearture               Temperature of feed stream                                 K

%% SPECIFY NUMBER OF FEED CHANGES

Feed.NumChanges = 2;

%% SPECIFY FEED VOLUMETRIC FLOW AND FRACTION

Feed.VolumetricFlow = [0.0639 0];
Feed.VolumeFraction = [0.31 0 0.69 0 0 0 0 0 0;
                       0.31 0 0.69 0 0 0 0 0 0];
            
%% CALCULATE VECTOR OF FEED MOLAR FLOWS  

Feed.MolarFlow  = zeros(Chemicals.Num,1); % (kmol/hr)

for j = 1: Feed.NumChanges
    
    for i = 1:Chemicals.Num
    
        Feed.MolarFlow(i,j) = Feed.VolumetricFlow(j) ...,
                            * Feed.VolumeFraction(j,i) ...,
                            * Chemicals.Density(i) ...,
                            / Chemicals.MolecularWeight(i) ..., 
                            / hour;
end

%% SPECIFY TIMES OF FEED CHANGES

Feed.Time = [0 8*hour];

%% SPECIFY FEED TEMPERATURE
%  Required for the energy balance

Feed.Temperature = TemperatureControl.ReactorSetPoint(1); 
         
end
