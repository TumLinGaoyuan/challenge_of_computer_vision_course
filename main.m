%% get images
tic;
imageDir = 'C:\Users\Administrator\LRZ Sync+Share\Qiliang Yu\Master\SS23\Computer vision\Challenge\Main Code\GUI\GUI\GUI\delivery_area\images\dslr_images_undistorted';
imagesOriginal = inputImage(imageDir);
indicator = 0;
% Use images.txt
indicator_1 = 0;
%% image To Gray
images = imageToGray(imagesOriginal);

%% getCameraParameter
cameraParameterDir= 'C:\Users\Administrator\LRZ Sync+Share\Qiliang Yu\Master\SS23\Computer vision\Challenge\Main Code\GUI\GUI\GUI\delivery_area\dslr_calibration_undistorted\cameras.txt';
intrinsics = getCameraParameter(cameraParameterDir);
%% 
% getCameraPosition
if indicator_1 == 1
    imageInfoDir= 'C:\Users\Administrator\LRZ Sync+Share\Qiliang Yu\Master\SS23\Computer vision\Challenge\Main Code\GUI\GUI\GUI\Image\example_kicker\parameters/images.txt';
    CameraPosition = getCameraPosition_forWork(imageInfoDir);
end

%% Remove images Distortion
images = imagesUnDistort(images,intrinsics);
%% GUI Version
% Professional version
if indicator == 1
    % find Matched Image Paar
    matchedImagePaar = findMatchedImagePaar(images);
    % load matchedImagePaar.mat;
    % Find the Image sequence
    resultArray = findImageSequence(matchedImagePaar);
    % Generate the best matching image for each image based on the new image order
    matchPaarset = findBestMatchedImage(matchedImagePaar, resultArray);
    % Get the 3D position corresponding to the matching point of the picture.
    if indicator_1 == 1
        [xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPointSpec_CamPose(images,resultArray,matchPaarset,intrinsics,CameraPosition);
    else
        [xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPointSpec(images,resultArray,matchPaarset,intrinsics);
    end
    % Basic version 
else
    if indicator_1 == 1
        [xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPointBasic_CamPose(images,intrinsics,CameraPosition);
    else
        [xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPointBasic(images,intrinsics);
    end
end
%% Plot 3D Points and Camera Positions
xyzPoints = Plot3dPoints(xyzPoints,reprojectionErrors,camPoses,indicator_1);

%% 3D Point Calibrite
xyzPoints = xyzPointCalibrite(xyzPoints);
% pcshow(xyzPoints);
%% get Box
plotPointCloudWithBoxes(xyzPoints);
toc;