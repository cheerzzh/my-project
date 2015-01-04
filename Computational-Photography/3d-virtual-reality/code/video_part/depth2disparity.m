function dis = depth2disparity(depth,b,f,imgWidth,screenWidth,a1,a2);


T = depth*a1 + a2;

sizePP = screenWidth / imgWidth;
dis = (b*f)./T;


end