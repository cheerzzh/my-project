%CSCI3290 Asg1
% function to automatically detect the border of the image and perform cropping


function [crop_img BW border_image] = border_detection(RGB,vG,vR)

	vG = [8 3];
	vR = [17 5];
	%RGB = imread('single-displace-01087v.jpg');

	[h w c] = size(RGB);
	u = 1:h;
	u_adj = intersect(u+vG(2), u+vR(2));
	u_adj =intersect(u,u_adj);
	v = 1:w;
	v_adj = intersect(v+vG(1), v+vR(1));
	v_adj =intersect(v,v_adj);

	crop_img = RGB(u_adj,v_adj,:);
	I  = rgb2gray(crop_img);
	BW = edge(I,'canny');
	
	% Compute the Hough transform of the image using the hough function.
	[H,theta,rho] = hough(BW);

	

	%Find the peaks in the Hough transform matrix, H, using the houghpeaks function.
	P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

	

	% Find lines in the image using the houghlines function.
	lines = houghlines(BW,theta,rho,P,'FillGap',1,'MinLength',50);

	% Create a plot that superimposes the lines on the original image.
	figure,imshow(I), hold on
	max_len = 0;
	for k = 1:length(lines)
	   xy = [lines(k).point1; lines(k).point2];
	   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

	   % Plot beginnings and ends of lines
	   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
	   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

	   % Determine the endpoints of the longest line segment
	   len = norm(lines(k).point1 - lines(k).point2);
	   if ( len > max_len)
	      max_len = len;
	      xy_long = xy;
	   end
	end
	s = getframe;
	border_image = s.cdata;
	% highlight the longest line segment
	plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
	hold off
	% for each line,check the conditions

	[h w] = size(I);
	left = 1; right=w;up=1;down=h;
	%set bound later

	for k = 1:length(lines)
		xy = [lines(k).point1; lines(k).point2];
		theta = lines(k).theta;
		if (abs(theta) == 90) % horizontal
			if(xy(1,2) > round(h*5/6)) % right edge
				if(xy(1,2)<down)
					down = xy(1,2);
				end
			else if(xy(1,2) < round(h/6))
				if(xy(1,2)>up)
					up = xy(1,2);
				end
			end
			end
		end

		if (abs(theta) == 0) % vertical
			if(xy(1,1) > round(w*5/6)) % right edge
				if(xy(1,1)<right)
					right = xy(1,1);
				end
			else if (xy(1,1) < round(w/6))
				if(xy(1,1)>left)
					left = xy(1,1);
				end
			end
		end
		end
	end

	v1 = up:down;
	v2 = left:right;

	crop_img = crop_img(v1,v2,:);
	

end





