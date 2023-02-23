% In this file, you will list all of the known values that need to go into
% generate file
clear
close all
clc
% You can only run this script if you properly generated the airfoils using
% Leon's code
format long
% This code will also run generate file
% Specify the location where the mathematica outputs will be read from
inputFileLocation = 'C:\Users\zipza\Documents\SPCode\MathematicaOutputs\';
% Specify the location where the text files will be sent
outputLocation = 'C:\Users\zipza\Documents\SPCode\QbladeInputFiles\'; 

% Clean this up later
% All units should be entered in SI (except for H and ChordLength
EBlade = 1; % Modulus of Elasticity for blades
GBlade = 1; % Modulus of Rigidity for blades
rhoBlade = 1; % Density of blade material
rhoCable = [1]; % Material density for cables
ECable = [1]; % Modulus of Elasticity for cables (Ask about if this needs to be E/A
CableDiam = [0.5]; % Cable diameter in inches


ChordLength = 3; % Chord Length in Inches
segLength1 = 5;
segLength2 = 24;
% Enter Number of Nodes
bladeNodes = 34; % This might not entirly be the number of nodes
cableNodes = 8; % This number always lines up with a node on the main tube
trqNodes = 10; % This number excludes connector nodes
MTuneTrq = 1;
STuneTrq = 1;
RDmpTrq = 0.0127;
ETrq = 1;
GTrq = 1;
rhoTrq = 1;
ODTrq = 1;
IDTrq = 0;

rhoTwr = 1;
ETwr = 1;
GTwr = 1;
ODTwr = 1;
IDTwr = 0;
MTuneTwr = 1;
STuneTwr = 1;
RDmpTwr = 0.0127;
twrNodes = 2;
% Enter the number of blades
% I need to change this to an integer and use num2str to turn this into a
% string at a later date
numBlades = 3;
% Enter the number of cables
numCables = 3;

% Enter the name you want the blade to have
bladeName = 'NREL_5MW';

% Enter the names of the airfoil that you will be getting from the folder
foilNames = {'naca0021_csv','naca0024_csv'};

topConnection = [1,1,1]; % This should only be included if my hypothesis
%about the connection points is correct
% The number above is the percentage of the total length of the item you
% are connecting it to
topAnchor = {'TRQ','TRQ','TRQ'}; % Specifies that the connection is going to the torque tube
anchorPoints = {[1,2],[3,4],[5,6]}; % Cell of (x,y) coordinates representing
% where the cables connect to the ground (origin is on ground at center of
% turbine)
% Obvioucly, the cardinality of anchorPoints needs to equal the value of
% numCables
% The anchor points are specified with respect to the global coordinate
% system for the turbine(which has an origin located with the z axis along
% the torque tube and x=0,y=0 located on the ground)
CableTension = 1;
epsilon = 0.2; % spacing between nodes (this applies globally)
gbr = 1;  % gearbox ratio (N)
gbe = 1; % Gearbox efficiency
ddTF = 'false'; % model drivetrain dynamics (true / false)
gsi = 0; % Generator side inertia
dts = 0; % Drivetrain torsional stifness
dtd = 0; % Drivetrain torsional damping
mbt = 0; % maximum brake torque
bdeploy = 0; % brake deploy time (only used with DTU style controllers)
bdelay = 0; % brake delay time (only used with DTU style controllers)
TrqClear = 5; % clearance of torquetube, must be less than or equal to tower height
hubPos = 5; % height position of generator hub that is connecting the
% torque tube with the fixed tower
trqtbconn = 1; % This value is left blank in the sandia file
% however, it appears to represent Absolute height position, 
% starting after torque tube clearance, of a frictionless bearing that connects the torque tube to the fixed tower [m]
rtrClear = 5; % rotor clearance
bldconn = [0.975,40]; % absolute height position, starting after rotor clearance,
% of the position where the blade connects to torque tube (rigid connection
% assumed) (entry 1 is lower position, entry 2 is upper position)
% Enter the Turbine height (Excluding Ground Clearance)
H = 1.5; % Height of Turbine starting and ending where the blades begin and end (given in feet)
AR = 1.11; % Aspect ratio
MtuneBlade = 1;
StuneBlade = 1;
RayDmpBlade = 1;
RDpCab = [1];
cableTypes = 1; % This is the number of types of cables
TrqLength = 5; % Length of torque tube
TwrLength = 5;
% ex: If you have 3 cables, and two of them are identical, but one is made
% of a different material, then set cableTypes = 2
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
%foilNames = {'naca0021_csv','naca0024_csv'};

% This file contains the outputs from mathematica
Mathematica_OutputFile = 'Airfoil_propertiesList.xlsx';

BladeShape_fileName = 'SP_BladeShape.txt';
BladeStruct_fileName = 'SP_BladeStruct.txt';
Cable_fileName = 'SP_Cable.txt';
Torquetube_fileName = 'SP_Torquetube.txt';
Tower_fileName = 'SP_Tower.txt';
Turbine_fileName = 'SP_Main.txt';
MathematicaOutputExtension = append(inputFileLocation,Mathematica_OutputFile);
bladeshapeExtension = append(outputLocation,BladeShape_fileName);
bladestructExtension = append(outputLocation,BladeStruct_fileName);
cableExtension = append(outputLocation,Cable_fileName);
trqExtension = append(outputLocation,Torquetube_fileName);
twrExtension = append(outputLocation,Tower_fileName);
mainExtension = append(outputLocation,Turbine_fileName);
% Add in node specification and potentially location change, as well as
% decimal place increase for cables
generateFile(segLength1,segLength2,bladeNodes,H,AR,ChordLength,numBlades,bladeName,bladeshapeExtension, ...
bladestructExtension,MathematicaOutputExtension,foilNames,EBlade,GBlade,rhoBlade,cableExtension, ...
rhoCable,ECable,CableDiam,numCables,anchorPoints,CableTension,MtuneBlade,StuneBlade,RayDmpBlade, ...
RDpCab,cableNodes,topConnection,topAnchor,cableTypes,ETrq,GTrq,rhoTrq,MTuneTrq,STuneTrq,RDmpTrq,trqNodes, ...
ODTrq,IDTrq,trqExtension,TrqLength,rhoTwr,ODTwr,IDTwr,TwrLength,ETwr,GTwr,MTuneTwr,STuneTwr, ...
RDmpTwr,twrNodes,twrExtension,mainExtension,epsilon,gbr,gbe,ddTF,gsi,dts,dtd,mbt,bdeploy,bdelay, ...
BladeStruct_fileName,Cable_fileName,Torquetube_fileName,Tower_fileName,TrqClear,hubPos, ...
trqtbconn,rtrClear,bldconn,dataTypes,dataNames)