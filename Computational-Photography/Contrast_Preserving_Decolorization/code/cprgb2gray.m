
function gIm = cprgb2gray(im)

%{

CSCI3290 HW2
Contrast Preserving Decolorization
Zhou Zhihao, 1155014412
cheerzzh@gmail.com	

%}

% input 'im' is a color image
% output gIm is the resulting grayscale image

% Step 1: Convert the input to LAB space
lab = RGB2Lab(im);
% normalize lab
%lab = (lab - min(lab(:)))/ (max(lab(:)) - min(lab(:)));

%CT = makecform('srgb2lab');
%lab = applycform(im,CT);
%lab = im;

% Step 2: Construct delta_xy for each neighboring pixels
[m n ~] = size(im);
% for right neighbour
temp = circshift(lab, [0 -1]);
d = (lab - temp).^2;
% sign
l_d = lab(:,:,1) - temp(:,:,1);
l_t = l_d >0;
l_t = (l_t-0.5)*2;

difference_right = sqrt(d(:,:,1) + d(:,:,2) + d(:,:,3)) .* l_t; % sum of square difference for 3 channels, add sign

%for the below
temp = circshift(lab, [-1 0]);
d = (lab - temp).^2;
% sign
l_d = lab(:,:,1) - temp(:,:,1);
l_t = l_d >0;
l_t = (l_t-0.5)*2;

difference_below = sqrt(d(:,:,1) + d(:,:,2) + d(:,:,3)) .* l_t; % sum of square difference for 3 channels, add sign


%convert into the Delta, right then below
delta = [difference_right(:) ;difference_below(:)];

% Step 3: Constructing A and Delta
% for right neighbour
e = ones(n*m,1);
A_right = spdiags([-e e -e], [(m-m*n) 0 m], n*m, n*m);
% for below neighbour
e = ones(n*m,1);
A_below = spdiags([-e e -e], [(1-m*n) 0 1], n*m, n*m);
% adjust
x = m:m:m*n;
y = 1:m:(n*m-m+1);
A_below(sub2ind(size(A_below),x,y)) = -1; % for y(m,i)
x=  m:m:m*(n-1);
y = (m+1):m:(n*m-m+1);
A_below(sub2ind(size(A_below),x,y)) = 0; % remove wrong -1
A_below(end,1) = 0; 

A = [A_right ; A_below];

 % Step 4: Solve the objective function to get G
G = A\delta;
gIm = reshape(G,m,n);
% Normalization
gIm = (gIm - min(gIm(:)))/ (max(gIm(:)) - min(gIm(:)));


end

