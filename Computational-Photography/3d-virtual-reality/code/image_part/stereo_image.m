% =========== stero image part
imgname = 'Middlebury_21_clean_color.png';
img = im2double(imread(imgname));

disname = 'Middlebury_21_output_disparity.png';
dis = im2double(imread(disname));

% multiplier: K to the given disparity map
k = 20;

[Left, Right] = disparity2stero(img, dis, k);
imwrite(Left,'left1.png')
imwrite(Right,'right1.png')
imwrite(0.5*(Left+Right),'sum1.png')



imgname = 'Middlebury_20_clean_color.png';
img = im2double(imread(imgname));

disname = 'Middlebury_20_output_disparity.png';
dis = im2double(imread(disname));

% multiplier: K to the given disparity map
k = 10;

[Left, Right] = disparity2stero(img, dis, k);
imwrite(Left,'left2.png');
imwrite(Right,'right2.png');
imwrite(0.5*(Left+Right),'sum2.png');

imgname = 'art.png';
img = im2double(imread(imgname));

disname = 'art_disparity.png';
dis = im2double(imread(disname));

% multiplier: K to the given disparity map
k = 10;

[Left, Right] = disparity2stero(img, dis, k);
imwrite(Left,'left3.png');
imwrite(Right,'right3.png');
imwrite(0.5*(Left+Right),'sum3.png');

imgname = 'reindeer.png';
img = im2double(imread(imgname));

disname = 'reindeer_disparity.png';
dis = im2double(imread(disname));

% multiplier: K to the given disparity map
k = 10;

[Left, Right] = disparity2stero(img, dis, k);
imwrite(Left,'left4.png');
imwrite(Right,'right4.png');
imwrite(0.5*(Left+Right),'sum4.png');

imgname = 'book.png';
img = im2double(imread(imgname));

disname = 'book_disparity.png';
dis = im2double(imread(disname));

% multiplier: K to the given disparity map
k = 10;

[Left, Right] = disparity2stero(img, dis, k);
imwrite(Left,'left5.png');
imwrite(Right,'right5.png');
imwrite(0.5*(Left+Right),'sum5.png');



% 370*340
