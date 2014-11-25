function [gIm,weight,minE] = linear_mapping(im, search_step)

%{

CSCI3290 HW2
Contrast Preserving Decolorization
Zhou Zhihao, 1155014412
cheerzzh@gmail.com	

%}

[m,n,~] = size(im);
% shifted 3 color channel
im_right = circshift(im, [0 -1]);
im_below = circshift(im, [-1 0]);
shifted = [im_right;im_below];
origin = [im; im];
% compute difference between 3 channel for original and shifted imgae
difference = origin - shifted;
% make into 2mn * 3 matirx to facilitate 
R = difference(:,:,1); G = difference(:,:,2); B = difference(:,:,3); 
diff_combine = [R(:) G(:) B(:)];

% construct a (1 if unambiguous color order, otherwise 0.5)
unam = origin(:,:,1) <= shifted(:,:,1) & origin(:,:,2) <= shifted(:,:,2) & origin(:,:,3) <= shifted(:,:,3);
a = ones(2*m,n);
a(~unam) = 0.5;

% compute distance in Lab space
lab = RGB2Lab(im);
%CT = makecform('srgb2lab');
%lab = applycform(im,CT);
% for right neighbour
temp = circshift(lab, [0 -1]);
d = (lab - temp).^2;
delta_right = sqrt(d(:,:,1) + d(:,:,2) + d(:,:,3)); % sum of square difference for 3 channels, add sign

%for the below
temp = circshift(lab, [-1 0]);
d = (lab - temp).^2;
delta_below = sqrt(d(:,:,1) + d(:,:,2) + d(:,:,3)); % sum of square difference for 3 channels, add sign
% combine right and below
delta = [delta_right ; delta_below];
% convert into 2mn * 1 vector
delta_combine = delta(:)/100;

% prepare search range 
w = 0:search_step:1;
sets = {w, w, w};
[x y z] = ndgrid(sets{:});
cartProd = [x(:) y(:) z(:)];
index = sum(cartProd,2) == 1;
candidate = cartProd(index,:);


% evalue energy function on each weight in one shot
l = diff_combine * candidate';
l_minus_delta = bsxfun(@minus, l, delta_combine);
l_plus_delta = bsxfun(@plus, l, delta_combine);

sigma = 0.02; 
mat =  -log(exp(-0.5/sigma * l_minus_delta.^2) + exp(-0.5/sigma * l_plus_delta.^2));
energy = sum(mat,1);
[minE, indi] = min(energy);
weight = candidate(indi, :);

% output the resulting gray image
gIm = weight(1)*im(:,:,1) + weight(2)*im(:,:,2) +weight(3)*im(:,:,3);

end