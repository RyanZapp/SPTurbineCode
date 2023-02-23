%function generateFile(Bladestruct,generic variable 1, generic variable 2,outputLocation)
function generateFile(segLength1,segLength2,bladeNodes,H,AR,ChordLength,numBlades,bladeName, ...
    bladeshapeExtension,bladestructExtension,MathematicaOutputExtension,foilNames,EBlade,GBlade, ...
    rhoBlade,cableExtension,rhoCable,ECable,CableDiam,numCables,anchorPoints,CableTension,MtuneBlade, ...
    StuneBlade,RayDmpBlade,RDpCab,cableNodes,topConnection,topAnchor,cableTypes,ETrq,GTrq,rhoTrq, ...
    MTuneTrq,STuneTrq,RDmpTrq,trqNodes,ODTrq,IDTrq,trqExtension,TrqLength,rhoTwr,ODTwr,IDTwr,TwrLength, ...
    ETwr,GTwr,MTuneTwr,STuneTwr,RDmpTwr,twrNodes,twrExtension,mainExtension,epsilon,gbr,gbe,ddTF,gsi, ...
    dts,dtd,mbt,bdeploy,bdelay,BladeStruct_fileName,Cable_fileName,Torquetube_fileName,Tower_fileName, ...
    TrqClear,hubPos,trqtbconn,rtrClear,bldconn,dataTypes,dataNames)

    format long
% Super important note, the next thing I need to do is write a code that
% multiplies all airfoil coordinate values by 3 so that it goes from 1 inch
% chord to 3 inch chord
    bladeNum = numBlades; % this is the number of blades, but stored as an integer
    numBlades = num2str(numBlades);
    deltaBld = 10;
    deltaBld = 1/deltaBld;
    deltaTwr = 3;
    deltaTwr = 1/deltaTwr;
    deltaTrq = 6;
    deltaTrq = 1/deltaTrq;
    deltaCable = 1;
    bldLine = 0:deltaBld:1;
    twrLine = 0:deltaTwr:1;
    trqLine = 0:deltaTrq:1;
    cabLine = 0:deltaCable:1;
    ChordLength = 0.0254*ChordLength; % This converts ChordLength from inches to meters
    CableDiam = 0.0254*CableDiam; % Convert CableDiam from inches to meters
    % Having inputs to the nested functions be inputs of the parent
    % function works perfectly
    [Chord,Twist,Circ,Height,Radius,TAxis] = Bladeshape(segLength1,segLength2,bladeNodes,H,AR,ChordLength);
    % This function computes the blade structural files
    D = Bladestruct(segLength1,segLength2,MathematicaOutputExtension,foilNames, ...
    EBlade,GBlade,rhoBlade,bladeNodes,ChordLength);

    [AreaCable,IyyCable] = Cablestruct(CableDiam);

    [Ixx_Trq,Iyy_Trq,Area_Trq,Mass_Trq,RGX_Trq,RGY_Trq] = Trqstruct(rhoTrq,ODTrq,IDTrq,TrqLength);

    [Ixx_Twr,Iyy_Twr,Area_Twr,Mass_Twr,RGX_Twr,RGY_Twr] = Twrstruct(rhoTwr,ODTwr,IDTwr,TwrLength);
    % I feel like it is a good idea to read in all of the function files
    % first at the top
    k1 = '---------------------- QBLADE STRUCTURAL MODEL INPUT FILE -----------------';
    k2 = '------------------------------- CHRONO PARAMETERS -------------------------';
    k3 = '------------------------------- MASS AND INERTIA --------------------------';
    k4 = '------------------------------- DRIVETRAIN MODEL --------------------------';
    k5 = '------------------------------- BRAKE MODEL -------------------------------';
    k6 = '------------------------------- SENSOR ERRORS -----------------------------';
    k7 = '------------------------------- BLADES ------------------------------------';
    k8 = '------------------------------- STRUTS ------------------------------------';
    k9 = '------------------------------- TOWER AND TORQUE TUBE ---------------------';
    k10 = '------------------------------- BLADE CABLES (VAWT only) ------------------';
    k11 = '------------------------------- DATA OUTPUT TYPES -------------------------';
    k12 = '------------------------------- DATA OUTPUT LOCATIONS ---------------------';

    % This segment below creates the text file for the blade shape
    s1 = '----------------------------------------QBlade Blade Definition File------------------------------------------------';
    s2 = '----------------------------------------Object Name-----------------------------------------------------------------';
    s3 = '----------------------------------------Parameters------------------------------------------------------------------';
    s4 = '----------------------------------------Blade Data------------------------------------------------------------------';
    
    timeSpec = 'Time : %s\n';
    Time = datetime('now','TimeZone','local','Format','HH:mm:ss');
    dateSpec = 'Date : %s\n';
    Date = datetime('now','TimeZone','local','Format','dd.MM.yyyy');
    
   
    fid = fopen(bladeshapeExtension,'w');
    fprintf(fid,s1);
    fprintf(fid,'\n');
    fprintf(fid,'Generated with : QBlade CE v 2.0.4.8_alpha windows\n');
    fprintf(fid,'Archive Format: 310002\n');
    fprintf(fid,timeSpec,Time);
    fprintf(fid,dateSpec,Date);
    fprintf(fid,'\n');
    fprintf(fid,s2);
    fprintf(fid,'\n');
    fprintf(fid,bladeName);
    for j = 1:(41 - length(bladeName))
        fprintf(fid,' ');
    end
    fprintf(fid,'OBJECTNAME');
    for j = 1:9
        fprintf(fid,' ');
    end
    fprintf('- the name of the blade object\n');
    fprintf(fid,'\n');
    fprintf(fid,s3);
    fprintf(fid,'\n');
    fprintf(fid,'VAWT');
    for j = 1:37
        fprintf(fid,' ');
    end
    fprintf(fid,'ROTORTYPE');
    for j = 1:10
        fprintf(fid,' ');
    end
    fprintf(fid,'- the rotor type\n');
    fprintf(fid,numBlades);
    for j = 1:40
        fprintf(fid,' ');
    end
    fprintf(fid,'NUMBLADES');
    for j = 1:10
        fprintf(fid,' ');
    end
    fprintf(fid,'- number of blades\n');
    fprintf(fid,s4);
    fprintf(fid,'\n');
    fprintf(fid,'HEIGHT [m]');
    for j = 1:(20-length('HEIGHT [m]'))
        fprintf(fid,' ');
    end
    fprintf(fid,'CHORD [m]');
    % spacings of 20
    for j = 1:(20-length('CHORD [m]'))
        fprintf(fid,' ');
    end
    fprintf(fid,'RADIUS [m]');
    for j = 1:(20-length('RADIUS [m]'))
        fprintf(fid,' ');
    end
    fprintf(fid,'TWIST [deg]');
    for j = 1:(20-length('TWIST [deg]'))
        fprintf(fid,' ');
    end
    fprintf(fid,'CIRC [deg]');
    for j = 1:(20-length('CIRC [deg]'))
        fprintf(fid,' ');
    end
    fprintf(fid,'TAXIS [-]');
    for j = 1:(20-length('TAXIS [-]'))
        fprintf(fid,' ');
    end
    fprintf(fid,'\n');
    for j = 1:bladeNodes
        fprintf(fid,Height(j,:));
        for i = 1:(20-length(Height(j,:)))
            fprintf(fid,' ');
        end
        fprintf(fid,Chord(j,:));
        for i = 1:(20-length(Chord(j,:)))
            fprintf(fid,' ');
        end
        fprintf(fid,Radius(j,:));
        for i = 1:(20-length(Radius(j,:)))
            fprintf(fid,' ');
        end
        fprintf(fid,Twist(j,:));
        for i = 1:(20-length(Twist(j,:)))
            fprintf(fid,' ');
        end
        fprintf(fid,Circ(j,:));
        for i = 1:(20-length(Circ(j,:)))
            fprintf(fid,' ');
        end
        fprintf(fid,TAxis(j,:));
        for i = 1:(20-length(TAxis(j,:)))
            fprintf(fid,' ');
        end
        fprintf(fid,'\n');
    end

    fclose('all');
    % This marks the end of the creation of the bladeshape text file


    % I think the move might be to read these file inputs as inputs
    % themselves
    %LL = Tempfile(k1); % A direct function call with a variable assignment most definitely works
    %disp(Tempfile(k1)) % Directly printing the output of a function also works as well
    %disp(10*LL)
    %outputLocation = 'C:\Users\zipza\Documents\SPCode\QbladeOutputFiles\'; % I should probably be outputting
    % to the input files folder
    %fileName = 'BladeFile.txt'; % This needs to be an input
    %fileName2 = 'TurbCable.txt';
    %extension1 = append(outputLocation,'\',fileName);
    %extension2 = append(outputLocation,'\',fileName2);
    %bladeNodes = 34;
    % The input numbers below need to stay as is for now because I have no
    % idea how to calculate them
    
    % Name your Blade File Below
    fid = fopen(bladestructExtension,'w');
    fprintf(fid,'NORMHEIGHT');
    fprintf(fid,'\n');
    fprintf(fid,'\n'); 
    fprintf(fid,'%.4f',RayDmpBlade); % Replace with Rayleigh Damp output
    for i = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'RAYLEIGHDMP\n');
    fprintf(fid,'%.1f',StuneBlade);
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'STIFFTUNER\n');
    fprintf(fid,'%.1f',MtuneBlade);
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'MASSTUNER\n');
    fprintf(fid,'\n');
    fprintf(fid,'%i',bladeNodes);
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'DISC\n');
    fprintf(fid,'\n');
    fprintf(fid,'LENGTH_[m]');
    fprintf(fid,' ');
    fprintf(fid,'MASS_[kg/m]');
    fprintf(fid,' ');
    fprintf(fid,'Eix_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'Eiy_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'EA_[N]');
    fprintf(fid,' ');
    fprintf(fid,'GJ_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'GA_[N]');
    fprintf(fid,' ');
    fprintf(fid,'STRPIT_[deg]');
    fprintf(fid,' ');
    fprintf(fid,'KSX_[-]');
    fprintf(fid,' ');
    fprintf(fid,'KSY_[-]');
    fprintf(fid,' ');
    fprintf(fid,'RGX_[-]');
    fprintf(fid,' ');
    fprintf(fid,'RGY_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCM_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCM_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCE_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCE_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCS_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCS_[-]');
    fprintf(fid,' ');
    fprintf(fid,'\n');
    for j = 1:bladeNodes
        for i = 1:18
            fprintf(fid,'%.4e',D(j,i));
            if i ~= 18
                fprintf(fid,' ');
            else
                fprintf(fid,'\n');
            end
        end
    end
    fclose('all');

% Begin the creation of the cable file
    fid = fopen(cableExtension,'w');
    fprintf(fid,'\n');
    fprintf(fid,'CABELEMENTS');
    fprintf(fid,'\n');
    fprintf(fid,'ID');
    fprintf(fid,' ');
    fprintf(fid,'Dens.[kg/m^3]');
    fprintf(fid,' ');
    fprintf(fid,'Area[m^2]');
    fprintf(fid,' ');
    fprintf(fid,'Iyy[m^4]');
    fprintf(fid,' ');
    fprintf(fid,'EMod[N/m^4]');
    fprintf(fid,' ');
    fprintf(fid,'RDp.[-]');
    fprintf(fid,' ');
    fprintf(fid,'Dia[m]');
    fprintf(fid,'\n');
    for j = 1:cableTypes
        fprintf(fid,'%i',j);
        fprintf(fid,' ');
        fprintf(fid,'%.2f',rhoCable(j));
        for i = 1:3
            fprintf(fid,' ');
        end
        fprintf(fid,'%.3e',AreaCable(j));
        fprintf(fid,' ');
        fprintf(fid,'%.3e',IyyCable(j));
        fprintf(fid,' ');
        fprintf(fid,'%.3e',ECable(j));
        fprintf(fid,' ');
        fprintf(fid,'%.2f',RDpCab(j));
        fprintf(fid,' ');
        fprintf(fid,'%.2f',CableDiam(j));
        fprintf(fid,'\n');
    end
    fprintf(fid,'\n');
    fprintf(fid,'CABMEMBERS');
    fprintf(fid,'\n');
    fprintf(fid,'ID');
    fprintf(fid,' ');
    fprintf(fid,'CONN_1');
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'CONN_2');
    for i = 1:4
        fprintf(fid,' ');
    end
    fprintf(fid,'TENSION[N]');
    fprintf(fid,' ');
    fprintf(fid,'CabID');
    for i = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'Drag');
    fprintf(fid,' ');
    fprintf(fid,'ElmDsc');
    fprintf(fid,' ');
    fprintf(fid,'Name');
    fprintf(fid,'\n');
    for i = 1:numCables
        fprintf(fid,'%i',i);
        fprintf(fid,' ');
        fprintf(fid,'%s_%.2f',topAnchor{i},topConnection(i));
        for j = 1:3
            fprintf(fid,' ');
        end
        fprintf(fid,'GRD_');
        fprintf(fid,'%.2f_%.2f',anchorPoints{i}(1),anchorPoints{i}(2));
        for j = 1:2
            fprintf(fid,' ');
        end
        fprintf(fid,'%.3e',CableTension);
        fprintf(fid,' ');
        fprintf(fid,'%i',1);
        for j= 1:2
            fprintf(fid,' ');
        end
        fprintf(fid,'%.2f',0.99);
        fprintf(fid,' ');
        fprintf(fid,'%i',cableNodes);
        for j = 1:2
            fprintf(fid,' ');
        end
        fprintf(fid,'GuyCable%i',i);
        if i ~= length(1:numCables)
            fprintf(fid,'\n');
        end
    end

    fclose('all');

    fid = fopen(trqExtension,'w');
    fprintf(fid,'%.4f',RDmpTrq);
    for j = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'RAYLEIGHDMP\n');
    fprintf(fid,'%.1f',STuneTrq);
    for j = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'STIFFTUNER\n');
    fprintf(fid,'%.1f',MTuneTrq);
    for j = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'MASSTUNER\n\n'); % does this work?
    fprintf(fid,'%i',trqNodes);
    for j = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'DISC\n\n');
    fprintf(fid,'LENGTH_[-]'); % This is in meters in the sania file, but I
    % Think I am right and Sandia is wrong
    fprintf(fid,' ');
    fprintf(fid,'MASS_[kg/m]');
    fprintf(fid,' ');
    fprintf(fid,'Eix_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'Eiy_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'EA_[N]');
    fprintf(fid,' ');
    fprintf(fid,'GJ_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'GA_[N]');
    fprintf(fid,' ');
    fprintf(fid,'STRPIT_[deg]');
    fprintf(fid,' ');
    fprintf(fid,'KSX_[-]');
    fprintf(fid,' ');
    fprintf(fid,'KSY_[-]');
    fprintf(fid,' ');
    fprintf(fid,'RGX_[-]');
    fprintf(fid,' ');
    fprintf(fid,'RGY_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCM_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCM_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCE_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCE_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCS_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCS_[-]');
    fprintf(fid,' ');
    fprintf(fid,'DIA_[m]');
    fprintf(fid,'\n');
    for i = 1:2
        if i == 1
            fprintf(fid,'%.4e',0);
        else
            fprintf(fid,'%.4e',1);
        end
        fprintf(fid,' ');
        fprintf(fid,'%.4e',Mass_Trq/TrqLength); % MAss
        fprintf(fid,' ');
        fprintf(fid,'%.4e',ETrq*Ixx_Trq);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',ETrq*Iyy_Trq);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',ETrq*Area_Trq);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',GTrq*(Ixx_Trq+Iyy_Trq));
        fprintf(fid,' ');
        fprintf(fid,'%.4e',GTrq*Area_Trq);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',0); % Struct pitch
        fprintf(fid,' ');
        fprintf(fid,'%.4e',0); % shear factor x
        fprintf(fid,' ');
        fprintf(fid,'%.4e',0); % shear factor y
        fprintf(fid,' ');
        fprintf(fid,'%.4e',RGX_Trq/TrqLength); % Radius of Gyration X per unit length
        fprintf(fid,' ');
        fprintf(fid,'%.4e',RGY_Trq/TrqLength);
        fprintf(fid,' ');
        for j = 1:6
            fprintf(fid,'%.4e',0); % Represents XCM,YCM,XCE,YCE,XCS,YCS 
            % We know these values will be zero for a circular cross-section
            fprintf(fid,' ');
        end
        fprintf(fid,'%.4e',ODTrq);
        if i == 1
            fprintf(fid,'\n');
        end
    end
    fclose('all');


    fid = fopen(twrExtension,'w');
    fprintf(fid,'%.4f',RDmpTwr);
    for j = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'RAYLEIGHDMP\n');
    fprintf(fid,'%.1f',STuneTwr);
    for j = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'STIFFTUNER\n');
    fprintf(fid,'%.1f',MTuneTwr);
    for j = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'MASSTUNER\n\n'); % does this work?
    fprintf(fid,'%i',twrNodes);
    for j = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'DISC\n\n');
    fprintf(fid,'LENGTH_[-]'); % This is in meters in the sania file, but I
    % Think I am right and Sandia is wrong
    fprintf(fid,' ');
    fprintf(fid,'MASS_[kg/m]');
    fprintf(fid,' ');
    fprintf(fid,'Eix_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'Eiy_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'EA_[N]');
    fprintf(fid,' ');
    fprintf(fid,'GJ_[N.m^2]');
    fprintf(fid,' ');
    fprintf(fid,'GA_[N]');
    fprintf(fid,' ');
    fprintf(fid,'STRPIT_[deg]');
    fprintf(fid,' ');
    fprintf(fid,'KSX_[-]');
    fprintf(fid,' ');
    fprintf(fid,'KSY_[-]');
    fprintf(fid,' ');
    fprintf(fid,'RGX_[-]');
    fprintf(fid,' ');
    fprintf(fid,'RGY_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCM_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCM_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCE_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCE_[-]');
    fprintf(fid,' ');
    fprintf(fid,'XCS_[-]');
    fprintf(fid,' ');
    fprintf(fid,'YCS_[-]');
    fprintf(fid,' ');
    fprintf(fid,'DIA_[m]');
    fprintf(fid,'\n');
    for i = 1:2
        if i == 1
            fprintf(fid,'%.4e',0);
        else
            fprintf(fid,'%.4e',1);
        end
        fprintf(fid,' ');
        fprintf(fid,'%.4e',Mass_Twr/TwrLength); % MAss
        fprintf(fid,' ');
        fprintf(fid,'%.4e',ETwr*Ixx_Twr);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',ETwr*Iyy_Twr);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',ETwr*Area_Twr);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',GTwr*(Ixx_Twr+Iyy_Twr));
        fprintf(fid,' ');
        fprintf(fid,'%.4e',GTwr*Area_Twr);
        fprintf(fid,' ');
        fprintf(fid,'%.4e',0); % Struct pitch
        fprintf(fid,' ');
        fprintf(fid,'%.4e',0); % shear factor x
        fprintf(fid,' ');
        fprintf(fid,'%.4e',0); % shear factor y
        fprintf(fid,' ');
        fprintf(fid,'%.4e',RGX_Twr/TwrLength); % Radius of Gyration X per unit length
        fprintf(fid,' ');
        fprintf(fid,'%.4e',RGY_Twr/TwrLength);
        fprintf(fid,' ');
        for j = 1:6
            fprintf(fid,'%.4e',0); % Represents XCM,YCM,XCE,YCE,XCS,YCS 
            % We know these values will be zero for a circular cross-section
            fprintf(fid,' ');
        end
        fprintf(fid,'%.4e',ODTwr); % I guess we can just use the OD for the diameter value
        if i == 1
            fprintf(fid,'\n');
        end
    end
    fclose('all');
    
   

    fid = fopen(mainExtension,'w');
    fprintf(fid,k1);
    fprintf(fid,'\n');
    fprintf(fid,'SP group 5 ft VAWT\n');
    fprintf(fid,k2);
    fprintf(fid,'\n');
    fprintf(fid,'%.2f',epsilon);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'GLBGEOEPS - Global geometry epsilon for node placement\n');
    fprintf(fid,'\n');
    fprintf(fid,k3);
    fprintf(fid,'\n');
    fprintf(fid,'%i',0); % Hub mass
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'HUBMASS - Hub Mass (kg)\n');
    fprintf(fid,'%i',0); % Hub inertia
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'HUBINER - Hub Inertia (kg*m^2)\n');
    fprintf(fid,'\n');
    fprintf(fid,k4);
    fprintf(fid,'\n');
    fprintf(fid,'%i',gbr); % gearbox ratio
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'GBRATIO - gearbox ratio (N)\n');
    fprintf(fid,'%i',gbe);
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'GBOXEFF - gearbox efficiency (0-1)\n');
    fprintf(fid,'%s',ddTF);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'DRTRDOF - model drivetrain dynamics (true / false)\n');
    fprintf(fid,'%i',gsi);
    for j = 1:6
        fprintf(fid,'\t'); % it might be 3 tab spaces instead of regular ones
    end
    fprintf(fid,'GENINER - Generator side (HSS) Inertia (kg*m^2)\n');
    fprintf(fid,'%i',dts);
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'DTTORSPR - Drivetrain torsional stiffness (N*m/rad)\n');
    fprintf(fid,'%i',dtd);
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'DTTORDMP - Drivetrain torsional damping (N*m*s/rad)\n');
    fprintf(fid,'\n');
    fprintf(fid,k5);
    fprintf(fid,'\n');
    fprintf(fid,'%i',mbt);
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'BRKTORQUE - maximum brake torque (s)\n');
    fprintf(fid,'%i',bdeploy);
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'BRKDEPLOY - brake deploy time (s) (only used with DTU style controllers)\n');
    fprintf(fid,'%i',bdelay);
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'BRKDELAY - brake delay time (s) (only used with DTU style controllers)\n');
    fprintf(fid,'\n');
    fprintf(fid,k6);
    fprintf(fid,'\n');
    for i = 1:3
        fprintf(fid,'%i',0);
        for j = 1:6
            fprintf(fid,'\t');
        end
        fprintf(fid,'ERRORPITCH_%i - pitch error blade %i (deg)\n',i,i);
    end
    fprintf(fid,'\n');
    fprintf(fid,k7);
    fprintf(fid,'\n');
    fprintf(fid,'%s',numBlades);
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'NUMBLD - Number of blades\n');
    for i = 1:bladeNum
        fprintf(fid,'%s',BladeStruct_fileName);
        for j = 1:2
            fprintf(fid,'\t');
        end
        fprintf(fid,'BLDFILE_%i - Name of file containing properties for blade %i\n',i,i);
    end
    fprintf(fid,'\n');
    fprintf(fid,k8);
    fprintf(fid,'\n');
    for i = 1:bladeNum
        fprintf(fid,'*');
        for j = 1:6
            fprintf(fid,'\t');
        end
        fprintf(fid,'STRTFILE_%i - Name of file containing properties for strut%i (if blade has struts)\n',i,i);
    end
    fprintf(fid,'*');
    for j = 1:6
        fprintf(fid,'\t');
    end
    fprintf(fid,'STRTDISC - Number of structural nodes per strut\n');
    fprintf(fid,'\n');
    fprintf(fid,k9);
    fprintf(fid,'\n');
    fprintf(fid,'%.2f',TwrLength);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'TWRHEIGHT - Height of the (fixed - non rotating) tower [m]\n');
    fprintf(fid,'%s',Tower_fileName);
    for j = 1:3
        fprintf(fid,'\t');
    end
    fprintf(fid,'TWRFILE - Name of file containing properties for the tower\n');
    fprintf(fid,'\n');
    fprintf(fid,'%.2f',TrqLength);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'TRQTBHEIGHT - Height (or length) of the torque tube (the rotating part of the tower) [m]\n');
    fprintf(fid,'%s',Torquetube_fileName);
    for j = 1:2
        fprintf(fid,'\t');
    end
    fprintf(fid,'TRQTBFILE - Name of file containing properties for the torque tube\n');
    fprintf(fid,'\n');
    fprintf(fid,'%.2f',TrqClear);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'TRQTBCLEAR - Clearance of the torque tube, must be <= TWRHEIGHT [m]\n');
    fprintf(fid,'%.2f',hubPos);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'HUBPOS - height position of the generator hub that is connecting the torque tube with the fixed tower (VAWT only) [m]\n');
    fprintf(fid,'%.2f',trqtbconn);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'TRQTBCONN - Absolute height position, starting after torque clearance, of a frictionless bearing that connects the torque tube to the fixed tower [m]\n');
    fprintf(fid,'\n');
    fprintf(fid,'%.2f',rtrClear);
    for j = 1:5
        fprintf(fid,'\t');
    end
    fprintf(fid,'RTRCLEAR - Rotor clearance\n');
    for i = 1:2
        fprintf(fid,'%.3f',bldconn(i));
        for j = 1:5
            fprintf(fid,'\t');
        end
        fprintf(fid,'BLDCONN - Absolute height position, starting after rotor clearance of blade, of the rigid blade torque tube connection %i in [m] (VAWT only)\n',i);
    end
    fprintf(fid,'\n');
    fprintf(fid,k10);
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'%s',Cable_fileName);
    for j = 1:3
        fprintf(fid,'\t');
    end
    fprintf(fid,'CABFILE - file containing the definitions of cables\n');
    fprintf(fid,'\n');
    fprintf(fid,k11);
    fprintf(fid,'\n');
    for i = 1:9
        fprintf(fid,'%s',dataTypes{i});
        for j = 1:5
            fprintf(fid,'\t');
        end
        fprintf(fid,'%s - store %s at all chosen locations\n',dataNames{i}{1},dataNames{i}{2});
    end
    fprintf(fid,'\n');
    fprintf(fid,k12);
    fprintf(fid,'\n');
    fprintf(fid,'any number, or zero, user defined positions can be chosen as output locations. locations can be assigned at any of the following components:\n');
    fprintf(fid,'blades, struts, tower and guy cables. See the following examples for the used nomenclature:\n');
    fprintf(fid,'\n');
    for i = 1:bladeNum
        for j = 1:length(bldLine)
        fprintf(fid,'BLD_%i_%.4f\t\t\t- exemplary position, blade %i at  %.1f%s normalized radius\n',i,bldLine(j),i,100*bldLine(j),'%'); % I need to finish this part
        end
        fprintf(fid,'\n');
    end
    for i = 1:length(twrLine)
        fprintf(fid,'TWR_%.4f\t\t\t\t- exemplary position, tower at %.1f%s normalized height\n',twrLine(i),100*twrLine(i),'%');
    end
    fprintf(fid,'\n');
    for i = 1:length(trqLine)
        fprintf(fid,'TRQ_%.4f\t\t\t\t- exemplary position, tower at %.1f%s normalized height\n',trqLine(i),100*trqLine(i),'%');
    end
    fprintf(fid,'\n');
    % From here, all I need to do is finish up the cable file inputs
    for i = 1:numCables
        for j = 1:length(cabLine)
            fprintf(fid,'CAB_%i_%.1f\t\t\t\t- exemplary position, cable %i at %i%s normalized length\n',i,cabLine(j),i,100*cabLine(j),'%');
        end
        if i ~= numCables
            fprintf(fid,'\n');
        end
    end

    % The connector value is, in fact the height at which the connector
    % nodes are placed
    % I wonder if I should be using \t for tab spacing?
    % When you come back, finissh the rough main file

    % during the meeting, figure out if Richard's code is right
    % get the proper airfoil output from Leon
    % 
    


    % From this point, you will need to output your values

    
end