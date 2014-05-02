function imageAnalyzeData()
% This function takes filename and userdefined m/z value and would first call the readAnalyzeData.m function and would
% create an image of the data which is returned by this function

% Call the function to read the analyze data file
[fileName,imgData,mzData] = readanalyze();

size(imgData)
% mzData  the m/z data is in the form of one column and 6501 rows 
% (mzData)' the m/z data is in the form of 6501 columns and 1 row 

mzValue = input('Enter the specific mz value: ');

i=1;
for mzDataLoop = 1:length(mzData)
    limit = 1e-2;
    if abs(mzData(mzDataLoop) - mzValue) < limit
        mzValueIndice = i;
        break;
    else
        i=i+1;
    end
end

mzValueIndice

mzSpecificData = imgData(mzValueIndice,:,:);  % stores the intensity values of all scans at that specific mz value


[temp,x,y]=size(mzSpecificData) 
  

grayScaleImage = squeeze(mzSpecificData);
subplot(3,1,1),imshow(grayScaleImage, []);


rgbImage = repmat(uint8(255.*grayScaleImage),[1 1 3]);
subplot(3,1,2),imshow(rgbImage);

rgbImage = repmat(double(grayScaleImage)./255,[1 1 3]);
subplot(3,1,3),imshow(rgbImage);

% mzValueIndice = find(columnmzData == mzValue,1)

% calculate the column number of the mz value entered by the user

% % calulcation of relative intensity
% maxIntensity=max(imgData(:,:,1));
% maxIntensityIndice=find(imgData(1,:,1),maxIntensity);
% intData=(imgData(1,:,1));
% sizeIntData=length((intData)');
% for intLoop = 1:sizeIntData
%     relativeIntensity(intLoop)=((intData(intLoop)./ maxIntensity).*100);
% end

% plot for absolute intensity
% subplot(2,1,1),plot(mzData, imgData(1,:,1), 'b')
% xlabel('m/z')
% ylabel('Intensity')

% % plot for relative intensity
% subplot(2,1,2),plot(mzData, relativeIntensity, 'b')
% xlabel('m/z')
% ylabel('Relative Intensity')
