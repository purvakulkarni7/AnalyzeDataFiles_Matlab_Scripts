function extractAnalyzeData()
% This function would first call the readAnalyzeData.m function and would
% extract all the spectral information in seperate files.

% Call the function to read the analyze data file
[fileName,imgData,mzData] = readanalyze();

size(imgData)

dirName = strcat('OutputData_',fileName);
if exist(dirName,'dir')
    cd(dirName);
    
else
    mkdir(dirName);
    cd(dirName);
end

coordinateFileId = fopen('Coordinate.txt','w');
fprintf(coordinateFileId, 'x\t\ty\n');
fclose(coordinateFileId);
count = 0;

coordinateFileId = fopen('Coordinate.txt','a');
for xLoop = 1: length(imgData(1,:,1))
    for yLoop = 1: length(imgData(1,1,:))
            count = count + 1;
            fprintf(coordinateFileId, '%d\t\t%d\n',xLoop,yLoop);
            
            spectrumFileName = strcat('Spectrum_',int2str(count),'.txt');
            
            fid = fopen(spectrumFileName,'w+');
            fprintf(fid,'x\t\ty\n');
            fprintf(fid,'%d\t\t%d\n',xLoop,yLoop);
            fprintf(fid,'mz\t\tint\n');
            for zLoop = 1:length(mzData)
                fprintf(fid,'%.2f\t\t%d\n',mzData(zLoop), imgData(zLoop,xLoop,yLoop));
            end
            fclose(fid);
    end
end
display('Spectra Extracted!');
cd('..');
fclose(coordinateFileId);
