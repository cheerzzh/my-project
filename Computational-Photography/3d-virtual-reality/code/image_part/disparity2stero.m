
% make into a function
% input: source image, disparity map, multipler K
% output: save left and write image, display them

function [Left Right] = disparity2stero(img,dis,k);

	% for RGB separately
	Right = img;
	%# create coordinate grid for image A
	[x,y,z] = size(img);
	[xx,yy] = ndgrid(1:x,1:y);
	%# linearize the arrays, and add the offsets
	B = dis(:);
	xx = xx(:);
	yy = yy(:);
	xxShifted = xx;
	yyShifted = yy - B*k/2;
	yyShifted = yyShifted - yyShifted(1); % scale back to origin

	%# preassign C to the right size and interpolate
	for i = 1:3
		temp = img(:,:,i);
		C = temp;
		C(:) = griddata(xxShifted,yyShifted,temp(:),xx,yy);
		Right(:,:,i) = C;
	end


	% for RGB separately
	Left = img;
	%# create coordinate grid for image A
	[x,y,z] = size(img);
	[xx,yy] = ndgrid(1:x,1:y);
	%# linearize the arrays, and add the offsets
	B = dis(:);
	xx = xx(:);
	yy = yy(:);
	xxShifted = xx;
	yyShifted = yy + B*k/2;
	yyShifted = yyShifted - yyShifted(1); % scale back to origin

	%# preassign C to the right size and interpolate
	for i = 1:3
		temp = img(:,:,i);
		C = temp;
		C(:) = griddata(xxShifted,yyShifted,temp(:),xx,yy);
		Left(:,:,i) = C;
	end



	%{
	figure
	subplot(1,3,1)
	imshow(Left);
	subplot(1,3,2)
	imshow(Right);
	subplot(1,3,3)
	imshow(0.5*(Left+Right));

	imwrite(Left,'left.png')
	imwrite(Right,'right.png')
	imwrite(0.5*(Left+Right),'sum.png')
	%}

end
