function [Reactor] = get_config_reactor_cstr(Chemicals,TemperatureControl)

%% TITLE

% CSTR Data and Dimensions

%% DESCRIPTION

%% EDITORIAL LOG

% 8/11/2017  - Function file creation and manual import of data
% Editors    - E.E, P.S & E.H

% 22/11/2017 - Data value checked to keep units consistent.
%              Standard units are now kJ, moles, kg, K and m^3.
% Editors    - E.E

% 05/12/2017 - Script comment update: Addition of reaction equations, and
%              added detail and formatting to all sections.
% Editors    - E.E

% 06/12/2017 - Inclusion of Initial guess for heat of reaction
% Editors    - E.E & P.S

%% REFERENCES 

% ref. Kinetic Modeling of Nitration of Glycerol (E. Astuti et al. 2014)

%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2017
% All Rights Reserved

%% INPUTS

% Chemicals - structure of reactant and product properties used in mass
%             balances

%% OUTPUTS

% Function outputs consist of manually inserted and calculated data under
% the index handle Reactor

% HANDLE                              PROPERTY                                           UNITS         
% Reactor.InitialVolume               Initial volume of chemical species in reactor      m^3
% Reactor.InitialMoles                Initial moles of chemical species in reactor       mol    
% Reactor.InitialVolumeFraction       Initial volume fraction                            -
% Reactor.InitialTemperature          Initial temperature of reactor                     K
% Reactor.InitialMass                 Initial mass of reactant                           kg
% Reactor.InitialDensity              Initial density of reactants                       kg/m^3
% Reactor.InitialReactionHeat         Initial heat of reaction                           kJ/mol
% Reactor.InitialConversion
% Reactor.InitialSelectivity
% Reactor.InitialYield

%% REACTOR INITIAL VOLUME

% InitialVolume - The initial statement of reactor volume at time t = 0.
%                 Also used as initial guess for dae solver.
% Units         - m^3

Reactor.InitialVolume = 0.6884;   %m^3

%% REACTOR INITIAL VOLUME FRACTION

% InitialVolumeFraction - The initial statement of the volumetric 
%                         composition of the reactor at time t = 0.

Reactor.InitialVolumeFraction = [0 0.7 0 0.3 0 0 0 0 0 0];

%% REACTOR INITIAL MOLES

% InitialMoles - The initial calculation of the number of moles of each 
%                component in the reactor at time t = 0. Calculated from
%                the initial volume, volume fraction and chemical
%                properties.
%                Also used as initial guess for dae solver.
% Units        - mol

Reactor.InitialMoles = zeros(Chemicals.Num,1);

for i = 1:Chemicals.Num
    
    Reactor.InitialMoles(i) = Reactor.InitialVolume ...,
                            * Reactor.InitialVolumeFraction(i)...,
                            * Chemicals.Density(i)...,
                            / Chemicals.MolecularWeight(i);
                            
end

%% REACTOR INITIAL MASS

% InitialMass - The initial calculation of the mass of each component in
%               the reactor at time t = 0.
% Units       - kg

Reactor.InitialMass = 0;

for i = 1:Chemicals.Num
    
    Reactor.InitialMass   = Reactor.InitialMass ...,
                          + Reactor.InitialMoles(i)...,
                          * Chemicals.MolecularWeight(i);
                            
end


%% Reactor Heat Transfer Area and UA
% Cooling area and volume were migrated from cooling system fuctions to reactor set up, to make the script more modular
% Parameters were taken from a sample sized reactor from

Reactor.CoolingArea = 7.3;
Reactor.CoolingJacketVolume = 0.353;

% Typical UA value was taken from as 350 : 

Reactor.HTC = 350;                                           % W/m2/K
Reactor.UA = Reactor.HTC  / 1000 * Reactor.CoolingArea;     %(kW /K))



%% REACTOR INITIAL DENSITY

% InitialDensity - The initial calculation of the mean reacting volume
%                  density at time t = 0.
% Units          - kg/m^3

Reactor.InitialDensity = Reactor.InitialMass / Reactor.InitialVolume;
 
%% REACTOR INITIAL TEMPERATURE

% InitialTemperature - The initial statement of reactor temperature at time
%                      t = 0.
%                      Also used as initial guess for dae solver.
% Units              - K

Reactor.InitialTemperature = TemperatureControl.ReactorSetPoint(1); 

%% REACTOR INITIAL CONVERSION

% InitialConversion - The initial conversion is set to 0 as the reaction
%                     hasn't evolved.
% Units              - %

Reactor.InitialConversion = 0;


%% REACTOR INITIAL SELECTIVITY

% InitialSelectivity - The initial selectivity is set to 0 as the reaction
%                      hasn't evolved.
% Units              - %

Reactor.InitialSelectivity = 0;


%% REACTOR INITIAL YIELD

% InitialYield - The initial yield is set to 0 as the reaction
%                hasn't evolved.
% Units              - %


Reactor.InitialYield = 0;


end
