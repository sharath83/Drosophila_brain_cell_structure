
%Read stack and process each image
delete('red_stack.tif', 'green_stack.tif', 'blue_stack.tif');
stack = 'Stack_preprocessed.tif';
info = imfinfo(stack);
for k = 1:numel(info)
    I = imread(stack, k);
    
    %segmented_img = cell(1,3);
    segmented_img = exp1_cluster(I);
    %file = strcat('red',num2str(k),'.jpg');
    %imwrite(segmented_img{1}, file);
    %red_3d{k} = segmented_img{3};
    imwrite(segmented_img{3}, 'red_stack.tif', 'writemode', 'append');
    
    imwrite(segmented_img{2}, 'blue_stack.tif', 'writemode', 'append');
    imwrite(segmented_img{1}, 'green_stack.tif', 'writemode', 'append');
end

   