%{
CSCI3290 HW3
Zhou Zhihao, 1155014412
cheerzzh@gmail.com  

%}



clc;clear;close all;

tarImg = imread('lady.jpg');
inputImg = imread('toast.png');

alpha = 0.1;
szPatch = 40;
szOverlap = 10;
ifdebug = 1;
merge = 1;
niter = 1;


[out_gray out_rgb] = texture_transfer(inputImg, tarImg, alpha, szPatch, szOverlap, niter,ifdebug,merge);

figure(1)
imshow(inputImg);
figure(2)
imshow(tarImg);
figure(3)
imshow(out_gray, [])
figure(4)
imshow(out_rgb)

imwrite(out_gray,'out_gray.jpg','jpg');
imwrite(out_rgb,'out_rgb.jpg','jpg');
