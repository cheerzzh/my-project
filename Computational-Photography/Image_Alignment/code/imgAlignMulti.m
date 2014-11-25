%% CSCI 3290: Assignment 1 
%% imgAlignMulti.m
%% Zhou Zhihao, 1155014412
%% cheerzzh@gmail.com
% Input glass plate image

% create an array of image name
imgname_array = {'00026u.tif','00789u.tif','01087u.tif','00028u.tif','00029u.tif','00063u.tif','00064u.tif','00066u.tif'};

for i = 1:length(imgname_array)

	imgname = imgname_array{i};
	fullimg = imread(imgname);
	% Convert to double matrix
	fullimg = im2double(fullimg);

	% Calculate the height of each part (about 1/3 of total)
	ImgH = floor(size(fullimg,1)/3);

	% Separate B-G-R channels
	% vertical separation
	B = fullimg(1:ImgH,:);
	G = fullimg(ImgH+1:ImgH*2,:);
	R = fullimg(ImgH*2+1:ImgH*3,:);


	%% Align the images
	% Functions that might be useful:"circshift", "sum", and "imresize"

	tic;   % The Timer starts. To Evalute algorithms' efficiency.

	% Write your codes here. 
	% Write your function of alignSingle and alignMulti
	disp(['for image' imgname] );
	[aG, vG] = alignMulti(G,B,0.1,6,6);
	disp('displacement vector for G on B:');
	disp(vG');
	[aR, vR] = alignMulti(R,B,0.1,6,6);
	disp('displacement vector for R on B:');
	disp(vR');

	% print displacement vector here

	toc;   % The Timer stops and displays time elapsed.
	fprintf('\n');
	%% Output Results

	% Create a color image (3D array): "cat" command
	% For your own code, "G","R" shoule be replaced to "aG","aR"
	colorImg = cat(3,R,G,B);
	colorImg_dis = cat(3,aR,aG,B);


	% Save result image to File
	imwrite(colorImg,['original-align-' imgname],'jpg');
	imwrite(colorImg_dis,['multiple-' strcat('displace-',imgname)],'jpg');

end
