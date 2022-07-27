function [downSamp_data, newTaxis] = downSampData(ogFs,targetFs,ogTaxis,ogData)
            
[b,a] = butter(4,(targetFs/4)/(ogFs/2),'low');
lpFilt_data = zeros(size(ogData));
downSampFactor = ogFs/targetFs;
downSamp_data = zeros(size(ogData,1),size(ogData,2)/downSampFactor);

for i = 1:min(size(ogData))
    lpFilt_data(i,:) = filtfilt(b,a,ogData(i,:));
    downSamp_data(i,:) = downsample(lpFilt_data(i,:),downSampFactor);
end

newTaxis = linspace(ogTaxis(1),ogTaxis(end),length(ogTaxis)/downSampFactor);