%{

CSCI3290 HW2
Contrast Preserving Decolorization
Zhou Zhihao, 1155014412
cheerzzh@gmail.com	

%}

index = 6;
name = sprintf('testimages/%d.png', index);
Im = im2double(imread(name));

% Part 1: Basic Decolorization Algorithm
gIm = cprgb2gray(Im);
%figure, imshow(Im), figure, imshow(gIm);
%ccpr = CCPR(gIm, Im,1)

% Part 2: Decolorization Evaluation: Color Contrast Preserving Ratio (CCPR)

ccprRes = 0;
for tau = 1:15
    ccpr = CCPR(gIm, Im, tau);
    ccprRes = ccprRes + ccpr;
end

fprintf('CCPR  for cprgb2gray() is %f\n', ccprRes/15);
%figure, imshow(Im), figure, imshow(gIm);

% matlba built-in function: rgb2gray
g_mat = rgb2gray(Im);
ccprRes = 0;
for tau = 1:15
    ccpr = CCPR(g_mat, Im, tau);
    ccprRes = ccprRes + ccpr;
end

fprintf('CCPR for rgb2color() is %f\n', ccprRes/15);
%figure,imshow(g_mat);


% use L channel in Lab
L_gray = Lab2gray(Im);
ccprRes = 0;
for tau = 1:15
    ccpr = CCPR(L_gray, Im, tau);
    ccprRes = ccprRes + ccpr;
end

fprintf('CCPR for Lab2gray  is %f\n', ccprRes/15);
%figure, imshow(L_gray);


% linear mapping use bimodel
[g_linear,w,E] = linear_mapping(Im,0.1);
ccprRes = 0;
for tau = 1:15
    ccpr = CCPR(g_linear, Im, tau);
    ccprRes = ccprRes + ccpr;
end

fprintf('CCPR for linear mapping  is %f\n', ccprRes/15);
fprintf('\nThe optimal weight on RGB is:');
disp(w);
fprintf('The minimized energy function value is: ');
disp(E);
%figure, imshow(g_linear);

img_name ={'Basic_Decolorization','rgb2color','L_channel','linear_mapping'};
imgs = {gIm,g_mat,L_gray,g_linear};

%save images

for i = 1:length(imgs)
	imwrite(imgs{i},[ num2str(index) '_' img_name{i} '.jpg'],'jpg');
end



