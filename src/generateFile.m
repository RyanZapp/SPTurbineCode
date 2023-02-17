function generateFile(Bladestruct,generic variable 1, generic variable 2,outputLocation)
    outputLocation = 'C:\Users\zipza\Documents\SPCode\QbladeOutputFiles\'; % I should probably be outputting
    % to the input files folder
    fileName = 'BladeFile.txt'; % This needs to be an input
    fileName2 = 'TurbCable.txt';
    extension1 = append(outputLocation,'\',fileName);
    extension2 = append(outputLocation,'\',fileName2);
    N1 = 34;
    %space = ' '; % Using this space command is just a 
    % Waste of memory
    ID = 1;
    DensCab = 2;
    AreaCab = 3;
    IyyCab = 4;
    EModCab = 5;
    RDpCab = 3;
    DiaCab = 2;
    RayDmp = 0.5;
    Mtune = 1;
    Stune = 1;
    %DISC = N1; % This is the number of blade nodes
    %T0 = 'NORMHEIGHT';
    T1 = 'LENGTH_[m]'; % This used to read "POS [m]"
    T2 = 'MASS_[kg/m]';
    T3 = 'Eix_[N.m^2]'; % delete these if this idea does not work
    T4 = 'Eiy_[N.m^2]';
    T5 = 'EA_[N]';
    T6 = 'GJ_[N.m^2]';
    T7 = 'GA_[N]'; % This used to read "POS [m]"
    T8 = 'STRPIT_[deg]';
    T9 = 'KSX_[-]'; % delete these if this idea does not work
    T10 = 'KSY_[-]'; % Shear factor
    T11 = 'RGX_[-]'; % Radius of gyration divided by chord length
    T12 = 'RGY_[-]';
    T13 = 'XCM_[-]';
    T14 = 'YCM_[-]';
    T15 = 'XCE_[-]'; % delete these if this idea does not work
    T16 = 'YCE_[-]';
    T17 = 'XCS_[-]';
    T18 = 'YCS_[-]';
    
    %s1 = 'NORMHEIGHT';
    %s2 = 'RAYLEIGHDMP';
    %s3 = 'STIFFTUNER';
    %s4 = 'MASSTUNER';
    %s5 = 'DISC';
    
%     k = zeros(2,1);
%     timeSpec = 'Time : %s\n';
%     Time = datetime('now','TimeZone','local','Format','HH:mm:ss');
%     dateSpec = 'Date : %s\n';
%     Date = datetime('now','TimeZone','local','Format','dd.MM.yyyy');
%     %formatSpec = '%.5f';
    
    % Name your Blade File Below
    %fid = fopen('C:\Users\zipza\Documents\SPCode\QbladeInputFiles\BladeFile.txt','w');
    fid = fopen(extension1,'w');
    fprintf(fid,'NORMHEIGHT');
    fprintf(fid,'\n');
    fprintf(fid,'\n'); 
    fprintf(fid,'%.4f',RayDmp); % Replace with Rayleigh Damp output
    for i = 1:2
        fprintf(fid,' ');
    end
    fprintf(fid,'RAYLEIGHDMP\n');
    fprintf(fid,'%.1f',Stune);
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'STIFFTUNER\n');
    fprintf(fid,'%.1f',Mtune);
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'MASSTUNER\n');
    fprintf(fid,'\n');
    fprintf(fid,'%i',N1);
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'DISC\n');
    fprintf(fid,'\n');
    fprintf(fid,T1);
    fprintf(fid,' ');
    fprintf(fid,T2);
    fprintf(fid,' ');
    fprintf(fid,T3);
    fprintf(fid,' ');
    fprintf(fid,T4);
    fprintf(fid,' ');
    fprintf(fid,T5);
    fprintf(fid,' ');
    fprintf(fid,T6);
    fprintf(fid,' ');
    fprintf(fid,T7);
    fprintf(fid,' ');
    fprintf(fid,T8);
    fprintf(fid,' ');
    fprintf(fid,T9);
    fprintf(fid,' ');
    fprintf(fid,T10);
    fprintf(fid,' ');
    fprintf(fid,T11);
    fprintf(fid,' ');
    fprintf(fid,T12);
    fprintf(fid,' ');
    fprintf(fid,T13);
    fprintf(fid,' ');
    fprintf(fid,T14);
    fprintf(fid,' ');
    fprintf(fid,T15);
    fprintf(fid,' ');
    fprintf(fid,T16);
    fprintf(fid,' ');
    fprintf(fid,T17);
    fprintf(fid,' ');
    fprintf(fid,T18);
    fprintf(fid,' ');
    fprintf(fid,'\n');
    for j = 1:N1
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

    fid = fopen(extension2,'w');
    fprintf(fid,'\n');
    fprintf('CABELEMENTS');
    fprintf('\n');
    fprintf('ID');
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
    fprintf(fid,'Dia[m]');
    fprintf(fid,'\n');
    fprintf(fid,'%i',ID);
    fprintf(fid,' ');
    fprintf(fid,'%.2f',DensCab);
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'%.3e',AreaCab);
    fprintf(fid,' ');
    fprintf(fid,'%.3e',IyyCab);
    fprintf(fid,' ');
    fprintf(fid,'%.3e',EModCab);
    fprintf(fid,' ');
    fprintf(fid,'%.2f',RDpCab);
    fprintf(fid,' ');
    fprintf(fid,'%.2f',DiaCab);
    fprintf(fid,'\n');
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
    fprintf(fid,'%i',1);
    fprintf(fid,' ');
    fprintf(fid,'TRQ_1.0');
    for i = 1:3
        fprintf(fid,' ');
    end
    fprintf(fid,'Replace with legit stuff');
    fclose('all');
end