clear
delete('blue_bw_stack.tif');
stack = 'blue_stack.tif';

info = imfinfo(stack);
n = numel(info);

I = imread(stack, 1);
[rows, cols, col] = size(I);
d = zeros(rows, cols, 98);
count = 1;
%ar = zeros(n);
% rate = 1;

for k = 1:n
    IC = imread(stack, k);
    
    I = IC(:,:,3);
    
    %I = rgb2gray(IC);
    %figure, imshow(I), title('gray image');
    I = medfilt2(I);
    T = graythresh(I);
    Ibw = im2bw(I,3*T);
    Ibw = imfill(Ibw, 'holes');
    Ibw = imopen(Ibw, strel('disk', 5));
    %figure, imshow(Ibw), title('Processed');
    [L,ccnum] = bwlabel(Ibw);
    if ccnum == 0
        miss(count) = k;
        count = count+1;
        ar(k) = exp1_area(IC);
    else
%         hit(rate) = k;
%         rate = rate+1;
    d(:,:,k) = Ibw;
    %imwrite(Ibw, 'blue_bw_stack.tif', 'writemode', 'append');
    end
end

stack = 'green_stack.tif';
for k = 1:count-1
    IC = imread(stack, miss(k));
    
    I = IC(:,:,3);
    
    %I = rgb2gray(IC);
    %figure, imshow(I), title('gray image');
    I = medfilt2(I);
    T = graythresh(I);
    Ibw = im2bw(I,3*T);
    Ibw = imfill(Ibw, 'holes');
    Ibw = imopen(Ibw, strel('disk', 4));
    %figure, imshow(Ibw), title('Processed');
    [L,ccnum] = bwlabel(Ibw);
    if ccnum > 0
        d(:,:,k) = Ibw;
        
    %imwrite(Ibw, 'blue_bw_stack.tif', 'writemode', 'append');
    end
    
end

for k = 1:n
    IC = imread(stack, k);
    if find(miss == k) > 0
    else
        ar(k) = exp1_area(IC);
    end
end
for k = 1:n
    imwrite(d(:,:,k), 'blue_bw_stack.tif', 'writemode', 'append');
end

[L, num] = bwlabeln(d); %count the Glia nuclei in the ND image
disp('No. of Glia nuclei:');
disp(num);

meanAr = mean(ar); % Approx perimeter in nm.

% z= 15 micro meters
totalAr = (n-1) * 15 * meanAr*10^-3; % Total area of lobe in sq.micro meters

disp('Total Area of Glia membrane:');
disp(totalAr);


        