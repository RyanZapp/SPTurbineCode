function airfoilConvert(inputFolder,outputFolder)
    % The inputFolder variable and outputFolder variable are paths from C drive
    % to the folder you are resding inputs from and outputs to respectively
    % Get a list of all .dat files in the input folder
    datFiles = dir(fullfile(inputFolder, '*.dat'));
    
    % Loop through the .dat files and convert them to .csv
    for i = 1:length(datFiles)
        % Read the data from the .dat file
        [~, fileName, ~] = fileparts(datFiles(i).name);
        finalM = matrix_array(fullfile(inputFolder, datFiles(i).name),fullfile(outputFolder, [fileName '.csv']));
        writematrix(finalM, fullfile(outputFolder, [fileName '.csv']));
    end

end