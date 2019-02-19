% 用mean-shift方法找出波形的极值点

function peak = MeanShiftDetectPeak(data, h, step)

fprintf('Detecting Peak Using Mean Shift Algorithm...\n');

% notice: 0<=data<=1, i.e., data should be normalize as
rawData=(data-min(data))./(max(data)-min(data));

% h is the standard deviation of gauss corn
% P wave <0.12s; T wave <0.2s
% suppose the waves as a guass function, then the width (time duration)
% contains 2*sigma points
% therefore sigma=time duration*sfecg/2
        
peak=[];
x0=3*h;


while( x0 < length(rawData) )
%      peak_temp=MyMeanShift(rawData,x0,h,0.1);
     peak_temp=WinMeanShift(rawData,x0,h,0.1);  % using windowed mean shift
     if isempty(peak);
        peak=[peak peak_temp];
     else
        if abs(peak_temp-peak(end))>step % parameter
            peak=[peak peak_temp];
        end
     end
     x0=max(peak(end),x0+step);
end

peak = round(peak);


