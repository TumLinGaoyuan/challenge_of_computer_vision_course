function images = imagesUnDistort(images, intrinsics)

for n = 1:numel(images)
    [I,newOrigin]  = undistortImage(images{n}, intrinsics);
    images{n} = I;
end
end