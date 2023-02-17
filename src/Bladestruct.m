%function [D,Mtune,Stune,RayDmp,NumSegments] = Bladestruct(fileLocation,fileName,ElasticModulus,RigidityModulus,MaterialDensity,NumSegments)
    % function Bladestruct(fileLocation,fileName,ElasticModulus,RigidityModulus, ...
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
    %segLength3 = 5;
    ChordLength = 0.0762; % This is 3 inches in meters
    ElasticModulus = 71.1E09; % In Pa
    RigidityModulus = 26.9E09; % in Pa
    NumSegments = 34; % This is the number of panels that comes as an input from the Bladeshape function
    rho = 2810; %kg/m^3 (this will be an input of the function)
    D = zeros(NumSegments,8); % 8 is the number of variables that are currently being output into the structual
    %file
    % I actually Do not think that Mtune, Stune, and RayDmp need to be in
    % this file.
    Mtune = 1; % This is one of the coefficients in rayleigh damping most likely
    % It will probably be an input into this function
    Stune = 1; % THis is also one of the coefficients in rayleight damping most likely
    RayDmp = 0.5; % This is a value that will most likely need to come from BECAS
    
    % I might not even need this zeros matrix
    OO = ones(NumSegments,1);
    Ixx = OO;
    Iyy = OO;
    Area = OO;
    extension = append(fileLocation,'\',fileName);
    T = readtable(extension);
    A1 = T{1:end,foilName{1}}; % Structural Properties of first NACA foil
    A2 = T{1:end,foilName{2}}; % Structural Properties of second NACA foil
    % Extract structural properties for first airfoil
    xcm1 = A1(1)*OO;
    ycm1 = A1(2)*OO;
    Ixx1 = A1(3)*OO;
    Iyy1 = A1(4)*OO;
    Area1 = A1(5)*OO;
    m1 = A1(5)*rho*OO;
    % Extract structural properties for second airfoil
    xcm2 = A2(1)*OO;
    ycm2 = A2(2)*OO;
    Ixx2 = A2(3)*OO;
    Iyy2 = A2(4)*OO;
    Area2 = A2(5)*OO;
    m2 = A2(5)*rho*OO;
    % Develop length variable (applies to both airfoils)
    dL = 1/NumSegments;
    %L = dL*OO; % This is the length value that gets input into the final file
    D(:,1) = dL*OO; %Length
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
    %J = Ixx+Iyy; % I can calculate J this way, so there is no need for Ixx + Iyy
    % Compute area vector
    Area(1:segLength1) = Area1(1:segLength1); 
    Area(segLength1+1:segLength1+segLength2) = Area2(segLength1+1:segLength1+segLength2);
    Area(segLength1+segLength2+1:end) = Area1(segLength1+segLength2+1:end);
    % Compute mass per unit length
    D(1:segLength1,2) = m1(1:segLength1); 
    D(segLength1+1:segLength1+segLength2,2) = m2(segLength1+1:segLength1+segLength2);
    D(segLength1+segLength2+1:end,2) = m1(segLength1+segLength2+1:end);
    % Compute xcm for total blade
    D(1:segLength1,13) = xcm1(1:segLength1); 
    D(segLength1+1:segLength1+segLength2,13) = xcm2(segLength1+1:segLength1+segLength2);
    D(segLength1+segLength2+1:end,13) = xcm1(segLength1+segLength2+1:end);
    D(:,13) = D(:,13)/ChordLength;

    D(1:segLength1,14) = ycm1(1:segLength1); 
    D(segLength1+1:segLength1+segLength2,14) = ycm2(segLength1+1:segLength1+segLength2);
    D(segLength1+segLength2+1:end,14) = ycm1(segLength1+segLength2+1:end);
    D(:,14) = D(:,14)/ChordLength;
    % Compute radius of gyration in x and y
    %kx = sqrt(Ixx./Area);
    %ky = sqrt(Iyy./Area);
    D(:,11) = sqrt(Ixx./Area)/ChordLength;
    D(:,12) = sqrt(Iyy./Area)/ChordLength;
    % Compute Bending stiffness in the x and y directions
    %Bstiff_x = E*Ixx;
    %Bstiff_y = E*Iyy;
    D(:,3) = ElasticModulus*Ixx;
    D(:,4) = ElasticModulus*Iyy;
    % Compute axial stiffness
    %AxialStiff = E*Area;
    D(:,5) = ElasticModulus*Area;
    % Compute torsoinal stiffness
    %TorsStiff = G*J;
    D(:,6) = RigidityModulus*(Ixx+Iyy); % If J is not used elsewhere, then replace J with Ixx+Iyy
    
    %Compute Shear Stiffness
    %ShearStiff = G*Area;
    D(:,7) = RigidityModulus*Area;
    % Compute Shear Factor (We set it equal to zero since it is not used in the
    % simulation)
    %Sfx = 0*OO;
    %Sfy = 0*OO;
    D(:,9) = 0;
    D(:,10) = 0;
    % When you get back, start with radius of gyration
    % Compute Structural Pitch
    %StrPit = 0*OO;
    D(:,8) = 0;
    % Compute Center of elasticity (This will change when we get BECAS running)
    %xce = 0*OO;
    %yce = 0*OO;
    D(:,15) = 0*OO/ChordLength;
    D(:,16) = 0*OO/ChordLength;
    % Compute Center of Shear (This will change when we get BECAS running)
    %xcs = 0*OO;
    %ycs = 0*OO;
    D(:,17) = 0*OO/ChordLength;
    D(:,18) = 0*OO/ChordLength;
    
    % Important note below:
    % I need to clean up this code later....I can do that by deleting a lot of
    % the comments and putting the population of the D matrix in left to right
    % order in terms f colums, i.e. D(:,1) then D(:,2) and so on
    
    
    
    % Do I just want to combine all of these values into a matrix and then have
    % tht be the output of the function?
    
    % Then, I can have another function that populates the file...maybe I can
    % have a single function that populates all of the files, which would mean
    % that I need to make Bladeshape so that it only computes the
    % Now, I must compute kx,ky,axial stiffness, and all of thoseother
    % variables
    %Next, I need to combine the structural properties for both arifoils
    
    %A = T{1:5,["Height","Weight"]}
    %end
%end