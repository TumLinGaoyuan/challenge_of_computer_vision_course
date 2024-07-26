function [xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPoint(images,resultArray,matchPaarset,intrinsics)

% define a vSet
vSet = imageviewset;

% assign image's order
imageOrder = resultArray;
relPose = {};
% scalarFactor = [];
% x0 = CameraPosition{imageOrder(1),2};   
% y0 = CameraPosition{imageOrder(1),3};
% z0 = CameraPosition{imageOrder(1),4};
% operate all the image in a loop
for i = 1:numel(imageOrder)
    % get the actual image
    I = images{imageOrder(i)};

    % set ROI
    border = 700;
    roi = [1, border, size(I, 2), size(I, 1) - border];

    % detect feature point
    currPoints = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
%     currPoints = detectSURFFeatures(I, 'NumOctaves', 3);

    % extract feature
    currFeatures = extractFeatures(I, currPoints, 'Upright', true);

    % add feature's point to vSet
    if i == 1
        vSet = addView(vSet, i, rigidtform3d, 'Points', currPoints);
    end

    if i > 1

        % get the index of best matching image
        bestMatchedIndex = matchPaarset(i-1,2);
        prevPoints = detectSURFFeatures(images{bestMatchedIndex}, 'NumOctaves', 8, 'ROI', roi);
        prevFeatures = extractFeatures(images{bestMatchedIndex}, prevPoints, 'Upright', true);

        % get the feature's point of corresponding matching image
        currPoints = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
        currFeatures = extractFeatures(I, currPoints, 'Upright', true);

        % find the matching point 
        indexPairs = matchFeatures(prevFeatures, currFeatures, 'Method', 'Approximate', 'MaxRatio', 0.3, 'Unique', true, 'MatchThreshold', 4);

        % get the matched point-paar
        matchedPoints1 = prevPoints(indexPairs(:, 1));
        matchedPoints2 = currPoints(indexPairs(:, 2));

        % filter matched points
        [matchedPoints1, matchedPoints2,indexPairs] = matchedPointsFilter(matchedPoints1, matchedPoints2,indexPairs, I);

        % get the location of matchedPoint
        matchedPoints1 = matchedPoints1.Location;
        matchedPoints2 = matchedPoints2.Location;

        % % 估计本质矩阵
        % [E, inlierIdx] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, 'MaxNumTrials', 10000, 'Confidence', 50, 'MaxDistance', 5);
        % 
        % % 提取内点
        % inlierPoints1 = matchedPoints1(inlierIdx, :);
        % inlierPoints2 = matchedPoints2(inlierIdx, :);
        % 
        % % 估计相对位姿
        % % [relPose{end+1}, validPointFraction] = estrelpose(E, intrinsics, inlierPoints1(1:2:end, :), inlierPoints2(1:2:end, :));
        % [relPose{end+1}, validPointFraction] = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);

        % get the relative poses of cameras  
        [relPose{end+1}, inlierIdx] = helperEstimateRelativePose1(matchedPoints1, matchedPoints2, intrinsics);

        % 
        % x2 = CameraPosition{imageOrder(i),2};
        % y2 = CameraPosition{imageOrder(i),3};
        % z2 = CameraPosition{imageOrder(i),4};

        % get the camera's position of image from the loop
        prevPose = poses(vSet, bestMatchedIndex).AbsolutePose;
        % calculate the camera's position of matched image
        currPose = rigidtform3d(prevPose.A*relPose{end}.A);

        % % 用相机T矩阵和实际坐标差分别计算距离从而算比例关系（缩放因子）
        % distanceOfTranslation = norm(currPose.Translation)
        % distanceOfCameraPostion = norm([x2-x0,y2-y0,z2-z0])
        % scalarFactor(end+1) = (distanceOfCameraPostion/distanceOfTranslation)
        
        ViewId = imageOrder(i);
        % assign the feature's point of the matched image
        vSet = addView(vSet, ViewId, currPose, Points=currPoints);
        % create the connection-relationship of matched image-paar
        vSet = addConnection(vSet, bestMatchedIndex, ViewId, relPose{end}, Matches=indexPairs(inlierIdx,:));
        % track the matched point
        tracks = findTracks(vSet);
        % get the all camera's position in vSet
        camPoses = poses(vSet);
        % update the camera's position in vSet
        vSet = updateView(vSet, camPoses);
        % calculate the 3D coordination of the matched points
        xyzPoints = triangulateMultiview(tracks, camPoses, intrinsics);
        [xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
            tracks, camPoses, intrinsics, FixedViewId=1, ...
            PointsUndistorted=true);
        vSet = updateView(vSet, camPoses);
    end
end
end