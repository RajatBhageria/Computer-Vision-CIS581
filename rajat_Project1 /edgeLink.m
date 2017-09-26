function E = edgeLink(M, Mag, Ori)
%%  Description
%       use hysteresis to link edges
%%  Input: 
%        M = (H, W), logic matrix, output from non-max suppression
%        Mag = (H, W), double matrix, the magnitude of gradient
%    		 Ori = (H, W), double matrix, the orientation of gradient
%
%%  Output:
%        E = (H, W), logic matrix, the edge detection result.
%
%% ****YOU CODE STARTS HERE**** 
[H,W] = size(Mag);

%Get all the magnitudes of all the non-zeros 
J = M .* Mag;

%set the thresholds
k_low = 3.75; 
k_high = 2.5 * k_low; 

high = J >= k_high;
halves = ((J >= k_low) & (J < k_high)).*.5;
high_low = high + halves;

%% Descretize 
angle = Ori; 
angle(angle<0) = pi+angle(angle<0);
angle(angle>7*pi/8) = pi-angle(angle>7*pi/8);
angle(angle>=0&angle<pi/8) = 0;
angle(angle>=pi/8&angle<3*pi/8) = pi/4;
angle(angle>=3*pi/8&angle<5*pi/8) = pi/2;
angle(angle>=5*pi/8&angle<=7*pi/8) = 3*pi/4;

% numOnesBefore=0;
% numOnesAfter=0;

for row = (1:H)
    for col = (1:W)
        if (high_low(row,col) == 1)
%             numOnesBefore = numOnesBefore+1;
            hysteresis(row,col);
        end
    end
end 

function [] = hysteresis(row, col)
    edge = angle(row,col) + pi/2;
    
    switch edge 
        case pi/2
            if allowed(row-1, col)
                if (high_low(row-1, col)==0.5)
                    high_low(row-1, col)=1;
                    hysteresis(row-1,col);
                end
            end 
            
            if allowed(row+1, col)
                if (high_low(row+1, col)==0.5)
                    high_low(row+1, col)=1;
                    hysteresis(row+1,col);
                end
            end
            
        case 3*pi/4
            if allowed(row-1,col-1)
                if (high_low(row-1, col-1)==0.5)
                    high_low(row-1, col-1)=1;
                    hysteresis(row-1,col-1);
                end
            end
            if allowed(row+1, col+1)
                if (high_low(row+1, col+1)==0.5)
                    high_low(row+1, col+1)=1;
                    hysteresis(row+1,col+1);
                end
            end
            
        case pi
            if allowed(row, col-1)
                if (high_low(row, col-1)==0.5)
                    high_low(row, col-1)=1;
                    hysteresis(row,col-1);
                end
            end
            if allowed(row, col+1)
                if (high_low(row, col+1)==0.5)
                    high_low(row, col+1)=1;
                    hysteresis(row,col+1);
                end
            end
            
        case 5*pi/4
            if allowed(row+1, col-1)
                if (high_low(row+1, col-1)==0.5)
                    high_low(row+1, col-1)=1;
                    hysteresis(row+1,col-1);
                end
            end
            if allowed(row-1, col+1)
                if (high_low(row-1, col+1)==0.5)
                    high_low(row-1, col+1)=1;
                    hysteresis(row-1,col+1);
                end
            end
    end
    
end

function out = allowed(row,col)
    out = (row > 0) | (col > 0) | (row < H) | (col < W);
end

% for row = (1:H)
%     for col = (1:W)
%         numOnesAfter = numOnesAfter + 1;
%     end
% end

% disp(numOnesAfter - numOnesBefore); 

E = high_low==1;

end
    

