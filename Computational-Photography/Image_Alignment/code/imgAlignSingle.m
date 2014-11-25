%% CSCI 3290: Assignment 1 
%% imgAlignSingle.m
%% Zhou Zhihao, 1155014412
%% cheerzzh@gmail.com

% Input glass plate image
% create an array of image name


imgname_array ={'00016v.jpg','00069v.jpg','00018v.jpg','00026v.jpg','00066v.jpg','00054v.jpg','00037v.jpg'};
imgname_array{end+1}='01087v.jpg';
imgname_array{end+1}='00978v.jpg';

for i = 1:length(imgname_array)
	%imgname = '00978v.jpg';
	%imgname = '01087u.tif';
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
	[aG vG] = alignSingle(G,B,0.1,-20,20,-20,20);
	disp('displacement vector for G on B:');
	disp(vG');
	[aR vR] = alignSingle(R,B,0.1,-20,20,-20,20);
	disp('displacement vector for R on B:');
	disp(vR');
		% aG = alignMulti(G,B);
	% aR = alignMulti(R,B);

	toc;   % The Timer stops and displays time elapsed.
	fprintf('\n');

	%% Output Results

	% Create a color image (3D array): "cat" command
	% For your own code, "G","R" shoule be replaced to "aG","aR"
	colorImg = cat(3,R,G,B);
	colorImg_dis = cat(3,aR,aG,B);

	[crop_image, edge_image, border_image]= border_detection(colorImg_dis,vG,vR);
	

	% Save result image to File
	imwrite(colorImg,['original-align-' imgname]);
	imwrite(colorImg_dis,['single-' strcat('displace-',imgname)]);
	imwrite(crop_image, ['after-crop-' imgname]);
	imwrite(border_image,['border-' imgname]);
	imwrite(edge_image,['edge-' imgname]);
end









