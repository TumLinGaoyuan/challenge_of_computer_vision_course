function imageInfoSorted = getCameraPosition_forWork(imageInfoDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
file_ID = fopen(imageInfoDir, 'r');
% read the .txt document
cameraInfoData = textscan(file_ID, '%s', 'delimiter', '\r');
cameraInfoData = cameraInfoData{1};

% find the start row of the data
for i = 1:length(cameraInfoData)
    if startsWith(cameraInfoData(i),"#")
        startRow = i+1;
    end
    cameraInfoData{i} = strsplit(cameraInfoData{i});
end


nameOfImage = {};
for j = 1:length(cameraInfoData)
    cameraInfoData{j}(7) = [];
    % assign the image's name to cell 'nameOfImage'
    nameOfImage{end + 1} = cameraInfoData{j}(6);
    cameraInfoData{j}(6) = [];
    % transform other element of the dataset from string to double
    cameraInfoData{j} = str2double(cameraInfoData{j});
end

% create a cell to story all numerical element 
for n = 1:length(nameOfImage)
    if n == 1
        row = cameraInfoData{1};
        imageInfo_reshape = [{row(1)},{row(2)},{row(3)},{row(4)},{row(5)},nameOfImage{1}];
    else 
        row = cameraInfoData{n};
        imageInfo_reshape = [imageInfo_reshape;[{row(1)},{row(2)},{row(3)},{row(4)},{row(5)},nameOfImage{n}]];
    end
end
[sortedValue,sortedIdx] = sort([imageInfo_reshape{:,1}]);

% add the image's name to the created cell which has the numerical element
for n = 1:length(sortedIdx)
    idx = sortedIdx(n);
    if n == 1 
        imageInfoSorted = [{imageInfo_reshape{idx,1}},{imageInfo_reshape{idx,2}},{imageInfo_reshape{idx,3}},{imageInfo_reshape{idx,4}},{imageInfo_reshape{idx,5}},imageInfo_reshape{idx,6}];
    else
        imageInfoSorted = [imageInfoSorted;[{imageInfo_reshape{idx,1}},{imageInfo_reshape{idx,2}},{imageInfo_reshape{idx,3}},{imageInfo_reshape{idx,4}},{imageInfo_reshape{idx,5}},imageInfo_reshape{idx,6}]];
    end
end
end