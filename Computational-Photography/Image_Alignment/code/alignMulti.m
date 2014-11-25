function [aimg, minVector] = alignMulti(img,B,cut_size,pyramid_levels,search_range)
% This function is to align img to B using multi-scale algorithms
% Output is the aligned version of img
	[h,w] = size(B);
	% TODO: Write your codes for multi-scale implementation
	% TODO: Build Image Pyramid for img & B
	pyramid_scale = 2;
	%pyramid_levels = 6; % choose your value 2^5 = 
	gaussianf = fspecial('gaussian', [5,5], 1.5); % change if you need
	
	minVector = zeros(2,1); % initialize the displacement vector
	%search_range = 10;

	% v(1)+- search_range, v(2) +- search_range

	imgs = cell(pyramid_levels,1);
	imgs{1} = img;
	Bs = cell(pyramid_levels,1);
	Bs{1} = B;
	
	for ilevel = 2:1:pyramid_levels
		% write your code
		% scale B first
		oldI = imfilter(Bs{ilevel-1},gaussianf);
		newI = oldI(1:2:end, 1:2:end);
		Bs{ilevel} = newI;

		%scale img
		oldI = imfilter(imgs{ilevel-1},gaussianf);
		newI = oldI(1:2:end, 1:2:end);
		imgs{ilevel} = newI;

	end
	
	% TODO: Match using Image Pyramids
	for ilevel = pyramid_levels:-1:1

		temp_d = minVector - search_range;
		temp_u = minVector + search_range;
		h_d = temp_d(1); h_u = temp_u(1);v_d = temp_d(2);v_u = temp_u(2);
		[aimg,minVector] = alignSingle(imgs{ilevel},Bs{ilevel},cut_size,h_d,h_u,v_d,v_u);
		minVector = minVector.*pyramid_scale;

	end
	
	% Output aimg
	minVector = minVector ./ pyramid_scale;
	%aimg = circshift(img, minVector);

	
end


