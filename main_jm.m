% the main program

% clc
clear

% start timing
tic

% file name
% matName = './AbpSignal/248m.mat';
% infoName = './AbpSignal/248m.info';
acceptInt = 6;
MaxIterLoop = 10;
MeanShiftStep = 20;

% read data from file
% fprintf('Reading Data From %s...\n',matName);
% [val, Fs] = ReadDataATM(matName,infoName);
% data = val(400000:450000);
fprintf('\n\nReading Data From ABP.mat...(abp1)\n');
load ./AbpSignal/POX
data = pox1;
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

% Benchmard Parameters of the method
% sensitivity and positive predictivity
dJM1 = CalibrePeak(data, dJM1, 6);
pos = peak>=dJM1(1)-20&peak<=dJM1(end)+20;
[TP1, FN1, FP1] = BenchmarkPara(peak(pos), dJM1, acceptInt);
pos = d1>=dJM1(1)-20&d1<=dJM1(end)+20;
[TP2, FN2, FP2] = BenchmarkPara(d1(pos), dJM1, acceptInt);


% start timing
tic
        
% read data from file
% fprintf('Reading Data From %s...\n',matName);
% [val, Fs] = ReadDataATM(matName,infoName);
% data = val(400000:450000);
fprintf('\n\nReading Data From ABP.mat...(abp2)\n');
load ./AbpSignal/POX
data = pox2;
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

% benchmark parameters
dJM2 = CalibrePeak(data, dJM2, 6);
pos = peak>=dJM2(1)-20&peak<=dJM2(end)+20;
[TP, FN, FP] = BenchmarkPara(peak(pos), dJM2, acceptInt);
TP1=TP1+TP; FN1=FN1+FN; FP1=FP1+FP;
fprintf('SMSS Detector: Se=%2.3f%%, +P=%2.3f%%\n', ...
            TP1/(TP1+FN1)*100, TP1/(TP1+FP1)*100);
pos = d2>=dJM2(1)-20&d2<=dJM2(end)+20;
[TP, FN, FP] = BenchmarkPara(d2(pos), dJM2, acceptInt);
TP2=TP2+TP; FN2=FN2+FN; FP2=FP2+FP;
fprintf('Prev Detector: Se=%2.3f%%, +P=%2.3f%%\n', ...
            TP2/(TP2+FN2)*100, TP2/(TP2+FP2)*100);