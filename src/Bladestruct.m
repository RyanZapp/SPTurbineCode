%function Bladestruct(fileLocation,fileName,ElasticModulus,RigidityModulus, ...
% 
% read in output of the panel number from the matlab code that makes the catenary blade 
% since it determines the number of panels, so we take 1 and divide it by that number to get
% the spacing for L, include the airfoil names into the file reading)
format long
fileLocation = 'C:\Users\zipza\Documents\SPCode\MathematicaOutputs';
fileName = 'Airfoil_propertiesList.xlsx';
foilName = {'naca0021_csv','naca0024_csv'};
segLength1 = 5;
segLength2 = 24;
segLength3 = 5;
E = 71.1E09; % In Pa
G = 26.9E09; % in Pa
N1 = 34; % This is the number of panels that comes as an input from the Bladeshape function
D = zeros(N1,8); % 8 is the number of variables that are currently being output into the structual
%file
% I might not even need this zeros matrix
OO = ones(N1,1);
Ixx = OO;
Iyy = OO;
extension = append(fileLocation,'\',fileName);
T = readtable(extension);
A1 = T{1:end,foilName{1}}; % Structural Properties of first NACA foil
A2 = T{1:end,foilName{2}}; % Structural Properties of second NACA foil
% Extract structural properties for first airfoil
Ixx1 = A1(1)*OO;
Iyy1 = A1(2)*OO;
%J1 = A1(3)*OO;
Area1 = A1(4)*OO;
% Extract structural properties for second airfoil
Ixx2 = A2(1)*OO;
Iyy2 = A2(2)*OO;
%J2 = A2(3)*OO;
Area2 = A2(4)*OO;
% Develop length variable (applies to both airfoils)
dL = 1/N1;
L = dL*OO; % This is the length value that gets input into the final file
% kx1 = sqrt(Ixx1/Area1)*OO; % I might even be able to just compute k using the new version of Ixx
% ky1 = sqrt(Iyy1/Area1)*OO;
% kx2 = sqrt(Ixx2/Area2)*OO;
% ky2 = sqrt(Iyy2/Area2)*OO;
% Compute Ixx at each node on the blade
Ixx(1:segLength1) = Ixx1(1:segLength1); 
Ixx(segLength1+1:segLength1+segLength2) = Ixx2(segLength1+1:segLength1+segLength2);
Ixx(segLength1+segLength2+1:end) = Ixx1(segLength1+segLength2+1:end);
% Compute Iyy at each node on the blade
Iyy(1:segLength1) = Iyy1(1:segLength1); 
Iyy(segLength1+1:segLength1+segLength2) = Iyy2(segLength1+1:segLength1+segLength2);
Iyy(segLength1+segLength2+1:end) = Iyy1(segLength1+segLength2+1:end);
% Compute J at each node on the blade
J = Ixx+Iyy; % I can calculate J this way, so there is no need for Ixx + Iyy
% Compute area vector
Area(1:segLength1) = Area1(1:segLength1); 
Area(segLength1+1:segLength1+segLength2) = Area2(segLength1+1:segLength1+segLength2);
Area(segLength1+segLength2+1:end) = Area1(segLength1+segLength2+1:end);
% Compute radius of gyration in x and y
kx = sqrt(Ixx./Area);
ky = sqrt(Iyy./Area);
% Compute Bending stiffness in the x and y directions
Bstiff_x = E*Ixx;
Bstiff_y = E*Iyy;
% Compute axial stiffness
AxialStiff = E*Area;
% Compute torsoinal stiffness
TorsStiff = E*J;



% Now, I must compute kx,ky,axial stiffness, and all of thoseother
% variables
%Next, I need to combine the structural properties for both arifoils

%A = T{1:5,["Height","Weight"]}
%end