function [matchedPoints1,matchedPoints2,indexPairs] = matchedPointsFilter(matchedPoints1,matchedPoints2,indexPairs,I)
removeIndex = [];
for n = 1:length(matchedPoints1)
    leftY_koordination = matchedPoints1(n).Location;
    rightY_koordination = matchedPoints2(n).Location;
    % drop the matchedPoint with small y koordination
    % set a threshold to drop the outlier
    if (leftY_koordination(2)/rightY_koordination(2)) > 1.3 || (rightY_koordination(2)/leftY_koordination(2)) > 1.3 || leftY_koordination(2) < size(I,1)/5 || rightY_koordination(2) < size(I,1)/5
        removeIndex(end+1) = n;
    end
end
matchedPoints1(removeIndex) = [];
matchedPoints2(removeIndex) = [];
indexPairs(removeIndex,:) = [];
end