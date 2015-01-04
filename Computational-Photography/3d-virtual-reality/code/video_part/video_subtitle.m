

% blend a color onto the frame

obj = VideoReader('input1.mp4');
get(obj);
vHeight = obj.Height; % frame hight and width
vWidth = obj.Width;

% find lower 0.6-0.8 location
band_width = vWidth;
band_height = round(0.17*vHeight);

trans = 0.6;
A_frame = zeros(vHeight,vWidth,3);

% position: 0.35~
A_frame(round(vHeight*0.45) : round(vHeight*0.45)+band_height-1,:,:) = trans;
% imshow(A_frame)

% prepare background color 
bg_frame = zeros(vHeight,vWidth,3); % black




frame_per_sec = obj.duration/obj.NumberOfFrames;  % frame per second
% ======================================
% prepare sub here, stored in 
% sub1
% 0 - 3s 
% 
relative = 5;


text = 'so with two slits in it and either slit is observed,';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [80,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [80+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);




sub_l{1} = textInserter_l;
sub_r{1} = textInserter_r;
range{1} = round(0/frame_per_sec) : round(3/frame_per_sec);


% sub2
text = 'it will not go through both slits.';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [135,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [135+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);



sub_l{2} = textInserter_l;
sub_r{2} = textInserter_r;
range{2} = round(3/frame_per_sec) : round(6/frame_per_sec);

% sub3
text = 'If it "s unobserved, it will.';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [170,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [170+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);



sub_l{3} = textInserter_l;
sub_r{3} = textInserter_r;
range{3} = round(6/frame_per_sec) : round(7/frame_per_sec);

% sub4
text = 'However,if it"s observed after it"s left the plane but before it hits its target,';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [25,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 15, 'Location', textLocation_l);
textLocation_r = [25+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 15, 'Location', textLocation_r);


sub_l{4} = textInserter_l;
sub_r{4} = textInserter_r;
range{4} = round(7/frame_per_sec) : round(10/frame_per_sec);

% sub5
text = 'it will not have gone though both slits.';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [100,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [100+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);



sub_l{5} = textInserter_l;
sub_r{5} = textInserter_r;
range{5} = round(10/frame_per_sec) : round(12/frame_per_sec);

% sub6
text = 'Agreed. What"s your point?';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [170,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [170+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);



sub_l{6} = textInserter_l;
sub_r{6} = textInserter_r;
range{6} = round(12/frame_per_sec) : round(15/frame_per_sec);

% sub 7
text = 'There"s no point. I just think. it"s a good idea for a t-shirt.';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [50,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 18, 'Location', textLocation_l);
textLocation_r = [50+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 18, 'Location', textLocation_r);



sub_l{7} = textInserter_l;
sub_r{7} = textInserter_r;
range{7} = round(15/frame_per_sec) : round(17/frame_per_sec);

% sub 8
text = 'Excuse me.';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [270,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [270+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);



sub_l{8} = textInserter_l;
sub_r{8} = textInserter_r;
range{8} = round(23/frame_per_sec) : round(24/frame_per_sec);

% sub 9
text = 'Hang on.';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [270,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [270+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);



sub_l{9} = textInserter_l;
sub_r{9} = textInserter_r;
range{9} = round(24/frame_per_sec) : round(26/frame_per_sec);

% sub 10
text = 'Uh,one across is "aegean. "';
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [170,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);
textLocation_r = [170+relative,round(vHeight*0.5)];  
textInserter_r = vision.TextInserter(text, 'Color', textColor, 'FontSize', 22, 'Location', textLocation_r);



sub_l{10} = textInserter_l;
sub_r{10} = textInserter_r;
range{10} = round(29/frame_per_sec) : round(31/frame_per_sec);
% any(j == range{1~9})
% ========================================
% try disparity 
%{
textColor    = [255, 255, 255]; % [red, green, blue]
textLocation_l = [100,round(vHeight*0.5)];       % [x y] coordinates
textInserter_l = vision.TextInserter('Peppers are good for you!', 'Color', textColor, 'FontSize', 22, 'Location', textLocation_l);

J = step(textInserter_l, bg_frame);

depth = 1- J(:,:,1); % assume depth map
f = 45; % in mm
b = 40;
screenWidth = 45;
[x,y,~] = size(depth_logo_frame);
% get disparity map
disparity = scale_image(depth2disparity(depth,b,f,y,screenWidth,350,100));

[Left_A, Right_A] = disparity2stero(J, disparity, 10);
%}

%===========================


video_left = VideoWriter('left_sub.mp4', 'MPEG-4');
video_left.FrameRate = obj.FrameRate; % Play with this number to get desired smoothness in video speed
video_left.Quality = 100; % by default this is 75
open(video_left);
video_right = VideoWriter('right_sub.mp4', 'MPEG-4');
video_right.FrameRate = obj.FrameRate; % Play with this number to get desired smoothness in video speed
video_right.Quality = 100; % by default this is 75
open(video_right);

for j = 1: obj.NumberOfFrames
	temp_frame = im2double(read(obj,j)); % one sample frame
	
	frame_blend_l = bg_frame .* A_frame + temp_frame .* (1 - A_frame);
	frame_blend_r = bg_frame .* A_frame + temp_frame .* (1 - A_frame);
	
	% add sub according to time to left and right

	% find range
	for k = 1 : 10
		if any(j == range{k})
			frame_blend_l = step(sub_l{k}, frame_blend_l);
			frame_blend_r = step(sub_r{k}, frame_blend_r);
		end
	end

	%imshow(0.5*(frame_blend_l+ frame_blend_r));
	writeVideo(video_left,frame_blend_l); 
	writeVideo(video_right,frame_blend_r); 
	disp(j);

end

close(video_left);
close(video_right);



