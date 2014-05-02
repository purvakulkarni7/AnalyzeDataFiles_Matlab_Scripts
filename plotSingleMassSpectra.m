function plotSingleMassSpectra()

% Function developed specifically for SIMS data sent by Alexander Welle, Mina Dost
% Date: 13 February 2013
% Author: Purva Kulkarni Singh
% Details:
% This function would first ask user to input the file name (format .txt) corressponding to a single m/z spectra
% The program will read the header, coordinate and intensity information in the file.
% the program then generate an image of this data


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileNameInput = input('Enter the filename: ','s');
[pathstr, fileName, ext] = fileparts(fileNameInput);

fid=fopen(fileNameInput);

lineCount=1;

%while ~feof(fid)
while lineCount < 9
    line = fgetl(fid);
    
    if lineCount==2
        % Example of string
        % # Source Interval: 22.99 u (ID: 2)
        
        mzValue = strread(line,'# Source Interval: %f%*[^\n]')
        % The format specifier means the following
        % - '%f' - read a floating point number
        % - '%*[^\n]' - ignore the rest of the string

    end
    
    if lineCount==8
        % Example of string
        % # Image Size: 512 x 512 pixels
        
        [xDimensions yDimensions] = strread(line,'# Image Size: %dx%d%*[^\n]')
        % The format specifier means the following
        % - '%f' - read a floating point number
        % - '%*[^\n]' - ignore the rest of the string

    end
    lineCount = lineCount + 1;   
end

%lineCount=10;
%for lineCount=10:(xDimensions*yDimensions)
   c = textscan(fid,'%d %d %f','HeaderLines',10,'CollectOutput',1);
fclose(fid);
intensityData = accumarray(c{1}+1,c{2});
%end

grayImage = squeeze(intensityData);
imshow(grayImage, []);
   





