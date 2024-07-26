function  [xyzPoints,camPoses,reprojectionErrors] = getMatchingRelationshipAnd3dPointBasic_CamPose(images,intrinsics,CameraPosition)

vSet = imageviewset;


% 图片顺序

relPose = {};
scalarFactor = [];
% 循环处理每张图片
for i = 1:numel(images)
% for i = 1:2
    % 获取当前图片
    I = images{i};
    % 设置 ROI
    border = 700;
    roi = [1, border, size(I, 2), size(I, 1) - border];

    % 检测特征点
    currPoints = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);

    % 提取特征描述子
    currFeatures = extractFeatures(I, currPoints, 'Upright', true);

    % 添加当前视图到视图集合中

    if i == 1
        vSet = addView(vSet, i, rigidtform3d, 'Points', currPoints);
        % vSet2 = addView(vSet2, i, rigidtform3d, 'Points', currPoints);
    end

    % 如果不是第一张图片
    if i > 1

        % 获取最佳匹配图像的特征点和特征描述子

        prevPoints = detectSURFFeatures(images{i-1}, 'NumOctaves', 8, 'ROI', roi);

        prevFeatures = extractFeatures(images{i-1}, prevPoints, 'Upright', true);

        % 获取当前图片的特征点和特征描述子
        currPoints = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);

        currFeatures = extractFeatures(I, currPoints, 'Upright', true);

        % 匹配特征点
        indexPairs = matchFeatures(prevFeatures, currFeatures, 'Method', 'Approximate', 'MaxRatio', 0.6, 'Unique', true, 'MatchThreshold', 3);
       
        % 获取匹配点对
        matchedPoints1 = prevPoints(indexPairs(:, 1));
        matchedPoints2 = currPoints(indexPairs(:, 2));

        % 过滤匹配点对
        

        % 获取匹配点对的坐标
        matchedPoints1 = matchedPoints1.Location;
        matchedPoints2 = matchedPoints2.Location;

        [relPose{end+1}, inlierIdx] = helperEstimateRelativePose1(matchedPoints1, matchedPoints2, intrinsics);


        x1 = CameraPosition{i-1,2};   
        y1 = CameraPosition{i-1,3};
        z1 = CameraPosition{i-1,4};
        % 
        x2 = CameraPosition{i,2};
        y2 = CameraPosition{i,3};
        z2 = CameraPosition{i,4};

        % 用相机T矩阵和实际坐标差分别计算距离从而算比例关系（缩放因子）
        distanceOfTranslation = norm(relPose{end}.Translation);
        distanceOfCameraPostion = norm([x2-x1,y2-y1,z2-z1]);
        scalarFactor(end+1) = (distanceOfCameraPostion/distanceOfTranslation);

        relPose{end}.Translation = relPose{end}.Translation*scalarFactor(end);

        vSet;
        prevPose = poses(vSet, i-1).AbsolutePose;
        currPose = rigidtform3d(prevPose.A*relPose{end}.A);
        ViewId = i;
        vSet = addView(vSet, ViewId, currPose, Points=currPoints);
        vSet = addConnection(vSet, i-1, ViewId, relPose{end}, Matches=indexPairs(inlierIdx,:));
        tracks = findTracks(vSet);
        camPoses = poses(vSet);
        
        vSet = updateView(vSet, camPoses);

        xyzPoints = triangulateMultiview(tracks, camPoses, intrinsics);
        [xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(xyzPoints, ...
            tracks, camPoses, intrinsics, FixedViewId=1, PointsUndistorted=true);
        vSet = updateView(vSet, camPoses);

      

    end
end
end
