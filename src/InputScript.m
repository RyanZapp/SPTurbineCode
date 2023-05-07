clear
close all
clc
format long

%% Pre-Use Instructions
% 1.) Download UIUC airfoil database
% 2.) Run airfoil's through cleaning code, store outputs in folder
% 3.) Obtain nasalangleyMS1-0317.csv through Discord
% 4.) Store nasalangleyMS1-0317.csv in folder from 2.)
% 5.) Open MOIplusScaling.nb in Mathematica
% 6.) Customize your file path in the Mathematica script
% 7.) Run the Mathematica code
% 8.) Transition to MATLAB and begin using this script

%% File Description
% This is an input deck that interfaces with generateFile.m
% Once your inputs are defined here, simply click run

%% Path Specification
% Specify location where Mathematica output is stored
inputFileLocation = 'C:\Users\zipza\Documents\SPCode\MathematicaOutputs\';
% Specify location where generateFile.m should send output files
outputLocation = 'C:\Users\zipza\Documents\SPCode\QbladeInputFiles\'; 
%% Units
% Unless stated otherwise, all units should be entered in SI (kg,m,s)

%% General Input Parameters
% H = Half og the straight-line distance between blade endpoints (ft)
% AR = Aspect ratio (H/Blade Radius)

H = 1.5;
AR = 1.11;
%% Mesh Definition
% epsilon = Global geometry epsilon for node placement (-)

epsilon = 0.2;
%% Mass and Inertia
% HbM = Hub mass (kg)
% HbI = Hub inertia (kg*m^2)

HbM = 0;
HbI = 0;
%% Drivetrain Model
% gbr = Gearbox ratio (N)
% gbe = Gearbox efficiency (0-1)
% ddTF = Model drivetrain dynamics (true / false)
% gsi = Generator side (HSS) inertia (kg*m^2)
% dts = Drivetrain torsional stifness (N*m/rad)
% dtd = Drivetrain torsional damping (N*m*s/rad)

gbr = 1; 
gbe = 1;
ddTF = 'false';
gsi = 0;
dts = 0;
dtd = 0;
%% Brake Model
% mbt = Maximum brake torque (s)
% bdeploy = Brake deploy time (s) (only used with DTU style controllers)
% bdelay = Brake delay time (s) (only used with DTU style controllers)

mbt = 0;
bdeploy = 0;
bdelay = 0;
%% Blade Shape Properties
% numBlades = Number of blades
% bladeNodes = Number of nodes on blade for aero simulation
% ChordLength = Chord length of airfoils comprising the blades (in)
% segLength1 = Number of airfoil segments that make up the first & last N
%              segments of the blade (independent of bladeNodes)
% segLength2 = Number of airfoul segments that made up the middle N
%              segments of the blade (independent of bladeNodes)
% bladeOffset = Perpendicular distance from blade ends to centerline of
%               torque tube (ft)
% bladeName = A name for the blade (serves no technical purpose)

numBlades = 3;
bladeNodes = 34;
ChordLength = 3;
segLength1 = 5;
segLength2 = 24;
bladeOffset = 6;
bladeName = 'NREL_5MW';
%% Blade Structural Properties
% Eblade = Blade modulus of elasticity (Pa)
% GBlade = Blade modulus of rigidity (Pa)
% rhoBlade = Blade material density (kg/m^3)
% MTuneBld = Blade mass tuning coefficient
% STuneBld = Blade stiffness tuning coefficient
% RDmpBld = Blade Rayleigh damping coefficient
% foilNames = Names of airfoils being used to construct blade

EBlade = 1;
GBlade = 1; 
rhoBlade = 1; 
MTuneBld = 1;
STuneBld = 1;
RDmpBld = 1;
foilNames = {'naca0021_csv','nasalangleyMS1_0317_csv'};
% Note for foilNames: replace all instances of '-' and '.' with '_'

% Mathematics_OutputFile = Name of Excel File containing Airfoil structural
%                          properties output from Mathematica
% MathematicaOutputExtension = Path to this Excel file used in
%                              generateFile.m
Mathematica_OutputFile = 'Airfoil_propertiesList.xlsx';
MathematicaOutputExtension = append(inputFileLocation,Mathematica_OutputFile);
%% Cable Position Properties
% numCables = Number of cables
% cableNodes = Number of nodes on cable for aero simulation
% CableDiam = Cable diameter (in)
% topAnchor = Name of VAWT part the cables will connect to
% topConnection = Distance from the bottom of the topAnchor, specifying the
%                 height at which thr cables will be connected, expressed 
%                 as a percentage
% of the total height of topAnchor
% anchorPoints = global (x,y) coordinates where cables attach to the ground

numCables = 3;
cableNodes = 8;
CableDiam = 0.5;
topAnchor = {'TRQ','TRQ','TRQ'};
topConnection = [1,1,1];
anchorPoints = {[1,2],[3,4],[5,6]};
%% Cable Structural Properties
% cableTypes = Input how many types of cables there are
% rhoCable = Cable material density (kg/m^3)
% ECable = Cable modulus of elasticity (Pa)
% RDmpCab = Cable Rayleigh damping coefficient
% CableTension = Tension in Cable (N) (Determined from external FEA)

cableTypes = 1;
rhoCable = 1; 
ECable = 1;
RDmpCab = 1;
CableTension = 1;
%% Tower Shape Properties
% TwrLength = Height of (fixed, non-rotating) tower (m)
% twrNodes = Number of nodes on tower for aero simulation
% ODTwr = Outer diameter of tower (m)
% IDTwr = Inner diameter of tower (m)

TwrLength = 5;
twrNodes = 2;
ODTwr = 1;
IDTwr = 0;
%% Tower Structural Properties
% rhoTwr = Tower material density (kg/m^3)
% ETwr = Tower modulus of elasticity (Pa)
% GTwr = Towr modulus of rigidity (Pa)
% MTuneTwr = Tower mass tuning coefficient
% STuneTwr = Tower stiffness tuning coefficient
% RDmpTwr = Tower Rayleigh damping coefficient

rhoTwr = 1;
ETwr = 1;
GTwr = 1;
MTuneTwr = 1;
STuneTwr = 1;
RDmpTwr = 0.0127;
%% Torque Tube Shape Properties
% TrqLength = Height of the torque tube (rotating part of the tower) (m)
% trqNodes = Number of nodes on torque tube for aero simulation
% ODTrq = Outer diameter of torque tube (m)
% IDTrq = Inner diameter of torque tube (m)
% TrqClear = Clearance of the torque tube, must be <= TwrLength (m)
% hubPos = height of generator hub connecting torque tube to fixed tower (m)
% trqtbconn = Abs height, starting after torque tube clearance, of a
%             frictionless bearing connecting torque tube to fixed tower (m)
% rtrClear = Rotor clearance (unsure of units)
% bldconn = Abs height positions of connection points between blade and
%           torque tube (m)

TrqLength = 5;
trqNodes = 10;
ODTrq = 1;
IDTrq = 0;
TrqClear = 5; 
hubPos = 5;
trqtbconn = 1;
rtrClear = 5;
bldconn = [0.975,40]; 
%% Torque Tube Structural Properties
% rhoTrq = Torque tube material density (kg/m^3)
% ETrq = Torque tube modulus of elasticity (Pa)
% GTrq = Torque tube modulus of rigidity (Pa)
% MTuneTrq = Torque tube mass tuning coefficient
% STuneTrq = Torque tube stiffness tuning coefficient
% RDmpTrq = Torque tube Rayleigh damping coefficient

rhoTrq = 1;
ETrq = 1;
GTrq = 1;
MTuneTrq = 1;
STuneTrq = 1;
RDmpTrq = 0.0127;
%% Output File Locations
% BladeShape_fileName = Name of .txt file used to create the blade
% BladeStruct_fileNmae = Name of .txt file that defines the blade
%                        structural properties
% Cable_fileName = Name of .txt file that defines the cable structural
%                  properties
% Torquetube_fileName = Name of .txt file that defines the torque tube 
%                       structural properties
% Tower_fileName = Name of .txt file that defines the tower structural
%                  properties
% Turbine_fileName = Name of .txt file that gets imported as the main
%                    CHRONO input in the turbine definition module

BladeShape_fileName = 'SP_BladeShape.txt';
BladeStruct_fileName = 'SP_BladeStruct.txt';
Cable_fileName = 'SP_Cable.txt';
Torquetube_fileName = 'SP_Torquetube.txt';
Tower_fileName = 'SP_Tower.txt';
Turbine_fileName = 'SP_Main.txt';

% The lines below take the lines above and combine them into file paths

bladeshapeExtension = append(outputLocation,BladeShape_fileName);
bladestructExtension = append(outputLocation,BladeStruct_fileName);
cableExtension = append(outputLocation,Cable_fileName);
trqExtension = append(outputLocation,Torquetube_fileName);
twrExtension = append(outputLocation,Tower_fileName);
mainExtension = append(outputLocation,Turbine_fileName);
%% MISC
FOR_OUT = 'true';
ROT_OUT = 'true';
MOM_OUT = 'true';
DEF_OUT = 'true';
POS_OUT = 'true';
VEL_OUT = 'true';
ACC_OUT = 'true';
LVE_OUT = 'true';
LAC_OUT = 'true';
dataTypes = {FOR_OUT ROT_OUT MOM_OUT DEF_OUT POS_OUT ...
    VEL_OUT ACC_OUT LVE_OUT LAC_OUT};
dataNames = {{'FOR_OUT','(local) forces'} {'ROT_OUT','(local) body rotations'} ...
    {'MOM_OUT','(local) moments'} {'DEF_OUT','(local) deflections'} ...
    {'POS_OUT','(global) positions'} {'VEL_OUT','(global) velocities'} ...
    {'ACC_OUT','(global) accelerations'} {'LVE_OUT','(local) velocities'} ...
    {'LAC_OUT','(local) accelerations'}};
%% Main Function
generateFile(segLength1,segLength2,bladeNodes,H,AR,ChordLength,numBlades,bladeName,bladeshapeExtension, ...
bladestructExtension,MathematicaOutputExtension,foilNames,EBlade,GBlade,rhoBlade,cableExtension, ...
rhoCable,ECable,CableDiam,numCables,anchorPoints,CableTension,MTuneBld,STuneBld,RDmpBld, ...
RDmpCab,cableNodes,topConnection,topAnchor,cableTypes,ETrq,GTrq,rhoTrq,MTuneTrq,STuneTrq,RDmpTrq,trqNodes, ...
ODTrq,IDTrq,trqExtension,TrqLength,rhoTwr,ODTwr,IDTwr,TwrLength,ETwr,GTwr,MTuneTwr,STuneTwr, ...
RDmpTwr,twrNodes,twrExtension,mainExtension,epsilon,gbr,gbe,ddTF,gsi,dts,dtd,mbt,bdeploy,bdelay, ...
BladeStruct_fileName,Cable_fileName,Torquetube_fileName,Tower_fileName,TrqClear,hubPos, ...
trqtbconn,rtrClear,bldconn,dataTypes,dataNames,HbM,HbI,bladeOffset)