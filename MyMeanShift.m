function peak = MyMeanShift(ECGBeat, x0, h, epsilon)
% Yan Jingyu: To ECGData h=15 epsilon=0.1
% notice: 0<=data<=1, i.e., data should be normalize as

ECGBeat=(ECGBeat-min(ECGBeat))./(max(ECGBeat)-min(ECGBeat));

% locating the mode of data (local maxima of density function)
% using mean shift.
% x0 - the start point to search peak
% h - Gaussian kernel with parameter h (window size)
% eps - epsilon accuracy of mean shift step. i.e. how small m_hG to be
%       considered as no improvement - NOT RECCOMAND eps = 0!!
% data - a dxN matrix of N vector of d dimension
% peak - the peak obtained from x0

N=length(ECGBeat);
eps2 = epsilon*epsilon;

[peak, score] = mean_shift_iteration(x0, ECGBeat, h, eps2);


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
function [mode, score] = mean_shift_iteration(x0, ECGBeat, h, eps2, per)
% iterate mean shift search from starting point x


% compute the first mean shift step
[ms, score] = m_hG(x0, ECGBeat, h);

% iterate untill no step is achieved
while  ( (ms-x0).^2 >= eps2 ) 
    x0 = ms;
    [ms, score] = m_hG(x0, ECGBeat, h);  
end

mode = ms;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ms, score]=m_hG(x0, ECGBeat, h)
% compute the mean shift of the data
% x - relative to x location
% data - dxN 
% h - gaussian window

%       SUM Xi exp( -.5 || dist(X,Xi)/h ||^2 ) * f(Xi)
% m   = -------------------------------------------------
%  h,G  SUM exp( -.5 || dist(X,Xi)/h ||^2 ) * f(Xi)

% e is the argument of the exponent in the term above: i.e. 1xN vector with
% ||X-Xi/h||^2 at the i-th column

e =( repmat(x0, 1, length(ECGBeat))-(1:length(ECGBeat)) ).^2 ./ (h.^2);
e = exp(-0.5*e).*ECGBeat;
score = sum(e); 

% the mean shift
ms =  ((1:length(ECGBeat))*e' ./ score);

