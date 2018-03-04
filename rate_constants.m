function [k] = rate_constants(Nitration, Temperature, Reactor)

%% TITLE

% Rate Constant Calculation

%% DESCRIPTION

% This function calculates the forward and reverse rate constants for all 7
% reactions using the Arhenius equation with data from the Nitration
% (config_nitration.m) function file. The rate constants are stored in a 
% 2 x 7 matrix with the first row containing the forward rate constants and
% the second row containing the reverse rate constants. Each column
% represents a reaction in chronological order.

%% EDITORIAL LOG

% 07/11/2017 - Function file created.
% Editors    - B.S, R.M & E.H

% 08/11/2017 - Mistake in the Arhenius equation observed by E.H and
%              corrected.
% Editors    - B.S, R.M, E.H & E.E

% 22/11/2017 - Data value checked to keep units consistent.
%              Standard units are now kJ, moles, kg, K and m^3.
% Editors    - E.E

% 05/12/2017 - Script comment update: Addition of reaction equations, and
%              added detail and formatting to all sections.
% Editors    - E.E

% 06/02/2018 - Script updated to take into account which equilibrium
%              constant to use dependant on temperature.
% Editors    - R.M

%% REFERENCES 

% ref. Kinetic Modeling of Nitration of Glycerol (E. Astuti et al. 2014)
%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2017
% All Rights Reserved

%% INPUTS

% Nitration   - structure of reaction parameters used in the arhenius equation

% Temperature - The differential for reactor temperature is used in the
%               Arhenius equation as reaction rates are a function of temperature

%% OUTPUTS

% k - represents the 2 x 7 matrix of rate constants

%% SPECIFYING REFERENCE TEMPERATURE

% The reference temperature at which the reaction rate consant j equals
% Kref,j
% where j is the reaction number, and the row is taken from a specified HNO3:G ratio.

Tref = 293.15;      %K

%% CALCULATION OF RATE CONSTANTS USING ARHENIUS EQUATION

% k(1,j)  -  Forward rate constant
% k(2,j)  -  Backward rate constant
% where j is the reaction number
% Units   -  m^3/mol.s

k(2,1:Nitration.Num) = 0;

for j = 1:Nitration.Num
  
    % Arhenius Equation
    k(1 , j) = Nitration.Kref(2,j) * exp ( (Nitration.ActivationEnergy(2,j) / Nitration.GasConstant) * ((1/Tref)-(1/Temperature)));
    
    % Equilibrium rate constant equation
    % IF statement specifies which equilibrium data to use dependant on the
    % temperature of the reactor.
    
    if (Reactor.InitialTemperature < 288.5)
            k(2, j) = k(1, j) / Nitration.Equilibrium10(2,j);
    elseif (Reactor.InitialTemperature >= 288.5 && Reactor.InitialTemperature < 293.5)
            k(2, j) = k(1, j) / Nitration.Equilibrium15(2,j);
    elseif (Reactor.InitialTemperature >= 293.5 && Reactor.InitialTemperature < 303.5)
            k(2, j) = k(1, j) / Nitration.Equilibrium20(2,j); 
    else (Reactor.InitialTemperature >= 303.5)
            k(2, j) = k(1, j) / Nitration.Equilibrium30(2,j); 
    end        
    
end

end


