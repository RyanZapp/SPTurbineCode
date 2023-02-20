function D = Bladestruct(segLength1,segLength2,MathematicaOutputExtension,foilNames, ...
    EBlade,GBlade,rhoBlade,bladeNodes,ChordLength)

    D = zeros(bladeNodes,8); % 8 is the number of variables that are currently being output into the structual
    
    OO = ones(bladeNodes,1);
    Ixx = OO;
    Iyy = OO;
    Area = OO;

    T = readtable(MathematicaOutputExtension);
    A1 = T{1:end,foilNames{1}}; % Structural Properties of first NACA foil
    A2 = T{1:end,foilNames{2}}; % Structural Properties of second NACA foil
    % Extract structural properties for first airfoil
    xcm1 = A1(1)*OO;
    ycm1 = A1(2)*OO;
    Ixx1 = A1(3)*OO;
    Iyy1 = A1(4)*OO;
    Area1 = A1(5)*OO;
    m1 = A1(5)*rhoBlade*OO;
    % Extract structural properties for second airfoil
    xcm2 = A2(1)*OO;
    ycm2 = A2(2)*OO;
    Ixx2 = A2(3)*OO;
    Iyy2 = A2(4)*OO;
    Area2 = A2(5)*OO;
    m2 = A2(5)*rhoBlade*OO;
    % Develop length variable (applies to both airfoils)
    dL = 1/bladeNodes;
    D(:,1) = dL*OO; %Length
    % Compute Ixx at each node on the blade
    Ixx(1:segLength1) = Ixx1(1:segLength1); 
    Ixx(segLength1+1:segLength1+segLength2) = Ixx2(segLength1+1:segLength1+segLength2);
    Ixx(segLength1+segLength2+1:end) = Ixx1(segLength1+segLength2+1:end);
    % Compute Iyy at each node on the blade
    Iyy(1:segLength1) = Iyy1(1:segLength1); 
    Iyy(segLength1+1:segLength1+segLength2) = Iyy2(segLength1+1:segLength1+segLength2);
    Iyy(segLength1+segLength2+1:end) = Iyy1(segLength1+segLength2+1:end);
    % Compute J at each node on the blade
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
    D(:,11) = sqrt(Ixx./Area)/ChordLength; % RGx
    D(:,12) = sqrt(Iyy./Area)/ChordLength; %RGy
    % Compute Bending stiffness in the x and y directions
    D(:,3) = EBlade*Ixx; % EIxx
    D(:,4) = EBlade*Iyy; % EIyy
    % Compute axial stiffness
    D(:,5) = EBlade*Area; % EA
    % Compute torsoinal stiffness
    D(:,6) = GBlade*(Ixx+Iyy); % GJ
    
    %Compute Shear Stiffness
    D(:,7) = GBlade*Area; % GA
    % Compute Shear Factor
    D(:,9) = 0; % Shear factor in x (Qblade does not use this value)
    D(:,10) = 0;% Shear factor in y (Qblade does not use this value)
    % When you get back, start with radius of gyration
    % Compute Structural Pitch
    D(:,8) = 0; % Structural pitch (zero for VAWTs)
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
end