function [aimg minVector] = alignSingle(img,B, cut_size, h_d,h_u, v_d,v_u)
% This function is to align img to B using single-scale algorithms
% [d u] is a the search range for the possible displacement vector
% Output is the aligned version of img
	[h,w] = size(B);
	% foucus on the difference of the 90% of low and column
	ignore_h = floor(cut_size*h);
	ignore_w = floor(cut_size*w);
	range_h = ignore_h:h- ignore_h;
	range_w = ignore_w : w - ignore_w;
	% TODO: Write your codes for single-scale implementation
	% Initialize variables
	minMetric = inf; % minimum metric value
	minVector = zeros(2,1); % best shift vector by far
	
	%initialize function that will be used
	% 1. compute th
	

	% compare use gradient
	img_g = imgradient(img);
	B_g = imgradient(B);
	B_target = B_g(range_h,range_w);

	for i = h_d:h_u
		for j = v_d:v_u
			imr = circshift(img_g,[i ;j]); % shift the image on two directions
			% use sum of square to measure the distance
			temp = (imr(range_h,range_w) - B_target).^2;
			distance = sum(temp(:));
			%imr_target = imr(range_h,range_w);
			%distance = sumsqr(imr_target - B_target);
			if distance < minMetric
				minMetric = distance;
				minVector = [i;j];
		end
	end

	% Output aimg
    % disp(distance);
	aimg = circshift(img, minVector);
	
end


