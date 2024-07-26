function images = imageToGray(images)

for n = 1:numel(images)
    I = images{n};
    % I = preprocessImage(I);
    images{n} = im2gray(I);
end
end