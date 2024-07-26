function [xyzPoints] = Plot3dPoints(xyzPoints,reprojectionErrors,camPoses,ax)
    %%%%%%%%%%%%%%%%%%%%%新修改的%%%%%%%%%%%%%%%%%%%%%%%%
    axes(ax); % Set the current axes to ax
    %%%%%%%%%%%%%%%%%%%%%新修改的%%%%%%%%%%%%%%%%%%%%%%%%

    goodIdx = (reprojectionErrors < 10);
        for n = 1:length(xyzPoints)
            if abs(xyzPoints(n,1)) > 10 || abs(xyzPoints(n,2))> 10 || abs(xyzPoints(n,3))> 10
                xyzPoints(n,:) = [0,0,0];
            end
        end

    
    % pcshow(xyzPoints(goodIdx, :),AxesVisibility="on",VerticalAxis="y",VerticalAxisDir="down",MarkerSize=45);
    % hold on
    % plotCamera(camPoses(:,:), Size=0.1);
    % 
    % xlabel('x-axis');
    % ylabel('y-axis');
    % zlabel('z-axis');
    % hold off

end