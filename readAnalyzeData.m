function [fileName,headerData,imgData,mzData]=readAnalyzeData()
% This function would take the file name as an input and would read the
% header file information (*.hdr)
% intensity values (*.img)
% mz values (*.t2m)
%it then plots the absolute intensity plot and the relative intensity plot
%for scan 1 of the imaging data file

file = input('Enter the filename: ','s');
[pathstr, fileName, ext] = fileparts(file);
% Reads the *.hdr file and extracts dimensions
headerFile = strcat(fileName,'.hdr');
headerData = analyze75info(headerFile);
headerData = analyze75info(headerFile, 'ByteOrder', 'ieee-le');
dataPoints = [headerData.Dimensions(1)]
x = [headerData.Dimensions(2)]
y = [headerData.Dimensions(3)]
t = [headerData.Dimensions(4)]

% Reads the .img file and extracts the intensity values
imgFile = strcat (fileName,'.img');
imgData = analyze75read(imgFile);    % imgData stores the intensity values column wise

% Reads the .t2m file and extracts the m/z values
mzFile = strcat (fileName,'.t2m');
f1=fopen(mzFile);
mzData = fread(f1,'single'); % mzData stores the mz values in a single row


