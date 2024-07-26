function  matchedImagePaar = findMatchedImagePaar(images)

% assign the serial number of each image as the row index
for k = 1:numel(images)
    if k == 1
        matchedImagePaar = {1};
    else
        matchedImagePaar = [matchedImagePaar;k];
    end
end
% find the corresponding match-images of each iamge according to the value
% of matched point. when the value of matched point larger than a
% threshold, assign it to corresponding row of variable 'matchedImagePaar'.
for i = 1:numel(images)
    I = images{i};
    % difine the value of border and use it to create a image's frame
    border = 700;
    roi = [1, border, size(I, 2), size(I, 1)- border];
    % detect the feature's point and feature of a image
    prevPoints  = detectSURFFeatures(I, NumOctaves=3, ROI=roi);
    prevFeatures = extractFeatures(I, prevPoints, Upright=true);
    matchedImageIndex = [];
    % loop all other images and find the corresponding match-images of this image
    for n = 1:numel(images)
        if n ~= i
            I1 = images{n};
            % detect the feature's point and feature
            currPoints = detectSURFFeatures(I1, NumOctaves=3,ROI=roi);
            currFeatures = extractFeatures(I1,currPoints, Upright=true);
            % valueMaxRatio = 0.2;
            % find the index of matching point
            indexPairs   = matchFeatures(prevFeatures, currFeatures, method = 'Approximate', MaxRatio=0.3, Unique=true, MatchThreshold=4);
            matchedPoints1 = prevPoints(indexPairs(:, 1), :);
            matchedPoints2 = currPoints(indexPairs(:, 2), :);
            % use a filter to clean imprecise matching point
            % [matchedPoints1,matchedPoints2,indexPairs] = matchedPointsFilter(matchedPoints1,matchedPoints2,indexPairs,I1);
            thresholdOfMatchingPaar = 20;
            if length(matchedPoints1) > thresholdOfMatchingPaar
                matchedImageIndex = [[matchedImageIndex];[n,length(matchedPoints1)]];
            end
        end
    end
    % if the match-images is valid, assign this paar to variable
    % 'matchedImagePaar'
    matchedImagePaar{i,2} = matchedImageIndex;
end
end