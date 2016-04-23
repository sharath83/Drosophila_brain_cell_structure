%Clustering to determine color segments
function segmented_img = exp1_cluster(I)
%I = imread('SampleStack.tif', 46);
%imshow(I), title('Frame 36, Original');

%Covert to L,a,b colorspace from RGB
% L = Lumonocity(Birghtness), a,b = Chromaticity (colors a = R-G, b = B-Y)
form = makecform('srgb2lab');
Ilab = applycform(I, form);

%Classify the colors using k-means

%Get only a, b space of the image
Iab = double(Ilab(:,:,2:3));
%figure, imshow(Iab), title('ab space');

rows = size(Iab,1);
cols = size(Iab,2);

Iab = reshape(Iab, rows*cols, 2);
% find objects which has similar pixel patterns and put them into
% one cluster

%k-means clustering claculates distance between each object and partitions
%them such that objects in each cluster are close and as far as possible
%from objects in other clusters

nclusters = 3;
[clIndex, clCenter] = kmeans(Iab,nclusters,'Replicates',3);

%Reshape it back
clIndex = reshape(clIndex,rows,cols);
%figure, imshow(clIndex,[]), title('Image after clustering');

%Create the color images from segmented ones
segmented_img = cell(1,nclusters);
% clust_img = cell(1, nclusters);
rgb_label = repmat(clIndex,[1 1 nclusters]); %Create 4 colours

cluster_means = mean(clCenter,2);
[value, id] = sort(cluster_means);

% for k = 1:nclusters
%     col = I;
%     col(rgb_label ~= k) = 0;
%     rgb = find(id==k);
%     %segmented_img{rgb} = col;
% %     clust_img{k} = col;
% end

IL = Ilab(:,:,1); %Get the L component of Ilab

for k = 1:nclusters
    col_idx = find(clIndex == id(k));
    L_col = IL(col_idx);
    is_light_col = im2bw(L_col, graythresh(L_col));
    col_labels = repmat(uint8(0),[rows cols]);

    col_labels(col_idx(is_light_col==true)) = 1;

    col_labels = repmat(col_labels,[1 1 3]);
    col_image = I;
    col_image(col_labels ~= 1) = 0;
    rgb = find(id==k);
    segmented_img{k} = col_image;
    clust_img{id(k)} = col_image;
end

% figure, imshow(segmented_img{1}), title('Green');
% figure, imshow(segmented_img{2}), title('Blue');
% figure, imshow(segmented_img{3}), title('Red');

% get_neuroblast(segmented_img{1});

% figure, imshow(clust_img{1}), title('1');
% figure, imshow(clust_img{2}), title('2');
% figure, imshow(clust_img{3}), title('3');

% in clustering we get only clusters belong to particular color
% We need a mechanism to identify the clusters with corrsponding colors
% automatically

    






