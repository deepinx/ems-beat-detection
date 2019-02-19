% the main program

% clc
clear

% start timing
tic

% file name
% matName = './AbpSignal/248m.mat';
% infoName = './AbpSignal/248m.info';
MaxIterLoop = 10;
MeanShiftStep = 20;

% read data from file
% fprintf('Reading Data From %s...\n',matName);
% [val, Fs] = ReadDataATM(matName,infoName);
% data = val(400000:450000);
fprintf('\n\nReading Data From ABP.mat...(abp1)\n');
load ./AbpSignal/ABP
data = abp1;
Fs = 125;
% Fs = 1/interval;  % Sampling Frequency

% zero-phase lowpass filter
b=[1 2 1]*0.052;
a=[1 -1.37 0.58];
dataf=filtfilt(b,a,data);

% calculate heart rate using PSD
HeartRate = PsdCalcHR(data, Fs);
fprintf('Estimating Heat Rate Using PSD...(%.0f/min)\n', HeartRate);

% calculate SSF
ssf = SSF(dataf, length(dataf), HeartRate, Fs);
% plot(ssf); hold on

% mean shift detect peaks
h=0.18/(HeartRate/60)*Fs;
peak = MeanShiftDetectPeak(ssf, h, MeanShiftStep);
% plot(peak,ssf(peak),'ro')

% IBI Classification Logic
mIBI = 60/(HeartRate)*Fs;
lastPeak = zeros(1,1);
IBI = peak(2:end)-peak(1:end-1);
overPeak = find(IBI(1:end-1)<mIBI/1.75|IBI(2:end)<mIBI/1.75)+1;
% stem(peak(overPeak), data(peak(overPeak)), 'r+')
peak(overPeak) = [];   % delete over peaks in the array
for iterLoop = 1:MaxIterLoop  % 最大迭代次数
    IBI = peak(2:end)-peak(1:end-1);
    missPeak = find(IBI(1:end-1)>mIBI/0.75);
    % stem(peak(missPeak), ssf(peak(missPeak)), 'r*')
    % missPeak = missPeak+(0:length(missPeak)-1);
    for i=1:length(missPeak)
        pos = missPeak(i);
        w = round(60/(HeartRate*1.75)*Fs);
        missData = data(peak(pos)+w:peak(pos+1)-w);
        findPeak = find(missData==max(missData),1);
        if (findPeak~=1)&&(findPeak~=length(missData))
            peak = [peak(1:pos) findPeak+peak(pos)+w peak(pos+1:end)]; 
            missPeak = missPeak+[zeros(1,i),ones(1,length(missPeak)-i)];
        end
        % plot(missData); hold on; 
        % plot(findPeak-w,missData(findPeak-w),'ro');
    end
    % conditions to end the iteration
    if isempty(missPeak)
        break;
    elseif isequal(missPeak,lastPeak)
        break;
    else
        lastPeak = missPeak;
    end
end

% final calibrate the peaks
fprintf('Calibrating Peak From Nearest Maxima...\n');
peak = CalibrePeak(data, peak, 6);

% stop timing and show elapsed time
toc

% plot the detection result
t = (1:length(data))/Fs;
h  = plot(t, data, peak/Fs, data(peak), ...
    'ro', d1/Fs, data(d1), 'k+',...
    dDT1./Fs, data(dDT1), 'r.',...
    dJM1./Fs, data(dJM1), 'gx'); 
set(h, 'Markersize', 8);
legend('Raw Signal', 'SMSS Detector','Previous Detector',...
            'Expert-1 (DT)', 'Expert-2 (JM)');
xlabel('Time, s');
ylabel('Signal & Detection');

% Benchmard Parameters of the method
% sensitivity and positive predictivity
acceptInt = 1;
[TP, FN, FP] = BenchmarkPara(peak, dDT1, acceptInt);
fprintf('SMSS Detector: Se=%2.3f%%, +P=%2.3f%%\n', ...
            TP/(TP+FN)*100, TP/(TP+FP)*100);
[TP, FN, FP] = BenchmarkPara(d1, dDT1, acceptInt);
fprintf('Prev Detector: Se=%2.3f%%, +P=%2.3f%%\n', ...
            TP/(TP+FN)*100, TP/(TP+FP)*100);

