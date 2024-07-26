%% 1,12,17,3,4,5,30,31,28,6,8,22,23,24,21,9,25,20,26,19,27,2,13,14,15,16,7,29,10,11,18
% matchedImagePair 是一个 31x2 的 cell 数组
% 创建一个数组来存储结果
load matchedImagePaar.mat;
resultArray = [1];
number = 1;

% 遍历 matchedImagePair 的每一行
for i = 1:size(matchedImagePaar, 1)
    % 获取当前行的第二列数据
    data = matchedImagePaar{number, 2};
    
    % 找到第二列数字最大的行的索引
    [~, maxIndex] = max(data(:, 2));
    
    % 获取对应的第一列的数字
    number = data(maxIndex, 1);
    
    % 如果数字已经存在于结果数组中
    if ismember(number, resultArray)
        % 将当前行的最大值置为负无穷，以便找到第二大的值
        data(maxIndex, 2) = -inf;
        
        % 找到第二大值的行的索引
        [~, maxIndex] = max(data(:, 2));
        
        % 检查第二大值所对应的数字是否已经存在于结果数组中
        while ismember(data(maxIndex, 1), resultArray)
            % 将当前行的第二大值置为负无穷，以便找到下一个较大的值
            data(maxIndex, 2) = -inf;
            
            % 找到下一个较大值的行的索引
            [~, maxIndex] = max(data(:, 2));
            %    % 如果 data 中的第二列数值全部为 -inf
            if all(data(:, 2) == -inf)
                % 找到还没有出现在结果数组中的最小值
                minNumber = min(setdiff([1:size(matchedImagePaar, 1)], resultArray));
                
                % 更新 number 为最小值
                number = minNumber;

                % 输出结果
                fprintf('第一列数字：%d\n', number);

                break;
            end

        end

        % 获取第二大值所对应的第一列数字
        if all(data(:, 2) == -inf)
            number = minNumber;
        else
            number = data(maxIndex, 1);
        end
    end
    
    
    % 将结果存储到结果数组中
    resultArray = [resultArray, number];
    
    % 输出结果
    fprintf('第一列数字：%d，第二大值：%d\n', number, data(maxIndex, 2));

end
