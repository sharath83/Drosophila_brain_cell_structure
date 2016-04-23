%Preprocessing the stack to remove extra lobes
delete('Stack_preprocessed.tif');
stack = 'SampleStack.tif';
info = imfinfo(stack);
for k = 1:numel(info)
    I = imread(stack, k);
    I(159:264,240:264,:) = 0;
    I(193:264,220:264,:) = 0;
    I(232:264,194:264,:) = 0;
    
    imwrite(I,'Stack_preprocessed.tif', 'writemode', 'append');
end