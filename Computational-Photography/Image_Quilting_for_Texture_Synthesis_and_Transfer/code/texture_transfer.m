%{
CSCI3290 HW3
Zhou Zhihao, 1155014412
cheerzzh@gmail.com  

%}


function [outputImg outRGB] = texture_transfer(inputImg, tarImg, alpha, szPatch, szOverlap, niter, isdebug, merge)

% take in RGB image
%% Input and Config

inputImg_rgb = im2double(inputImg);
tarImg_rgb = im2double(tarImg);


if ndims(inputImg_rgb)==2,
inputImg_rgb = repmat(inputImg_rgb,[1 1 3]); % repeat into 3D
inputImg = repmat(inputImg,[1 1 3]);
end; 

if ndims(tarImg_rgb)==2,
tarImg_rgb = repmat(tarImg_rgb,[1 1 3]); % repeat into 3D
tarImg = repmat(tarImg,[1 1 3]);
end; 


tarImg = rgb2gray(tarImg);
inputImg = rgb2gray(inputImg);


inputImg = im2double(inputImg);
tarImg = im2double(tarImg);

sizeout = size(tarImg);
outputImg = zeros(sizeout); % output image
outRGB = zeros(size(tarImg_rgb));
sizein = size(inputImg);



% merger the edge better
filt_w = 4;
smooth_filt = binomialFilter(filt_w)*binomialFilter(filt_w)'; % what?



%% Main Function
% may need more iteration 

rng(3290)

for iter = 1 : niter,

    % prepare top error to calculate SSD
    temp = ones([szOverlap szPatch]);
    errTop = xcorr2(inputImg.^2, temp);
    temp = ones([szPatch szOverlap]);
    errSide = xcorr2(inputImg.^2, temp);
    temp = ones([szPatch-szOverlap szOverlap]);
    errSidesmall = xcorr2(inputImg.^2, temp); % left bottom rigion

    temp = ones([szPatch szPatch]);
    errorTarget = xcorr2(inputImg.^2, temp);


    for i = [1:szPatch-szOverlap:sizeout(1)-szPatch+1, sizeout(1)-szPatch+1]
        for j = [1:szPatch-szOverlap:sizeout(2)-szPatch+1,sizeout(2)-szPatch+1]
        % % For the following TODOs, You should discuss the following cases
        % % 1. Synthesis texture given the existing top and left image
        % % 2. Synthesis texture for the left of the image
        % % 3. Synthesis texture for the top of the image
        % % 4. Synthesis texture for the first patch
        % % The implementation will be slight different among each cases. Be careful. 
        

        % % TODO#1 Find the existing shared region and target patch
        % % Extract shared region and target region
        % sharedTop = ;
        % sharedSide = ;
        % tarPatch = ;

        % % TODO#2 Compute the distance between existing shared texture region 
        % % and all patches in the input texture image
        % ... 
        % err = errTop + errSide;

        % % TODO#3 Compute the distance between the target patch and all patches
        % % in the input texture image
        % errTarget = ;


        % case 1
        blend_mask = logical(zeros([szPatch szPatch]));

        if (i > 1) & (j > 1), 
            sharedTop = outputImg(i:i+szOverlap-1,j:j+szPatch-1);
            err = errTop - 2 * xcorr2(inputImg, sharedTop) + sum(sharedTop(:).^2);
            err = err(szOverlap:end-szPatch+1,szPatch:end-szPatch+1); % remove invalid around edge

            sharedSide = outputImg(i+szOverlap:i+szPatch-1,j:j+szOverlap-1);
            err2 = errSidesmall - 2 * xcorr2(inputImg, sharedSide) + sum(sharedSide(:).^2);
            % trim the edge region
            err = err + err2(szPatch:end-szPatch+szOverlap+1, szOverlap:end-szPatch+1);



            % correspond error
            tarPatch = tarImg(i:i+szPatch-1,j:j+szPatch-1,:);

            errTarget = errorTarget - 2*xcorr2(inputImg,tarPatch) + sum(tarPatch(:).^2);
            errTarget = errTarget(szPatch:end-szPatch+1, szPatch:end-szPatch+1); % position matched

            % if iteration > 1, add previous synthezised error
            if(iter >1)
                synthezised_patch = outputImg(i:i+szPatch-1,j:j+szPatch-1,:);
                errSyn = errorTarget - 2*xcorr2(inputImg,synthezised_patch) + sum(synthezised_patch(:).^2);
                errSyn = errSyn(szPatch:end-szPatch+1, szPatch:end-szPatch+1);

                err = err + errSyn + alpha * errTarget;
            else
                err = err + alpha * errTarget; 
            end

            % sample a patach from candidates
            [ibest, jbest] = find(err <= 1.1*1.01*min(err(:)));
            c = ceil(rand * length(ibest));
            pos = [ibest(c) jbest(c)]; 

            % find minimum error boundary cut 
            previous = outputImg(i:i+szPatch-1,j:j+szPatch-1);
            newPatch = inputImg(pos(1):pos(1)+szPatch-1,pos(2):pos(2)+szPatch-1);

            err_sq = (newPatch - previous).^2;

            blend_mask = logical(zeros(size(err_sq)));  % to record the border
            blend_mask = dpmain(err_sq,szOverlap); 


        elseif i > 1 % left part
            % only sharedTop
            sharedTop = outputImg(i:i+szOverlap-1,j:j+szPatch-1);
            err = errTop - 2 * xcorr2(inputImg, sharedTop) + sum(sharedTop(:).^2);
            err = err(szOverlap:end-szPatch+1,szPatch:end-szPatch+1); % remove invalid around edge

            % correspond error
            tarPatch = tarImg(i:i+szPatch-1,j:j+szPatch-1,:);

            errTarget = errorTarget - 2*xcorr2(inputImg,tarPatch) + sum(tarPatch(:).^2);
            errTarget = errTarget(szPatch:end-szPatch+1, szPatch:end-szPatch+1); % position matched

            % if iteration > 1, add previous synthezised error
            if(iter >1)
                synthezised_patch = outputImg(i:i+szPatch-1,j:j+szPatch-1,:);
                errSyn = errorTarget - 2*xcorr2(inputImg,synthezised_patch) + sum(synthezised_patch(:).^2);
                errSyn = errSyn(szPatch:end-szPatch+1, szPatch:end-szPatch+1);

                err = err + errSyn + alpha * errTarget;
            else
                err = err + alpha * errTarget; 
            end

            % sample a patach from candidates
            [ibest, jbest] = find(err <= 1.1*1.01*min(err(:)));
            c = ceil(rand * length(ibest));
            pos = [ibest(c) jbest(c)]; 

            % find minimum error boundary cut 
            previous = outputImg(i:i+szPatch-1,j:j+szPatch-1);
            newPatch = inputImg(pos(1):pos(1)+szPatch-1,pos(2):pos(2)+szPatch-1);
            err_sq = (newPatch - previous).^2;

            blend_mask = logical(zeros(size(err_sq)));  % to record the border
            blend_mask(1:szOverlap,:) = dp(err_sq(1:szOverlap,:)')';

            
        elseif j > 1 % top part,  only sharedSide
            sharedSide = outputImg(i:i+szPatch-1,j:j+szOverlap-1);
            err = errSide - 2 * xcorr2(inputImg, sharedSide) + sum(sharedSide(:).^2);
            err = err(szPatch:end-szPatch+1,szOverlap:end-szPatch+1);

            % correspond error
            tarPatch = tarImg(i:i+szPatch-1,j:j+szPatch-1,:);

            errTarget = errorTarget - 2*xcorr2(inputImg,tarPatch) + sum(tarPatch(:).^2);
            errTarget = errTarget(szPatch:end-szPatch+1, szPatch:end-szPatch+1); % position matched

            % if iteration > 1, add previous synthezised error
            if(iter >1)
                synthezised_patch = outputImg(i:i+szPatch-1,j:j+szPatch-1,:);
                errSyn = errorTarget - 2*xcorr2(inputImg,synthezised_patch) + sum(synthezised_patch(:).^2);
                errSyn = errSyn(szPatch:end-szPatch+1, szPatch:end-szPatch+1);

                err = err + errSyn + alpha * errTarget;
            else
                err = err + alpha * errTarget; 
            end

            % sample a patach from candidates
            [ibest, jbest] = find(err <= 1.1*1.01*min(err(:)));
            c = ceil(rand * length(ibest));
            pos = [ibest(c) jbest(c)]; 

            % find minimum error boundary cut 
            previous = outputImg(i:i+szPatch-1,j:j+szPatch-1);
            newPatch = inputImg(pos(1):pos(1)+szPatch-1,pos(2):pos(2)+szPatch-1);
            err_sq = (newPatch - previous).^2;

            blend_mask = logical(zeros(size(err_sq)));  % to record the border

            blend_mask(:,1:szOverlap) = dp(err_sq(:,1:szOverlap));


            % find minimum error boundary cut 
        else % top-left starting patch
            % randoming sample one patch
            

            % if iteration > 1, add previous synthezised error
            if(iter >1)

                % correspond error
                tarPatch = tarImg(i:i+szPatch-1,j:j+szPatch-1,:);

                errTarget = errorTarget - 2*xcorr2(inputImg,tarPatch) + sum(tarPatch(:).^2);
                errTarget = errTarget(szPatch:end-szPatch+1, szPatch:end-szPatch+1); % position matched

                synthezised_patch = outputImg(i:i+szPatch-1,j:j+szPatch-1,:);
                errSyn = errorTarget - 2*xcorr2(inputImg,synthezised_patch) + sum(synthezised_patch(:).^2);
                errSyn = errSyn(szPatch:end-szPatch+1, szPatch:end-szPatch+1);

                err = errSyn + alpha * errTarget;

                 % sample a patach from candidates
                 [ibest, jbest] = find(err <= 1.1*1.01*min(err(:)));
                 c = ceil(rand * length(ibest));
                 pos = [ibest(c) jbest(c)]; 
             else
                pos = ceil(rand([1 2]) .* (sizein-szPatch+1));
            end
        end


        % % TODO#4 Find a minimum error boundary and merge the new texture
        % % patch to the existing image
        % outputTemp = ?;

        if merge == 0,
            blend_mask = logical(zeros([szPatch szPatch]));
        end

        
            blend_mask = rconv2(double(blend_mask),smooth_filt); % double
            


            blend_mask_rgb = repmat(blend_mask,[1 1 3]);


        % gray scale output image
        outputTemp = outputImg(i:i+szPatch-1,j:j+szPatch-1).* blend_mask + inputImg(pos(1):pos(1)+szPatch-1,pos(2):pos(2)+szPatch-1).*(1- blend_mask);
        %outputTemp = inputImg(pos(1):pos(1)+szPatch-1,pos(2):pos(2)+szPatch-1);
        outputImg(i:i+szPatch-1,j:j+szPatch-1) = outputTemp;


        % RGB version here
        outputTemp = outRGB(i:i+szPatch-1,j:j+szPatch-1,:).* blend_mask_rgb + inputImg_rgb(pos(1):pos(1)+szPatch-1,pos(2):pos(2)+szPatch-1,:).*(1- blend_mask_rgb);
        %outputTemp = inputImg_rgb(pos(1):pos(1)+szPatch-1,pos(2):pos(2)+szPatch-1,:);
        outRGB(i:i+szPatch-1,j:j+szPatch-1,:) = outputTemp;

        %% Show debug result
        if isdebug~=0
            %figure(3), imshow(outputImg, []);
            %figure(4), imshow(outRGB);

            figure(2);
            subplot(1,2,1);
            imshow(outputImg);
            subplot(1,2,2);
            imshow(outRGB);
        end
    end

    
end
% shrink patch size and alpha
szPatch = round(szPatch*0.7);
alpha = alpha*0.8;
end


end
