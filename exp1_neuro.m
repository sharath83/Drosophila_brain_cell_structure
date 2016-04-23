
delete('red_bw_stack.tif');
stack = 'red_stack.tif';
info = imfinfo(stack);
n = numel(info);
red_processed = cell(1,n);
IC = imread(stack, 1);
[rows, cols, col] = size(IC);
d = zeros(rows, cols, 98);

for k = 1:n
    IC = imread(stack, k);

        I = IC(:,:,1);
        %I = rgb2gray(IC);
        %figure, imshow(I), title('gray image');
        I = medfilt2(I);
        T = graythresh(I);
        Ibw = im2bw(I,2*T);
        %figure, imshow(I), title('threshold');
        %Ibw = imerode(Ibw, strel('disk', 2));
        Ibw = imfill(Ibw, 'holes');
        %figure, imshow(I), title('holes');
        Ibw = imopen(Ibw, strel('disk', 2));
        %figure, imshow(Ibw), title('open');
        [L,ccnum] = bwlabel(Ibw);
        %figure, imshow(Ibw), title('label');
        if ccnum < 10
            d(:,:,k) = Ibw;
            %imwrite(Ibw, 'red_bw_stack.tif', 'writemode', 'append');
        end
    %end
end
for k = 1:n
    imwrite(d(:,:,k), 'red_bw_stack.tif', 'writemode', 'append');
end
[L, n] = bwlabeln(d); %count the neuroblasts in the 3D image
disp('No. of neuroblasts:');
disp(n);


