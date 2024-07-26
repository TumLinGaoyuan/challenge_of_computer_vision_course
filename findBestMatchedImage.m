% Generate the best matching image for each image based on the new image order

function matchPaarset = findBestMatchedImage(matchedImagePaar, resultArray)
    matchPaarset = [];
    imageOrder = resultArray;
    
    % loop all the element inside the new created image's sequence 
    for i = 2:length(resultArray)
        imageOrder(i);
        data = matchedImagePaar{imageOrder(i), 2};
        % set a indicator to indicate the matching situation, 0 mean that it's not be
        % found
        matchFound = 0;
        
        while matchFound == 0
            [~, maxIndex] = max(data(:, 2));
            maxMatchImageIndex = data(maxIndex,1);
            
            % validate the matching image's index is in the previous sequence or not
            % if answer is yes, end the while loop and go next image
            if ismember(maxMatchImageIndex, resultArray(1:i-1))
                matchFound = 1;
                imageOrder(i);
            else
                data(maxIndex, 2) = -inf;
            end
        end
        % create a dataset to story all the matching imagespaar
        matchPaarset = [matchPaarset; [imageOrder(i), maxMatchImageIndex]];
    end
end
