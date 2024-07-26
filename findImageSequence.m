function resultArray = findImageSequence(matchedImagePair)
resultArray = [1];
number = 1;

% Iterate over each row of matchedImagePair
for i = 1:size(matchedImagePair, 1)
    % Get the data in the second column of the current row
    data = matchedImagePair{number, 2};

    % Find the row index with the maximum value in the second column
    [~, maxIndex] = max(data(:, 2));

    % Get the corresponding number in the first column
    number = data(maxIndex, 1);

    % If the number already exists in the resultArray
    if ismember(number, resultArray)
        % Set the maximum value in the current row to -inf to find the second maximum
        data(maxIndex, 2) = -inf;

        % Find the row index with the second maximum value
        [~, maxIndex] = max(data(:, 2));

        % Check if the number corresponding to the second maximum value already exists in the resultArray
        while ismember(data(maxIndex, 1), resultArray)
            % Set the second maximum value in the current row to -inf to find the next larger value
            data(maxIndex, 2) = -inf;

            % Find the row index with the next larger value
            [~, maxIndex] = max(data(:, 2));
            
            % If all values in the second column of data are -inf
            if all(data(:, 2) == -inf)
                % Find the minimum value that hasn't appeared in the resultArray
                minNumber = min(setdiff([1:size(matchedImagePair, 1)], resultArray));

                % Update number to the minimum value
                number = minNumber;

                % Print the result
                % fprintf('First column number: %d\n', number);

                break;
            end
        end

        % Get the number corresponding to the second maximum value
        if all(data(:, 2) == -inf)
            number = minNumber;
        else
            number = data(maxIndex, 1);
        end
    end

    % Store the result in the resultArray
    resultArray = [resultArray, number];

    % Print the result
    % fprintf('First column number: %d, Second maximum value: %d\n', number, data(maxIndex, 2));
end
end
