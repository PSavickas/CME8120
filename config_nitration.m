function [Nitration] = config_nitration

%% TITLE

% Nitration Reaction Data

%% DESCRIPTION

% Function holds a structure of reaction properties for use in other
% functions and the main script

% Nitration Reactions:

% 1   HNO3  +  G        <->  1-MNG    +  H2O
% 2   HNO3  +  G        <->  1-MNG    +  H2O
% 3   HNO3  +  1-MNG    <->  1,3-DNG  +  H2O
% 4   HNO3  +  1-MNG    <->  1,2-DNG  +  H2O
% 5   HNO3  +  2-MNG    <->  1,2-DNG  +  H2O
% 6   HNO3  +  1,3-DNG  <->  TNG      +  H2O
% 7   HNO3  +  1,2-DNG  <->  TNG      +  H2O

%% EDITORIAL LOG

% 6/11/2017  - Function file creation and manual import of data
% Editors    - E.E & P.S

% 22/11/2017 - Data for Kref and ideal gas constant altered to keep units
%              consistent.
%              Standard units are now kJ, moles, kg, K and m^3.
% Editors    - E.E

% 05/12/2017 - Script comment update: Addition of reaction equations, and
%              added detail and formatting to all sections.
% Editors    - E.E

% 31/01/2018 - References for Kref, equilibrium and activation energy
%              matricies added. Additional commenting. 
% Editors    - E.H & R.S 

% 06/02/2018 - Script updated to include all equilibrium data supplied by
%              ref.
% Editors    - R.M

%% REFERENCES 

% ref. Kinetic Modeling of Nitration of Glycerol (E. Astuti et al. 2014)
%% COPYRIGHT

% Edward Elcock; Pijus Savickas; Ellie Hiscock; Robbie Morgan; Rebecca Sutton; Marzarianey Metali Copyright (c) 2017
% All Rights Reserved

%% INPUTS

% Function has no inputs

%% OUTPUTS

% Function outputs consist of manually inserted data under the index handle
% Nitration

% HANDLE                                      PROPERTY                                               UNITS         
% Nitration.Num                               Number of chemical reactions                           -
% Nitration.ProductStoichiometry              Stoichiometric numbers of product species              -    
% Nitration.ReactantStoichiometry             Stoichiometric numbers of reactant species             -
% Nitration.Stoichiometry                     Stoichiometry of reactions                             -
% Nitration.Kref                              Reaction constant at reference temperature (293.15K)   m^3/mol.s
% Nitration.Equilibrium                       Equilibrium constants                                  -
% Nitration.ActivationEnergy                  Arrhenius activation energy                            kJ/mol
% Nitration.GasConstant                       Ideal gas constant                                     kJ/mol.K
% Nitration.Heat                              Heats of reaction                                      kJ/mol

%% NUMBER OF REACTIONS

Nitration.Num = 7;

%% NITRATION STOICHIOMETRY

%Each row represents a reactant or product species and each column
%represents a reaction.
%The matrix details the stoichiometric coefficient for all reactants in the
%first matrix, and all products in the second.

               %Reaction Number    1 2 3 4 5 6 7          %Component
Nitration.ReactantStoichiometry = [0 0 0 0 0 0 0; ...     %H2O
                                   0 0 0 0 0 0 0; ...     %C2H4Cl2
                                   1 1 1 1 1 1 1; ...     %HNO3
                                   1 1 0 0 0 0 0; ...     %G
                                   0 0 1 1 0 0 0; ...     %1-MNG
                                   0 0 0 0 1 0 0; ...     %2-MNG
                                   0 0 0 0 0 0 1; ...     %1,2-DNG
                                   0 0 0 0 0 1 0; ...     %1,3-DNG
                                   0 0 0 0 0 0 0];        %TNG

              %Reaction Number     1 2 3 4 5 6 7          %Component
Nitration.ProductStoichiometry =  [1 1 1 1 1 1 1; ...     %H2O
                                   0 0 0 0 0 0 0; ...     %C2H4Cl2
                                   0 0 0 0 0 0 0; ...     %HNO3
                                   0 0 0 0 0 0 0; ...     %G
                                   1 0 0 0 0 0 0; ...     %1-MNG
                                   0 1 0 0 0 0 0; ...     %2-MNG
                                   0 0 0 1 1 0 0; ...     %1,2-DNG
                                   0 0 1 0 0 0 0; ...     %1,3-DNG
                                   0 0 0 0 0 1 1];        %TNG
                               
% Nitration.Stoichiometry represents the net stoichiometric loss/gain of each component
% for each reaction.

Nitration.Stoichiometry =     Nitration.ProductStoichiometry ...
                            - Nitration.ReactantStoichiometry;

%% AREHNIUS PARAMETERS

% Kref_i - the rate constant of reactant i at the reference temperature (293.15K).  
% Units  - m^3/mol.s

% Data taken from reference stated above 

% Reaction number           1          2     3         4        5          6      7            % Molar Ratio (HNO3/G)
Nitration.Kref = 10e-10 * ([1034134.55 0.02  86632.50  3805.42  3.72       56.82  857.40; ...  % 1/1
                           5.77        0.05  80.18     2.33     59.91      0.94   2.44  ; ...  % 3/1
                           15.24       1.59  117.22    4.90     10803.65   2.28   103.54; ...  % 5/1
                           235.38      4.17  89.97     34.60    246130.55  1.58   716.19]);    % 7/1
                   
% Equilibrium Data 

% Relates the forward rate constant to the backwards rate constant at different operating temperatures.
% The rows in the equilibrium data matricies relate to the molar ratio of HNO3 and G.
% The collumns in the equilibrium data matricies relate to the reaction number.
% Data taken from references stated above.

% Equilibirum data at 283k
% Reaction number          1       2       3        4       5        6       7           % Molar Ratio (HNO3/G)
Nitration.Equilibrium10 = [0.0106  0.0365  6.1397  0.6715  9.4015   0.2906  2.6565;...   % 1/1
                           0.1351  0.1539  2.0818  0.1376  5.5005   0.4604  6.9630;...   % 3/1
                           0.3177  0.4347  2.6020  0.1694  15.7508  0.4692  7.2092;...   % 5/1
                           0.8956  1.4346  3.3170  0.1824  17.1486  0.7970  14.4904];    % 7/1

% Equilibrium data at 288k
% Reaction number          1       2       3        4       5        6       7           % Molar Ratio (HNO3/G)
Nitration.Equilibrium15 = [0.0053  0.0304  10.1324  1.1013  2.2027   0.2448  2.2521;...  % 1/1
                           0.1639  0.2231  2.6187   0.2414  6.2775   0.4705  5.1034;...  % 3/1
                           0.4736  0.6918  2.9312   0.1937  22.6619  0.4111  6.2217;...  % 5/1
                           0.4690  0.8694  3.5345   0.1698  5.2632   0.3672  7.6439];    % 7/1

% Equilibrium data at 293k                       
% Reaction number          1       2       3        4       5        6       7           % Molar Ratio (HNO3/G)           
Nitration.Equilibrium20 = [0.0056  0.0361  11.3405  1.1674  4.6056   0.2717  2.6389;...  % 1/1
                           0.0760  0.3489  8.8792   0.6107  18.9329  0.0574  0.8352;...  % 3/1
                           0.1953  1.0903  11.4168  0.4779  1.5399   0.0839  2.0046;...  % 5/1
                           1.0209  1.5996  3.1964   0.1799  1.5359   0.6019  10.6957];   % 7/1
 
% Equilbrium data at 303k                       
% Reaction number          1       2       3        4       5        6       7           % Molar Ratio (HNO3/G)
Nitration.Equilibrium30 = [0.0078  0.0329  7.4198   0.6625  1.1041   0.152   1.6934;...  % 1/1
                           0.1129  0.6849  13.7496  0.9228  17.0716  0.3173  4.7273;...  % 3/1
                           0.5858  1.5508  5.8457   0.2682  4.1564   0.1949  4.2496;...  % 5/1
                           2.3883  4.0404  3.8210   0.1800  15.3039  0.5689  12.0735];   % 7/1

% ActivationEnergy - The activation energy for each reaction in the forward
%                    direction.
% Units            - kJ/mol
% Reaction number             1      2       3      4      5       6       7           % Molar Ratio (HNO3/G)           
Nitration.ActivationEnergy = [38.10  117.23  58.62  31.40  167.47  104.67  71.18;...   % 1/1
                              38.10  117.23  58.62  31.40  167.48  104.53  71.89;...   % 3/1
                              38.15  117.23  58.69  31.40  167.48  104.51  71.90;...   % 5/1
                              38.12  117.23  58.64  31.38  167.46  104.53  71.84];     % 7/1

% GasConstant - The ideal gas constant.
% Units       - kJ/mol.K

Nitration.GasConstant = 0.008314;

%% REACTION ENTHALPY

% Heat  - Heats of reacion in the forward direction.
% Units - kJ/mol

%Reaction number  1     2     3     4     5     6     7           
Nitration.Heat = [-59.4 -50.6 -51.5 -46.4 -55.6 -44.4 -49.4];

end

