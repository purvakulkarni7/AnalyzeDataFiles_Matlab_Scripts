function getAnalyzeData()
% This function would first call the readAnalyzeData.m function and would
% extract all the spectral information

% It then generates a co-ordinate file with all the co-ordinate information
% The script later performs the following functions:
% 1. Baseline Correction
% 2. Smoothning

% Call the function to read the analyze data file
[fileName,imgData,mzData] = readanalyze();

imgData=rot90_3D(imgData,3,1); % rotate in the second dimension 90 degree
size(imgData)

dirName = strcat('OutputData_',fileName);
if exist(dirName,'dir')
    cd(dirName);
    
else
    mkdir(dirName);
    cd(dirName);
end

% coordinateFileId = fopen('Coordinate.txt','w');
% fprintf(coordinateFileId, 'x\t\ty\n');

display('STEP 1: Baseline Correction');

% Set parameters for baseline correction
windowSize = 200;
stepSize = 200;

%//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

for i = 1: length(imgData(:,1,1))
    for j = 1: length(imgData(1,1,:))
        
        % Write co-ordinate values to the Coordinate.txt file
       % fprintf(coordinateFileId, '%d\t\t%d\n',i,j);
        
        % Baseline Correction using msbackadj (inbuild function in MATLAB
        baseLineCorrectedData(i,:,j)=msbackadj(mzData,double(imgData(i,:,j))','WindowSize', windowSize,'STEPSIZE',stepSize,'ShowPlot',false);
        
    end
    baseLineCorrectedData(i,baseLineCorrectedData(i,:,j)<0,j) = 0; % set values smaller than zero to zero, important for normalization
end
%fclose(coordinateFileId);

display('Baseline correction Performed !');

%//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

display('STEP 2: Spectral Smoothning');

% Set parameters for spectral smoothning
SPAN = 10;
ROBUSTITERATION=0;
yE = length(baseLineCorrectedData(:,1,1));
xE = length(baseLineCorrectedData(1,1,:));

baseLineCorrectedData = single(stackSpecs(baseLineCorrectedData)); % After this the size of the data is example: 11235 6501
% Single function converts the vestor to single precision

baseLineCorrectedData = rot90(baseLineCorrectedData,3); % After this the size of the data is example: 6501 11235
% rot90 rotates the matrix by 90*3 degrees

baseLineCorrectedData = flipdim(baseLineCorrectedData,2); % After this the size of the data is example: 6501 11235
% flipdim flips the matrix along the second dimension

SmoothedData = mslowess(mzData,baseLineCorrectedData,'Order',2,'SPAN',SPAN,'robust',ROBUSTITERATION);

SmoothedData = unStackSpecs(SmoothedData',yE,xE);

display('Smoothning Performed !');

%//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

display('STEP 3: Peak Picking');

% Set parameters for peak picking
FWHHFILTER = 0.3;
HEIGHTFILTER = 80;
BASE = 7;
STACKED = 0;
MINIMUMPEAKS = 0;
DECREASESTEP = 5;

SmoothedDataStacked = single(stackSpecs(SmoothedData));

SmoothedDataStacked = rot90(SmoothedDataStacked,3);

SmoothedDataStacked = flipdim(SmoothedDataStacked,2);
flipdimStackedSmoothedsize = size(SmoothedData)

if MINIMUMPEAKS == 0 % no minimum number of peaks
    
    peaks = mspeaks(mzData,SmoothedDataStacked,'FWHHFILTER',FWHHFILTER,'HEIGHTFILTER',HEIGHTFILTER,'BASE',BASE,'PeakLocation',0.5);
    
    indPeak = find(~cellfun(@isempty,peaks));
    
    maxLength=max(cellfun(@length,peaks));
    
    mzGepeakt = zeros(length(peaks),maxLength);
    
    intGepeakt = zeros(length(peaks),maxLength);
    
    for i = 1 : length(indPeak)
        
        mat=peaks{indPeak(i)};
        
        matL=length(mat);
        
        mzGepeakt(indPeak(i),1:matL)=mat(:,1);
        
        intGepeakt(indPeak(i),1:matL)=mat(:,2);
        
    end
    
else
    
    for i = 1 : length(SmoothedDataStacked(1,:))
        
        if ~isempty(unique(SmoothedDataStacked(SmoothedDataStacked(:,i)~=0,i)))
            
            k = 0;
            
            while HEIGHTFILTER-(k*DECREASESTEP) > 0
                
                [mzOne,intOne] = peakOneSpec( mzData,SmoothedDataStacked(:,i),'FWHHFILTER',FWHHFILTER,'HEIGHTFILTER',HEIGHTFILTER-(DECREASESTEP*k),'SMOOTHING',0,'PEAKLOCATION',0.5);% is already smoothed
                
                if length(unique(mzOne(mzOne~=0))) >= MINIMUMPEAKS
                    
                    break;
                    
                end
                
                k = k+1;
                
            end
            
        else
            
            mzOne = 0;
            
            intOne = 0;
            
        end
        
        mzGepeakt(i, 1 : length(mzOne)) = mzOne;
        
        intGepeakt(i, 1 : length(intOne)) = intOne;
        
    end
    
end

[ mzGepeakt,intGepeakt ] = remove_duplicates( mzGepeakt,intGepeakt );% mspeaks create duplicates

if STACKED == 0
    
    mzGepeakt = unStackSpecs(mzGepeakt,yE,xE);
    mzGepeakt = permute(mzGepeakt,[2 1 3]);
    
    intGepeakt = unStackSpecs(intGepeakt,yE,xE);
    intGepeakt = permute(intGepeakt,[2 1 3]); 
end
display('Peak Picking Performed !');

%//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

display('STEP 4: Exporting PeakLists');

% Extract peaked data in individual spectrum files

count = 0;
 for xLoop = 1: length(mzGepeakt(1,:,1))
    for yLoop = 1: length(mzGepeakt(1,1,:))
            count = count + 1;
            spectrumFileName = strcat('Spectrum_',int2str(count),'.txt');
            
            fid = fopen(spectrumFileName,'w+');
            for zLoop = 1:length(mzGepeakt(:,1,1))
                fprintf(fid,'%.3f\t\t%.3f\n',mzGepeakt(zLoop,xLoop,yLoop),intGepeakt(zLoop,xLoop,yLoop));
            end
            fclose(fid);
    end
end

cd('..');

display('Peak List Exported !');

end
