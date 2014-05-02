function plotAnalyzeData()
% This function would first call the readAnalyzeData.m function and would
% plot the data which is returned by this function
% It plots the absolute intensity plot and the relative intensity plot
% for scan 1 of the imaging data file

% Call the function to read the analyze data file
[headerData,imgData,mzData] = readAnalyzeData();


% calulcation of relative intensity
maxIntensity=max(imgData(1,:,1));
maxIntensityIndice=find(imgData(1,:,1),maxIntensity);
intData=(imgData(1,:,1));
sizeIntData=length((intData)');
for intLoop = 1:sizeIntData
    relativeIntensity(intLoop)=((intData(intLoop)./ maxIntensity).*100);
end

% plot for absolute intensity
subplot(2,1,1),plot(mzData, imgData(1,:,1), 'b')
xlabel('m/z')
ylabel('Intensity')

% plot for relative intensity
subplot(2,1,2),plot(mzData, relativeIntensity, 'b')
xlabel('m/z')
ylabel('Relative Intensity')