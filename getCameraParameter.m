function intrinsics = cameraParameter(direction)
% read .txt document and output the camera's parameter
% read .txt document
file_ID = fopen(direction, 'r');
txt_data = textscan(file_ID, '%s', 'delimiter', '\n');
txt_data = txt_data{1};
for i = 1:length(txt_data)
    if startsWith(txt_data(i),"#")
        startRow = i+1;
    end
    % split each row of dataset
    txt_data{i} = strsplit(txt_data{i});
    if i >= startRow
        % transfer the element from string to double
        txt_data{i} = str2double(txt_data{i});        
    end
end
% assign camera's parameter
cameraData_parameter = txt_data(startRow:end);
cameraParameter = cameraData_parameter{1}(3:end);
fclose(file_ID);
% assign element of cell 'cameraParameter' to corresponden physical
% variable
imageWidth = cameraParameter(1);
imageHeight = cameraParameter(2);
focalLength = [cameraParameter(3),cameraParameter(4)];
principalPoint = [cameraParameter(5),cameraParameter(6)];
imageSize = [imageHeight,imageWidth];
% output intrinsics cell which is consis of camera's parameter
intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
end