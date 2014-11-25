function ccrpRe = CCPR(imGray, imColor, THR)

%{

CSCI3290 HW2
Contrast Preserving Decolorization
Zhou Zhihao, 1155014412
cheerzzh@gmail.com	

%}

% comptute color difference in original image
lab = RGB2Lab(imColor);

% Step 2: Construct delta_xy for each neighboring pixels
[m n ~] = size(imColor);
% for right neighbour
temp = circshift(lab, [0 -1]);
d = (lab - temp).^2;
difference_right = sqrt(d(:,:,1) + d(:,:,2) + d(:,:,3));
right_compare = difference_right > THR;
Omg_right = sum(right_compare(:));

% for below neighbour
temp = circshift(lab, [-1 0]);
d = (lab - temp).^2;
difference_below = sqrt(d(:,:,1) + d(:,:,2) + d(:,:,3));
below_compare = difference_below > THR;
Omg_below = sum(below_compare(:));

omg = Omg_below + Omg_right;
% total 2m*n pairs of pixels

% for gray image
% first rescale back to 0 ~ 100
imGray = imGray * 100;
% for right neighour
temp = circshift(imGray, [0 -1]);
d_right = abs(imGray - temp);
g_right_compare = d_right > THR;
g_right = g_right_compare & right_compare;
g_omg_right = sum(g_right(:));

% for below
temp = circshift(imGray, [-1 0]);
d_below = abs(imGray - temp);
g_below_compare = d_below > THR;
g_below = g_below_compare & below_compare;
g_omg_below = sum(g_below(:));

g_omg = g_omg_right + g_omg_below;

ccrpRe = g_omg / omg;



end