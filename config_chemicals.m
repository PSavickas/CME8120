function [Chemicals] = config_chemicals

%% TITLE

% Chemical Species Data

%% DESCRIPTION

% This function stores chemical species data for both reactants and
% products in a structure with the index handle Chemicals

%% EDITORIAL LOG

% 06/11/2017 - Function file created.
% Editors    - M.M, R.M & B.S

% 22/11/2017 - Data value checked to keep units consistent.
%              Standard units are now kJ, moles, kg, K and m^3.
% Editors    - E.E

% 05/12/2017 - Script comment update: Addition of reaction equations, and
%              added detail and formatting to all sections.
% Editors    - E.E

% 06/12/2017 - Heat capacity of TNG corrected. Intermediate heat capacities
%              calculated through linear interpolation with the Cp of G and
%              TNG as the min and max values.
%              (Lu et al., 2008)
% Editors    - E.E & P.S

%% REFERENCES 

% ref. Kinetic Modeling of Nitration of Glycerol (E. Astuti et al. 2014)

%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2017
% All Rights Reserved

%% INPUTS

% Function has no inputs

%% OUTPUTS

% Function outputs consist of manually inserted data under the index handle
% Chemicals

% HANDLE                     PROPERTY                                 UNITS         
% Chemical.Num               Number of chemical species               -
% Chemical.Name              Names of chemical species                -    
% Chemical.MolecularWeight   Molecular weight of each species         kg/mol
% Chemical.Density           Density of each species                  kg/m^3
% Chemical.SpecificHeat      Specific heat capacity of each species   kJ/kg.K

%% NUMBER OF CHEMICAL SPECIES

Chemicals.Num = 9;

%% NAMES OF CHEMICAL SPECIES

Chemicals.Name = {'water','C2H4Cl2', 'HNO3', 'G', '1-MNG', '2-MNG', '1,2-DNG', '1,3-DNG', 'TNG'};

%% MOLECULAR WEIGHT

% MolecularWeight - The molecular weight of component i  
% Units           - kg/mol

Chemicals.MolecularWeight = [0.018 0.099 0.063 0.092 0.0137 0.0137 0.0182 0.0182 0.0227];

%% DENSITY

% Denisty - The density of component i  
% Units   - kg/m^3

Chemicals.Density = [1000 1200 1510 1260 1600 1500 1900 1900 1700];

%% SPECIFIC HEAT CAPACITY

% SpecificHeat - The specific heat capacity of component i (at constqant
%                pressure (Cp))
% Units        - kJ/kg.K

Chemicals.SpecificHeat = [4.18 1.30 1.75 2.38 7.4 7.4 11.2 11.2 14.94];

end


