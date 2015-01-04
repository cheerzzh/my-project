function T = scale_image(I)


	T = (I-min(I(:))) ./ (max(I(:)-min(I(:))));

end