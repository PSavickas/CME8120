function [Output] = dae_ideal_fed_batch_nitration(t, y, Chemicals, Nitration, Reactor, TemperatureControl, Feed)
%% DAES_NON_ISOTHERMAL_BATCH_REACTOR_2 Calculate rate of change of moles of the species and temperature
%
%% Input
%
% (t, y, ChemicalSpecies, Reaction, Reactor, Jacket)
%
%% Output
%
% [Output] - system derivatives
%
%% Description
%
% Calculates the derivatives of the dependent variables. For an isothermal
% batch reactor this is the rate of change of moles with respect to time and the
% rate of change of volume.

%% Editorial Log


%% REFERENCES 

% ref. Kinetic Modeling of Nitration of Glycerol (E. Astuti et al. 2014)
%
%% Function calls
%
% rate_constants

%% Copyright
% Copyright (c) Mark Willis 2017
% All Rights Reserved

%% Define the dependent variables 
%

%{

Copy the first 'ChemicalSpecies.Num' elements into a local vector Moles.
This makes the calculations easier to read. The last value of y is
temperature.

%}

Moles          = y(1:Chemicals.Num);        % mol

Temperature    = y(Chemicals.Num + 1);          % (K)

TemperatureJacket = y(Chemicals.Num + 2);

Total_CoolantFlowRate = y(Chemicals.Num + 3);

Total_Volume   = y(Chemicals.Num + 4);       % (m^3)

Total_Heat     = y(Chemicals.Num + 5);      % (%)

ConversionG     = y(Chemicals.Num + 6);

SelectivityTNG = y(Chemicals.Num + 7); 

YieldTNG       = y(Chemicals.Num + 8);      % (%)

Integral       = y(Chemicals.Num + 9);  

%% Calculate the volume at time 't'
%

Volume = 0;

for j = 1:Chemicals.Num
    
   Volume = Volume ...,
          + Moles(j) ...,
          * Chemicals.MolecularWeight(j) ...,
          / Chemicals.Density(j);         % (m3)

end

%% Calculate the concentration of each of the species

%{

MATLAB SYNTAX

As Volume is a scalar the / operator will divide every element in the vector
Moles by Volume

%}

Concentration = Moles / Volume;                  % (mol/m3)

%% Calculate the reaction rate constants

RateConstant = rate_constants(Nitration, Temperature, Reactor);   %[1/s]

%% Calculate the reaction rates

%{

MATLAB SYNTAX

ZEROS(M,N) is an M-by-N matrix of ones. Therefore ReactionRate is
initialised as a column vector.

%}

ReactionRate = zeros(Nitration.Num,1);                    % (mol/s)

ReactionRate(1) = Volume * ( ( RateConstant(1,1) * Concentration(3) * Concentration(4) ) ...
                           - ( RateConstant(2,1) * Concentration(1) * Concentration(5) ) );
ReactionRate(2) = Volume * ( ( RateConstant(1,2) * Concentration(3) * Concentration(4) ) ...
                           - ( RateConstant(2,2) * Concentration(1) * Concentration(6) ) );
ReactionRate(3) = Volume * ( ( RateConstant(1,3) * Concentration(3) * Concentration(5) ) ...
                           - ( RateConstant(2,3) * Concentration(1) * Concentration(8) ) );
ReactionRate(4) = Volume * ( ( RateConstant(1,4) * Concentration(3) * Concentration(5) ) ...
                           - ( RateConstant(2,4) * Concentration(1) * Concentration(7) ) );
ReactionRate(5) = Volume * ( ( RateConstant(1,5) * Concentration(3) * Concentration(6) ) ...
                           - ( RateConstant(2,5) * Concentration(1) * Concentration(7) ) );
ReactionRate(6) = Volume * ( ( RateConstant(1,6) * Concentration(3) * Concentration(8) ) ...
                           - ( RateConstant(2,6) * Concentration(1) * Concentration(9) ) );
ReactionRate(7) = Volume * ( ( RateConstant(1,7) * Concentration(3) * Concentration(7) ) ...
                           - ( RateConstant(2,7) * Concentration(1) * Concentration(9) ) );


%% Calculate rate of production / consumption of the chemical species

RateProductionReaction = Nitration.Stoichiometry ...
                       * ReactionRate;                   % (mol /s)

%% Rate of change of moles of chemical species 
%
MolarFeedFlow = Feed.CurrentMolarFlow; 
TemperatureControl.ReactorSetPoint = TemperatureControl.CurrentReactorSetPoint;

%% Molar flows of effluent

% The 0's represent the assumption that only water is being removed from the
% reactor as it is rate limiting. If water is present reaction rate is so
% slow simulation time takes too long and crashes after reaching minimum
% aloud tolerance. 

MolarEffluentFlow =  1 * [RateProductionReaction(1) + MolarFeedFlow(1); 0 ;0; 0; 0; 0; 0; 0; 0];

dMoles_dt = RateProductionReaction + MolarFeedFlow - MolarEffluentFlow;

%% calculate the rate of heat evolution
%

Qr = 0;

for j = 1:Nitration.Num
   
    Qr = Qr + ReactionRate(j) * Nitration.Heat(j);      %(kW)

end


%% calculate heat capacity of reaction mixture
%

HeatCapacity = 0;

for j = 1:Chemicals.Num
    
    HeatCapacity = HeatCapacity ...
                 + Chemicals.SpecificHeat(j)...
                 * Chemicals.MolecularWeight(j)...
                 * Moles(j);

end

FeedHeatCapacity = 0;

for j = 1:Chemicals.Num
    
    FeedHeatCapacity = FeedHeatCapacity ...,            %(kW/K)
                     + Chemicals.SpecificHeat(j)...,
                     * Chemicals.MolecularWeight(j) ...,
                     * MolarFeedFlow (j);

end


%% Temperature Control System

% Intergral Error Defined as definition from set-point
dIntegral_dt = ( TemperatureControl.ReactorSetPoint - Temperature);
% PI controller for calculating Coolant Flowrate
CoolantFlowRate = 0 - TemperatureControl.PGain * (TemperatureControl.ReactorSetPoint - Temperature) +  TemperatureControl.IGain * Integral; 
% Heating power is set to 0 in order not to conflict heating and cooling
QHeating = 0;

if CoolantFlowRate == TemperatureControl.CoolingFlowMinimumLimit
   CoolantFlowRate = TemperatureControl.CoolingFlowMinimumLimit;
   
elseif CoolantFlowRate > TemperatureControl.CoolingFlowMaximumLimit
   CoolantFlowRate = TemperatureControl.CoolingFlowMaximumLimit;
   
elseif CoolantFlowRate < TemperatureControl.CoolingFlowMinimumLimit
   CoolantFlowRate = TemperatureControl.CoolingFlowMinimumLimit;
   % Heating is activated is CoolantFlowRate is turned to be negative
   QHeating = TemperatureControl.HeatingOutput;
end

HeatTransferRate = Reactor.UA * (TemperatureJacket - Temperature);

% Change of coolant temperature inside jacket due heat transfer from
% reactor

dTemperatureJacket_dt = (CoolantFlowRate * TemperatureControl.CoolantSpecificHeat * (TemperatureControl.CoolantTemperature - TemperatureJacket) - ...
                         HeatTransferRate + QHeating) / ...
                        (Reactor.CoolingJacketVolume * TemperatureControl.CoolantSpecificHeat * TemperatureControl.CoolantDensity);



%% Heat input due to feed at different temperature

Qfeed = FeedHeatCapacity * (Feed.Temperature - Temperature);

%% Overal Energy Balance for reactor contents including reaction heat, heat transfer and feed energy input

dTemperature_dt = (- Qr + HeatTransferRate + Qfeed ) / HeatCapacity ;


%% Defining Conversion

Conversion = (1-(Moles(4)/Reactor.InitialMoles(4))) * 100;

%% Defining Selectivitiy

% Addition of 0.00001 is to prevent a divide by zero.

Selectivity = (Moles(9)/(Moles(5) + Moles(6) + Moles(7) + Moles(8) + 0.00001));


%% Defining Yield


Yield = (Moles(9) / Reactor.InitialMoles(4))*100;


%% ALGEBRAICS

% Volume

Algebraic(1) =  Total_CoolantFlowRate - CoolantFlowRate;

% Conversion of TNG


Algebraic(2) = Total_Volume - Volume;

Algebraic(3) = Total_Heat - Qr;

Algebraic(4) = ConversionG - Conversion; 

% Selectivity of TNG

Algebraic(5) = SelectivityTNG - Selectivity;

% Yield of TNG

Algebraic(6) = YieldTNG - Yield;

%% Concatenate system derivatives to pass back out of function

Output = [dMoles_dt; ...
          dTemperature_dt; ...
          dTemperatureJacket_dt; ...
          Algebraic(1); ...
          Algebraic(2); ...
          Algebraic(3); ...
          Algebraic(4); ...
          Algebraic(5); ...
          Algebraic(6); ...
          dIntegral_dt];
                     

end

