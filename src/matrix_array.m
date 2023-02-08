function [finalM] = matrix_array(importfile,exportfile) % Will create an output file, but we will use csv

% Courtesy of JoshTheEngineer 
hdrlns = 1;
if (strcmp(importfile,'nasasc2-0714'))
    hdrlns = 3;
elseif (strcmp(importfile,'s1020'))
    hdrlns = 2;
end

Airfoil = fopen(importfile); % Opens the airfoil data file
dataBuffer = textscan(Airfoil,'%f %f','CollectOutput', 1,'HeaderLines', hdrlns ,'Delimiter',''); % Reads the airfoil data; %f represents floating point numbers; CollectOutput to 1 (true) to collect the consecutive columns of the same class into a single array; Set HeaderLines to 1 
dataX = dataBuffer{1}(:,1); % Airfoil X-data
dataY = dataBuffer{1}(:,2); % Airfoil Y-Data
fclose(Airfoil); % Closes the airfoil data file


dataArr     = [dataX dataY]; % Delete any duplicate (0,0) lines (only need one)
[~,ia,~]    = unique(dataArr,'rows','stable'); % Find the unique values of the array
i           = true(size(dataArr,1),1); % Set every index to true
i(ia)       = false; % Set indices false that are not duplicates
dataArr(i,:) = []; % Get rid of duplicate rows (true to i)
dataX       = dataArr(:,1); % Separate out X-data
dataY       = dataArr(:,2); % Separate out Y-data

if (dataY(1) ~= dataY(end)) % If the start and end points are not the same
    dataX(end+1) = dataX(1); % Create a new X-endpoint to close the airfoil
    dataY(end+1) = dataY(1);  % Create a new Y-endpoint to close the airfoil
end

finalM = [dataX dataY]; % Outputs variables

writematrix(finalM,exportfile) % User able to get export file that can be renamed
end

% Call function by copying and pasting code into command window:
% [finalM] = matrix_array('Naca.dat','NACA.csv')
% I.e.: [finalM] = matrix_array('Naca_2412.dat','NACA2412.csv')