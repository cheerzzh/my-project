function  gIm = Lab2gray(im)

%{

CSCI3290 HW2
Contrast Preserving Decolorization
Zhou Zhihao, 1155014412
cheerzzh@gmail.com	

%}


lab = RGB2Lab(im);
gIm = lab(:,:,1);
gIm = (gIm - min(gIm(:)))/ (max(gIm(:)) - min(gIm(:)));


end 
