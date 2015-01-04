

file = 'input1.mp4';
% use rescaled logo here
obj = VideoReader(file);
get(obj);
vHeight = obj.Height; % frame hight and width
vWidth = obj.Width;

logo = im2double(imread('logo2.png'));
logo_gary = rgb2gray(logo); % to find transparent part
A = zeros(size(logo_gary));
A(logo_gary==0) = 0;
A(logo_gary>0) = 1;
[logo_h, logo_w] = size(logo_gary); % size of logo

logo_small =  logo; % rescaled logo 
A_small = A;

% get one frame, blending logo with alpha map
A_frame = zeros(vHeight,vWidth);
% merge the logo alpha map into the frame alpha. determine location of logo here
point = [round(0.4*vHeight),round(0.4*vWidth)];
logo_small_size = size(logo_small);
A_frame(point(1):(point(1)+logo_small_size(1)-1),point(2):(point(2)+logo_small_size(2))-1) = A_small;
A_frmae_3d = zeros(vHeight,vWidth,3);
% merge the logo into the frame size image
logo_frame = zeros(vHeight,vWidth,3);
for i = 1:3
	logo_frame(point(1):(point(1)+logo_small_size(1)-1),point(2):(point(2)+logo_small_size(2))-1,i) = logo_small(:,:,i);
	A_frmae_3d(:,:,i) = A_frame;
end

% do blending 
depth_logo_frame = 1- A_frame;
f = 45; % in mm
b = 40;
screenWidth = 45;
[x,y] = size(depth_logo_frame);
% get disparity map
disparity = scale_image(depth2disparity(depth_logo_frame,b,f,y,screenWidth,350,100));



% get two view according to disparity map
[Left_logo, Right_logo] = disparity2stero(logo_frame, disparity, 10);
[Left_A, Right_A] = disparity2stero(A_frmae_3d, disparity, 10);

Left_logo(Left_logo>1) = 1;
Right_logo(Right_logo>1) = 1;
Left_A(Left_A>1) = 1;
Right_A(Right_A>1) = 1;

Left_logo(Left_logo<0) = 0;
Right_logo(Right_logo<0) = 0;
Left_A(Left_A<0) = 0;
Right_A(Right_A<0) = 0;



%{
% or use shift directly
shift = 3;
for i = 1:3
	Left_logo(:,:,i) =  circshift(logo_frame(:,:,i),[0,-shift]);
	Right_logo(:,:,i) =  circshift(logo_frame(:,:,i),[0,shift]);
	Left_A(:,:,i) = circshift(A_frame,[0,-shift]); 
	Right_A(:,:,i) = circshift(A_frame,[0,shift]); 

end
%}


trans = 0.8; % alpha among 

%  hvfr = vision.VideoFileReader('input1.mp4','AudioOutputPort',true);
% create output video and open the file
video_left = VideoWriter('left_static.mp4', 'MPEG-4');
video_left.FrameRate = obj.FrameRate; % Play with this number to get desired smoothness in video speed
video_left.Quality = 100; % by default this is 75
open(video_left);
video_right = VideoWriter('right_static.mp4', 'MPEG-4');
video_right.FrameRate = obj.FrameRate; % Play with this number to get desired smoothness in video speed
video_right.Quality = 100; % by default this is 75
open(video_right);

videoFReader = vision.VideoFileReader(file); % read the input video


for j = 1: obj.NumberOfFrames
	temp_frame = im2double(read(obj,j)); % one sample frame
	%[temp_frame,AUDIO] = step(videoFReader);
	
	frame_blend_l = Left_logo .* Left_A*trans  + (1- Left_A*trans) .* temp_frame;
	frame_blend_r = Right_logo .* Right_A*trans + (1- Right_A*trans) .* temp_frame;
	
	% shift frame

	%imshow(0.5*(frame_blend_l+ frame_blend_r));
	writeVideo(video_left,frame_blend_l); 
	writeVideo(video_right,frame_blend_r); 

	%step(video_left,frame_blend_l,AUDIO);
	%step(video_right,frame_blend_r,AUDIO);

	disp(j);

end

close(video_left);
close(video_right);



% add animation to the logo, circular shift
% shift in the loop
%  hvfr = vision.VideoFileReader('input1.mp4','AudioOutputPort',true);
% create output video and open the file
video_left = VideoWriter('left_animate.mp4', 'MPEG-4');
video_left.FrameRate = obj.FrameRate; % Play with this number to get desired smoothness in video speed
video_left.Quality = 100; % by default this is 75
open(video_left);
video_right = VideoWriter('right_animate.mp4', 'MPEG-4');
video_right.FrameRate = obj.FrameRate; % Play with this number to get desired smoothness in video speed
video_right.Quality = 100; % by default this is 75
open(video_right);



% remove black line
[x,y,z] = size(Left_logo);
index = 1:round(y/10);
Left_logo(:,y,:) =0;
Right_logo(:,y,:) =0;
Left_A(:,y,:) =0;
Right_A(:,y,:) =0;
Left_logo(:,1,:) =0;
Right_logo(:,1,:) =0;
Left_A(:,1,:) =0;
Right_A(:,1,:) =0;

%videoFReader = vision.VideoFileReader(file);

for j = 1: obj.NumberOfFrames
	temp_frame = im2double(read(obj,j)); % one sample frame
	
	% shift to right
	shift = randsample(2*(1:3),1);
	for i = 1:3
		Left_logo(:,:,i) =  circshift(Left_logo(:,:,i),[0,shift]);
		Right_logo(:,:,i) =  circshift(Right_logo(:,:,i),[0,shift]);
		Left_A(:,:,i) = circshift(Left_A(:,:,i),[0,shift]); 
		Right_A(:,:,i) = circshift(Right_A(:,:,i),[0,shift]); 

	end

	% random jump
	if mod(j,50) == 0
		a = -0.2;b=0.2;
		r1 =  a + (b-a)*rand; % rand from -1 to 1
		r2 = a + (b-a)*rand;
		jump = [round(vHeight*r1), round(vWidth*r2)];
		for i = 1:3
			Left_logo(:,:,i) =  circshift(Left_logo(:,:,i),jump);
			Right_logo(:,:,i) =  circshift(Right_logo(:,:,i),jump);
			Left_A(:,:,i) = circshift(Left_A(:,:,i),jump); 
			Right_A(:,:,i) = circshift(Right_A(:,:,i),jump); 
		end

	end

	frame_blend_l = Left_logo .* Left_A*trans  + (1- Left_A*trans) .* temp_frame;
	frame_blend_r = Right_logo .* Right_A*trans + (1- Right_A*trans) .* temp_frame;
	
	% shift frame

	%imshow(0.5*(frame_blend_l+ frame_blend_r));
	writeVideo(video_left,frame_blend_l); 
	writeVideo(video_right,frame_blend_r); 
	disp(j);

end

close(video_left);
close(video_right);


% audio
%[y,Fs] = audioread(file);
%soubd(y,fs) % play the sound
% write to audio, and combine


% combine audio & video
% use
% ex_combine_video_and_audio_streams
















