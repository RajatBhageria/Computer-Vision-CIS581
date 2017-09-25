function M = nonMaxSup(Mag, Ori)
%%  Description
%       compute the local minimal along the gradient.
%%  Input: 
%         Mag = (H, W), double matrix, the magnitude of derivative 
%         Ori = (H, W), double matrix, the orientation of derivative
%%  Output:
%         M = (H, W), logic matrix, the edge map
%
%% ****YOU CODE STARTS HERE**** 
[H,W] = size(Mag);

%set up meshgrid
[x,y] = meshgrid(1:W,1:H);

%constant value to thin edges further 
magnitude = 0.2;

%Get the pixel coordinates in the positive and negative directions 
x_positive = x + cos(Ori).*magnitude;
y_positive = y + sin(Ori).*magnitude;

x_negative = x - cos(Ori).*magnitude; 
y_negative = y - sin(Ori).*magnitude;

%Get the interpolated pixel intensities for virtual pixels 
VqPositive = interp2(x,y,Mag,x_positive,y_positive);
VqNegative = interp2(x,y,Mag,x_negative,y_negative);

M(:,:) = Mag(:,:);
M((VqPositive > Mag) | (VqNegative > Mag)) = 0;
M = M > 10;

end