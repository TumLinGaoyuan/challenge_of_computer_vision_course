function images = inputImage(imageDir)
imds = imageDatastore(imageDir);

images = cell(1, numel(imds.Files));
for n = 1:numel(imds.Files)
    I = readimage(imds, n);
    % I = preprocessImage(I);
    % I = im2gray(I);
    % [I,newOrigin]  = undistortImage(I, intrinsics);
    images{n} = I;
end
end