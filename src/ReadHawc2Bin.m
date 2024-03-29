function sig = ReadHawc2Bin(FileName,path)
% Reads binary QBlade results file
% -------------------------------------
% [t,sig] = ReadFlex4(FileName,Ch);
% filename should be without extension
% -------------------------------------
% Framework inspiration - BSKA 2008
% Framework and interfacing - Hurricane Powered Wind Turbine Team 2022
% --------------------------------------
ThisPath = pwd; cd(path(1,:))
% reading scale factors from *.sel file
fid = fopen([FileName,'.sel'], 'r'); fgets(fid); fgets(fid);
fgets(fid); fgets(fid); fgets(fid); fgets(fid); fgets(fid);
fgets(fid);
tline = fscanf(fid,'%d');
N = tline(1); Nch = tline(2); Time = tline(3); fclose(fid);
ScaleFactor = dlmread([FileName,'.sel'],'',[9+Nch+5 0 9+2*Nch+4 0]);
% reading binary data file
fid = fopen([FileName,'.dat'], 'r'); 
sig = fread(fid,[N,Nch],'int16')*diag(ScaleFactor); fclose(fid);
cd(ThisPath)
