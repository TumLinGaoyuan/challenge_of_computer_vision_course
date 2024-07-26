function ptCloudOut = xyzPointCalibrite(xyzPoints)

    ptCloud = pointCloud(xyzPoints);
    normals = pcnormals(ptCloud);
    avgNormal = mean(normals, 1);
    
    % calculate the angle between normal vector and XZ-plane
    angle = acos(dot(avgNormal, [0, 1, 0]) / norm(avgNormal));
    angle_deg = rad2deg(angle);
    
    % disp(['Angle between point cloud and XZ-plane：', num2str(angle_deg), 'deg']); 
    
    rotationAngles = [angle_deg-90 0 0];
    translation = [0 0 0];
    tform = rigidtform3d(rotationAngles,translation);
    
    ptCloudOut = pctransform(ptCloud,tform);
end