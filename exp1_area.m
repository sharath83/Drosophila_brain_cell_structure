function ar = exp1_area(IC)

% stack = 'green_stack.tif';
% info = imfinfo(stack);
% n = numel(info);
% IC = imread(stack, 35);
I = IC(:,:,2);
T = graythresh(I);
Ib = im2bw(I,T);
cc = bwconncomp(Ib);
stats = regionprops(cc, 'Area');
area1 = struct2table(stats);
ar = sum(area1{:,1});
[r,c] = size(Ib);
perc = ar/(r*c);
ar = perc * (200 * 200); % Approx perimeter in nm
% disp(ar);

