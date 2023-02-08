finalM = importdata("nasasc2-0714.csv");

[TopX, TopY, BottomX, BottomY] = AssortingDatFile(finalM)

% [Mfinal] = ScanAndSortDatFile(finalM)

% In Matlab, type matrix_array('airfoil.dat','airfoil.csv') into the command, and export it as the 2nd file for future use
% Replace csv file in this script to appropiate NACA airfoil
% Essentially, run the matrix_array first, then run this script 