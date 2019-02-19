function peak = WinMeanShift(rawData, x0, h, epsilon)
% Liu Xiaochang: To ABPData h=15 epsilon=0.1

% locating the mode of data (local maxima of density function)
% using windowed mean shift.
% x0 - the start point to search peak
% h - Gaussian kernel with parameter h (window size)
% eps - epsilon accuracy of mean shift step. i.e. how small m_hG to be
%       considered as no improvement - NOT RECCOMAND eps = 0!!
% data - a dxN matrix of N vector of d dimension
% peak - the peak obtained from x0

N=length(rawData);
eps2 = epsilon*epsilon;

[peak, score] = mean_shift_iteration(x0, rawData, h, eps2, N);


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [mode, score] = mean_shift_iteration(x0, rawData, h, eps2, N)
% iterate mean shift search from starting point x


% compute the first mean shift step
[ms, score] = m_hG(x0, rawData, h, N);

% iterate untill no step is achieved
while  ( (ms-x0)^2 >= eps2 ) 
    x0 = ms;
    [ms, score] = m_hG(x0, rawData, h, N);  
end

mode = ms;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ms, score]=m_hG(x0, rawData, h, N)
% compute the mean shift of the data
% x - relative to x location
% data - dxN 
% h - gaussian window

%       SUM Xi exp( -.5 || dist(X,Xi)/h ||^2 ) * f(Xi)
% m   = -------------------------------------------------
%  h,G  SUM exp( -.5 || dist(X,Xi)/h ||^2 ) * f(Xi)

% e is the argument of the exponent in the term above: i.e. 1xN vector with
% ||X-Xi/h||^2 at the i-th column

% obtain windowed data
wl = max(round(x0-3*h),1);
wh = min(round(x0+3*h),N);
wData = rawData(wl:wh);

% the mean shift
e =( repmat(x0, 1, length(wData))-(wl:wh) ).^2 ./ (h.^2);
e = exp(-0.5*e).*wData;
score = sum(e); 
ms = ((wl:wh)*e' ./ score);

